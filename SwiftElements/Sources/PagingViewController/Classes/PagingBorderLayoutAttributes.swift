//
//  PagingBorderLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/17.
//

import UIKit

open class PagingBorderLayoutAttributes: UICollectionViewLayoutAttributes {
	open var backgroundColor: UIColor?
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! PagingBorderLayoutAttributes
		copy.backgroundColor = backgroundColor
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? PagingBorderLayoutAttributes,
					rhs.backgroundColor != backgroundColor else {
			return false
		}
		
		return super.isEqual(rhs)
	}
}
