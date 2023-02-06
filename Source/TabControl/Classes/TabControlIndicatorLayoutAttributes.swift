//
//  TabControlIndicatorLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class TabControlIndicatorLayoutAttributes: UICollectionViewLayoutAttributes {
	open var backgroundColor: UIColor?
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! TabControlIndicatorLayoutAttributes
		copy.backgroundColor = backgroundColor
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? TabControlIndicatorLayoutAttributes,
				rhs.backgroundColor != backgroundColor else {
			return false
		}
		
		return super.isEqual(object)
	}
}
