//
//  PhotoViewController.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos

final class PhotoViewController: UIViewController {
    private enum Const {
        static let numberOfColumns = 4.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
        static let footerHeight: CGFloat = 50
    }
    
    // MARK: UI
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.systemBlue, for: [.normal, .highlighted])
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.itemSize = Const.cellSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = UIColor(.climeetBackground)
        collectionView.clipsToBounds = true
        collectionView.register(PhotoCell.self,
                                forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(IndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: IndicatorFooterView.reuseId)
        
        return collectionView
    }()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<PhotoSection, PhotoCellInfo>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<PhotoSection, PhotoCellInfo>
    private var dataSource: DataSource!
    
    // MARK: Property
    private let albumService: AlbumService = MyAlbumService()
    private let photoService: PhotoService = MyPhotoService()
    private var selectedIndexArray = [Int]()
    private var albums = [PHFetchResult<PHAsset>]()
    private var viewModel: CustomGalleryViewModel?
    
    init(viewModel: CustomGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupViewModel()
    }
    
    //MARK: Private Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        setupCollectionViewDataSource()
        setupFooterView()
    }
    
    private func setupFooterView() {
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView,
             kind: String,
             indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard kind == UICollectionView.elementKindSectionFooter,
                  let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: IndicatorFooterView.reuseId,
                    for: indexPath) as? IndicatorFooterView else {
                return nil
            }
            
            footerView.delegate = self
            
            return footerView
        }
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCell.id,
                    for: indexPath
                ) as? PhotoCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(info: item)
                cell.currentTask?.cancel()
                
                cell.currentTask = Task { @MainActor in
                    guard let self = self else { return }
                    if let thumbnail = await self.photoService.fetchVideo(
                        phAsset: item.phAsset,
                        size: self.calculateImageSize(),
                        contentMode: .aspectFit,
                        deliveryMode: .fastFormat
                    ) {
                        guard let visibleCell = collectionView.cellForItem(at: indexPath) as? PhotoCell,
                              visibleCell == cell else {
                            return
                        }
                        
                        item.videoThumbnail = thumbnail
                        cell.configure(info: item)
                    }
                }
                
                return cell
            })
    }
    
    private func calculateImageSize() -> CGSize {
        return CGSize(width: Const.cellSize.width * Const.scale,
                      height: Const.cellSize.height * Const.scale)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViewModel() {
        self.viewModel?.delegate = self
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        Task {
            viewModel?.handleCellSelection(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: IndicatorFooterView.reuseId,
                for: indexPath) as? IndicatorFooterView else {
                return UICollectionReusableView()
            }
            
            return footer
        }
        return UICollectionReusableView()
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: Const.footerHeight)
    }
}

extension PhotoViewController: ShortsCustomGalleryDelegate {
    func updateItems(_ items: [PhotoCellInfo]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        if let existingItems = dataSource?.snapshot().itemIdentifiers {
            snapshot.appendItems(existingItems)
            let newItems = items.filter { !existingItems.contains($0) }
            snapshot.appendItems(newItems)
        } else {
            snapshot.appendItems(items)
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func updateCells(at indexPaths: [IndexPath]) {
        
        guard var snapshot = dataSource?.snapshot(),
                  let viewModel = self.viewModel else { return }
            
            var updatedItems = snapshot.itemIdentifiers
            
            // Set을 사용하여 중복된 인덱스 패스를 제거합니다
            let uniqueIndexPaths = Set(indexPaths)
            
            // 업데이트가 필요한 아이템들만 찾아서 교체합니다
            for indexPath in uniqueIndexPaths {
                guard indexPath.item < viewModel.dataSource.count,
                      let snapshotIndex = updatedItems.firstIndex(where: { $0.id == viewModel.dataSource[indexPath.item].id }) else {
                    continue
                }
                
                updatedItems[snapshotIndex] = viewModel.dataSource[indexPath.item]
            }
            
            var newSnapshot = Snapshot()
            newSnapshot.appendSections([.main])
            newSnapshot.appendItems(updatedItems)
            
            // 중복이 제거된 인덱스 패스로 아이템을 리로드합니다
            let itemsToReload = uniqueIndexPaths.compactMap { indexPath -> PhotoCellInfo? in
                guard indexPath.item < viewModel.dataSource.count else { return nil }
                return viewModel.dataSource[indexPath.item]
            }
            
            // 리로드할 아이템이 있을 때만 처리합니다
            if !itemsToReload.isEmpty {
                newSnapshot.reloadItems(Array(itemsToReload))
                dataSource?.apply(newSnapshot, animatingDifferences: false)
            }
//        guard var snapshot = dataSource?.snapshot() else { return }
//        let currentItems = snapshot.itemIdentifiers
//        let itemsToReload = indexPaths.compactMap { indexPath -> PhotoCellInfo? in
//            guard let viewModel = self.viewModel,
//                  indexPath.item < viewModel.dataSource.count,
//                  currentItems.contains(where: { $0.id == viewModel.dataSource[indexPath.item].id }) else {
//               
//                return nil
//            }
//            return viewModel.dataSource[indexPath.item]
//        }
//        
//        print(itemsToReload.map({ info in
//            info.selectedOrder
//        }))
//        
//        if !itemsToReload.isEmpty {
//              // 변경된 아이템들만 리로드합니다
//            snapshot.reconfigureItems(itemsToReload)
//              dataSource?.apply(snapshot, animatingDifferences: false)
//          }
    }
}

extension PhotoViewController: IndicatorFooterViewDelegate {
    func footerViewDidTapLoadMore(_ footerView: UICollectionReusableView) {
        viewModel?.loadNextBatch()
    }
}
