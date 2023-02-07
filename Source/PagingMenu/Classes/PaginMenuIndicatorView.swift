//
//  PaginMenuIndicatorView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class PaginMenuIndicatorView: UICollectionReusableView {
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		if let attrs = layoutAttributes as? PagingMenuIndicatorLayoutAttributes {
			backgroundColor = attrs.backgroundColor
		}
	}
}
