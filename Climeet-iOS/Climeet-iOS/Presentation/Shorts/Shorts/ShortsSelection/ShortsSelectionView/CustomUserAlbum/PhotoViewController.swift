//
//  PhotoViewController.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos
import ComposableArchitecture
import Combine

final class PhotoViewController: UIViewController {
    // MARK: - Constants
    private enum Const {
        static let numberOfColumns = 4.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
        static let footerHeight: CGFloat = 50
    }
    
    // MARK: - UI Components
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
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(IndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: IndicatorFooterView.reuseId)
        
        return collectionView
    }()
    
    // MARK: - Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<PhotoSection, PhotoCellInfo>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<PhotoSection, PhotoCellInfo>
    private var dataSource: DataSource!
    
    private let store: StoreOf<CustomGalleryReducer>
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(store: StoreOf<CustomGalleryReducer>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupBindings()
        
        // 초기 데이터 로드 요청
        store.send(.requestPhotoAuthorization)
    }
    
    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        store.send(.setDefaults)
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        setupCollectionViewDataSource()
        setupFooterView()
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
                self?.store.send(.loadCellImage(indexPath: indexPath, item: item))
                
                return cell
            }
        )
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
                    for: indexPath
                  ) as? IndicatorFooterView else {
                return nil
            }
            
            footerView.delegate = self
            return footerView
        }
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
    
    private func setupBindings() {
        store.publisher.dataSource
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] items in
                self?.updateItems(items)
            }
            .store(in: &cancellables)
        
        //TODO: 수정 필요
//        store.publisher.updatingIndexPaths
//            .receive(on: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { [weak self] paths in
//                if paths == [] {
//                    print("updatingIndexPaths is empty")
//                    return
//                }
//                
//                self?.updateCells(paths)
//            }
//            .store(in: &cancellables)
        
//        store.publisher.loadedIndexPath
//            .receive(on: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { [weak self] path in
//                guard let path = path else {
//                    return
//                }
//                
//                self?.updateCells([path])
//            }
//            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func updateItems(_ items: [PhotoCellInfo]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateCells(_ indexPaths: [IndexPath]) {
        guard var snapshot = dataSource?.snapshot(),
              !indexPaths.isEmpty else { return }
        
        let uniqueIndexPaths = Set(indexPaths)
        let currentItems = store.state.dataSource
        
        let itemsToReload = uniqueIndexPaths.compactMap { indexPath -> PhotoCellInfo? in
            guard indexPath.item < currentItems.count else { return nil }
            let updatedItem = currentItems[indexPath.item]
            return updatedItem
        }
        
        if !itemsToReload.isEmpty {
            snapshot.reloadItems(itemsToReload)
            DispatchQueue.main.async { [weak self] in
                self?.dataSource?.apply(snapshot, animatingDifferences: false) {
                }
            }
        }
    }
    
    private func calculateImageSize() -> CGSize {
        return CGSize(width: Const.cellSize.width * Const.scale,
                      height: Const.cellSize.height * Const.scale)
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.send(.cellSelected(indexPath))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: Const.footerHeight)
    }
}

// MARK: - IndicatorFooterViewDelegate
extension PhotoViewController: IndicatorFooterViewDelegate {
    func footerViewDidTapLoadMore(_ footerView: UICollectionReusableView) {
        store.send(.loadNextBatch)
    }
}
