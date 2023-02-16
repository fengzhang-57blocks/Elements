//
//  PagingOptions.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public struct PagingOptions {
  public var position: PagingMenuPosition
  
  public var menuTransitionBehaviour: PagingMenuTransitionBehaviour
  
  public var menuItemSize: PagingMenuItemSize
  public var estimatedItemWidth: CGFloat {
    switch menuItemSize {
    case let .fixed(width, _):
      return width
    case let .selfSizing(estimatedWidth, _):
      return estimatedWidth
    }
  }
	
	public var insets: UIEdgeInsets
	public var height: CGFloat {
		return menuItemSize.height + insets.top + insets.bottom
	}
	
	public var indicatorClass: PagingMenuIndicatorView.Type
  public var indicatorOptions: PagingMenuIndicatorBehaviour
  public var indicatorColor: UIColor
	
	public init(
		position: PagingMenuPosition = .top,
		menuTransitionBehaviour: PagingMenuTransitionBehaviour = .scrollAlongside,
		menuItemSize: PagingMenuItemSize = .fixed(width: 50, height: 50),
		insets: UIEdgeInsets = .zero,
		indicatorClass: PagingMenuIndicatorView.Type = PagingMenuIndicatorView.self,
    indicatorOptions: PagingMenuIndicatorBehaviour = .visible(height: 3, spacing: .zero, insets: .zero, zIndex: Int.max),
		indicatorColor: UIColor = .systemBlue
	) {
		self.position = position
    self.menuTransitionBehaviour = menuTransitionBehaviour
    self.menuItemSize = menuItemSize
		
		self.insets = insets
		
		self.indicatorClass = indicatorClass
    self.indicatorOptions = indicatorOptions
		self.indicatorColor = indicatorColor
	}
	
	public static func `default`() -> PagingOptions {
		return PagingOptions()
	}
}
