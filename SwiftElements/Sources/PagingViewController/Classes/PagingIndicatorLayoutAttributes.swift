//
//  PagingIndicatorLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

open class PagingIndicatorLayoutAttributes: UICollectionViewLayoutAttributes {
	open var backgroundColor: UIColor?
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! PagingIndicatorLayoutAttributes
		copy.backgroundColor = backgroundColor
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? PagingIndicatorLayoutAttributes else {
			return false
		}
    
    if rhs.backgroundColor != backgroundColor {
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
    
    switch options.menuPosition {
    case .top:
      frame.origin.y = options.menuHeight - height - insets.bottom + insets.top
    case .bottom:
      frame.origin.y = insets.bottom
    }
    
    zIndex = zindex
  }
  
  func update(from: PagingItemLayout, to: PagingItemLayout, progress: CGFloat) {
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
