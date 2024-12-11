//
//  CollectionViewFooter.swift
//  Climeet-iOS
//
//  Created by mac on 11/28/24.
//

import Foundation
import UIKit

protocol IndicatorFooterViewDelegate: AnyObject {
    func footerViewDidTapLoadMore(_ footerView: UICollectionReusableView)
}

class IndicatorFooterView: UICollectionReusableView {
    static let reuseId = "loadMoreButton"
    weak var delegate: IndicatorFooterViewDelegate?
    
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .roundedRect)
        let buttonImage: UIImage = UIImage(systemName: "arrow.clockwise") ?? UIImage()
        button.tintColor = .gray
        button.setImage(buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        delegate?.footerViewDidTapLoadMore(self)
    }
}
