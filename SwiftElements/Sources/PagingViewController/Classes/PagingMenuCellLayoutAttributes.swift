//
//  PagingMenuCellLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/7.
//

import UIKit

open class PagingMenuCellLayoutAttributes: UICollectionViewLayoutAttributes {
	var progress: CGFloat = 0.0
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! PagingMenuCellLayoutAttributes
		copy.progress = progress
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? PagingMenuCellLayoutAttributes,
					rhs.progress != progress else {
			return false
		}
		
		return super.isEqual(object)
	}
}
