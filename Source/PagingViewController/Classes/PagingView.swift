//
//  PagingView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

open class PagingView: UIView {
	
	public let collectionView: UICollectionView
	public let pageView: UIView
	
	public let options: PagingMenuOptions
	
	public required init(collectionView: UICollectionView, pageView: UIView, options: PagingMenuOptions) {
		self.collectionView = collectionView
		self.pageView = pageView
		self.options = options
		super.init(frame: .zero)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func createLayout() {
		addSubview(collectionView)
		addSubview(pageView)
		setupConstraints()
	}
	
	open func setupConstraints() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		pageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: options.menuItemSize.height),
		])
		
		NSLayoutConstraint.activate([
			pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
		
		switch options.position {
		case .top:
			NSLayoutConstraint.activate([
				pageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
				pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			])
		case .bottom:
			NSLayoutConstraint.activate([
				pageView.topAnchor.constraint(equalTo: topAnchor),
				pageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
			])
		}
	}
}
