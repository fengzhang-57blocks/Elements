//
//  PagingBorderView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/17.
//

import UIKit

open class PagingBorderView: UICollectionReusableView {
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		if let attrs = layoutAttributes as? PagingBorderLayoutAttributes {
			backgroundColor = attrs.backgroundColor
		}
	}
}
