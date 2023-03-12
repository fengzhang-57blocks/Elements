//
//  PagingBorderLayoutAttributes.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/17.
//

import UIKit

open class PagingBorderLayoutAttributes: UICollectionViewLayoutAttributes {
  open var insets: UIEdgeInsets = .zero
	open var backgroundColor: UIColor?
	
	open override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! PagingBorderLayoutAttributes
		copy.backgroundColor = backgroundColor
		return copy
	}
	
	open override func isEqual(_ object: Any?) -> Bool {
		guard let rhs = object as? PagingBorderLayoutAttributes else {
			return false
		}
    
    if rhs.backgroundColor != backgroundColor {
      return false
    }
		
		return super.isEqual(rhs)
	}
  
  func configure(with options: PagingOptions) {
    guard case let .visible(height, insets, zIndex) = options.borderOptions else {
      return
    }
    
    self.insets = insets
    
    frame.size.height = height
    
    switch options.menuPosition {
    case .top:
      frame.origin.y = options.menuHeight - height
    case .bottom:
      frame.origin.y = 0
    }
    
    backgroundColor = options.borderColor
    
    self.zIndex = zIndex
  }
  
  func update(from bounds: CGRect, contentSize: CGSize) {
    frame.origin.x = insets.left
    frame.size.width = max(bounds.width, contentSize.width) - insets.horizontal
  }
}
