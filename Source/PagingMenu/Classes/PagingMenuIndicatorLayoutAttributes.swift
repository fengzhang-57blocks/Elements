//
//  PagingMenuIndicatorLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class PagingMenuIndicatorLayoutAttributes: UICollectionViewLayoutAttributes {
	open var backgroundColor: UIColor?
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! PagingMenuIndicatorLayoutAttributes
		copy.backgroundColor = backgroundColor
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? PagingMenuIndicatorLayoutAttributes,
				rhs.backgroundColor != backgroundColor else {
			return false
		}
		
		return super.isEqual(object)
	}
  
  func configure(with options: PagingMenuOptions) {
    guard case let .visible(height, _, insets, zindex) = options.indicatorOptions else {
      return
    }
    backgroundColor = options.backgroundColor
    frame.size.height = size.height
    
    switch options.position {
    case .top:
      frame.origin.y = options.height - height - insets.bottom + insets.top
    case .bottom:
      frame.origin.y = insets.bottom
    }
    
    zIndex = zindex
  }
}
