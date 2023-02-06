//
//  TabControlIndicatorView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class TabControlIndicatorView: UICollectionReusableView {
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		if let attrs = layoutAttributes as? TabControlIndicatorLayoutAttributes {
			backgroundColor = attrs.backgroundColor
		}
	}
}
