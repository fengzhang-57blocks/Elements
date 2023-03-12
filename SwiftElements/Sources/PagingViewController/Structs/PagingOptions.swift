//
//  PagingOptions.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public struct PagingOptions {
  public var pageScrollDirection: PageScrollDirection
  
  public var menuPosition: PagingMenuPosition
  public var menuInteraction: PagingInteraction
  public var menuTransitionBehaviour: PagingMenuTransitionBehaviour
  public var menuScrollPosition: PagingMenuScrollPosition
  public var menuAlignment: PagingMenuAlignment
  public var menuInsets: UIEdgeInsets
  public var menuHeight: CGFloat {
    return itemSize.height + menuInsets.top + menuInsets.bottom
  }
  public var menuBackgroundColor: UIColor
  
  public var contentInteraction: PagingInteraction
  
  public var itemSize: PagingItemSize
  public var itemSpacing: CGFloat
  public var itemLabelInsets: UIEdgeInsets
  public var estimatedItemWidth: CGFloat {
    switch itemSize {
    case let .fixed(width, _):
      return width
    case let .selfSizing(estimatedWidth, _):
      return estimatedWidth
    case let .sizeToFit(minWidth, _):
      return minWidth
    }
  }
  public var backgroundColor: UIColor
  public var selectedBackgroundColor: UIColor
	
	public var indicatorClass: PagingIndicatorView.Type
  public var indicatorOptions: PagingIndicatorOptions
  public var indicatorColor: UIColor
  
  public var borderClass: PagingBorderView.Type
  public var borderOptions: PagingBorderOptions
  public var borderColor: UIColor
  
  public var font: UIFont
  public var selectedFont: UIFont
  public var textColor: UIColor
  public var selectedTextColor: UIColor
  
	public init() {
    self.pageScrollDirection = .horizontal
  
    self.menuPosition = .top
    self.menuInteraction = .scrolling
    self.menuTransitionBehaviour = .scrollAlongside
    self.menuScrollPosition = .centeredHorizontally
    self.menuAlignment = .left
    self.menuInsets = .zero
    self.menuBackgroundColor = .white
  
    self.contentInteraction = .scrolling
  
    self.itemSize = .sizeToFit(minWidth: 150, height: 40)
    self.itemSpacing = 0
    self.itemLabelInsets = UIEdgeInsets(horizontal: 15)
    self.backgroundColor = .white
    self.selectedBackgroundColor = .white
  
    self.indicatorClass = PagingIndicatorView.self
    self.indicatorOptions = .visible(width: .flexible, height: 3, spacing: .zero, insets: .zero, zIndex: Int.max)
    self.indicatorColor = .systemBlue
  
    self.borderClass = PagingBorderView.self
    self.borderOptions = .visible(height: 1, insets: .zero, zIndex: Int.max - 1)
    self.borderColor = UIColor(white: 0.9, alpha: 1)
  
    self.font = .systemFont(ofSize: 15, weight: .medium)
    self.selectedFont = .systemFont(ofSize: 15, weight: .medium)
    self.textColor = .black
    self.selectedTextColor = .systemBlue
	}
}
