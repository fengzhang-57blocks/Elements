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
  
  func configure(with options: PagingOptions) {
    guard case let .visible(height, _, insets, zindex) = options.indicatorOptions else {
      return
    }
    
    backgroundColor = options.indicatorColor
    frame.size.height = height
    
    switch options.position {
    case .top:
      frame.origin.y = options.height - height - insets.bottom + insets.top
    case .bottom:
      frame.origin.y = insets.bottom
    }
    
    zIndex = zindex
  }
  
  func updateSize(from: PagingMenuItemLayout, to: PagingMenuItemLayout, progress: CGFloat) {
		frame.origin.x = distance(
			from: from.x,
			to: to.x,
			percentage: progress
		)
		frame.size.width = distance(
			from: from.width,
			to: to.width,
			percentage: progress
		)
  }
}
