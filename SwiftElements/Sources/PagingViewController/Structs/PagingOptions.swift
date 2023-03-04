//
//  PagingOptions.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public struct PagingOptions {
  public var menuPosition: PagingMenuPosition
	
  public var pageScrollDirection: PageScrollDirection
	
  public var menuTransitionBehaviour: PagingMenuTransitionBehaviour
  
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
	
	public var menuInsets: UIEdgeInsets
	public var menuHeight: CGFloat {
		return itemSize.height + menuInsets.top + menuInsets.bottom
	}
	
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
  
  public var backgroundColor: UIColor
  public var selectedBackgroundColor: UIColor
	
	public init(
    menuPosition: PagingMenuPosition = .top,
		pageScrollDirection: PageScrollDirection = .horizontal,
		menuTransitionBehaviour: PagingMenuTransitionBehaviour = .scrollAlongside,
    
    itemSize: PagingItemSize = .sizeToFit(minWidth: 150, height: 40),
    itemSpacing: CGFloat = 0,
    itemLabelInsets: UIEdgeInsets = UIEdgeInsets(horizontal: 15),
    menuInsets: UIEdgeInsets = .zero,
    
		indicatorClass: PagingIndicatorView.Type = PagingIndicatorView.self,
    indicatorOptions: PagingIndicatorOptions = .visible(height: 3, spacing: .zero, insets: .zero, zIndex: Int.max),
		indicatorColor: UIColor = .systemBlue,
    
    borderClass: PagingBorderView.Type = PagingBorderView.self,
    borderOptions: PagingBorderOptions = .visible(height: 1, insets: .zero, zIndex: Int.max - 1),
    borderColor: UIColor = UIColor(white: 0.9, alpha: 1),
    
    font: UIFont = .systemFont(ofSize: 15, weight: .medium),
    selectedFont: UIFont = .systemFont(ofSize: 15, weight: .medium),
    textColor: UIColor = .black,
    selectedTextColor: UIColor = .systemBlue,
    
    backgroundColor: UIColor = .white,
    selectedBackgroundColor: UIColor = .white
	) {
		self.menuPosition = menuPosition
		self.pageScrollDirection = pageScrollDirection
    self.menuTransitionBehaviour = menuTransitionBehaviour
    
    self.itemSize = itemSize
    self.itemSpacing = itemSpacing
    self.itemLabelInsets = itemLabelInsets
		
		self.menuInsets = menuInsets
		
		self.indicatorClass = indicatorClass
    self.indicatorOptions = indicatorOptions
		self.indicatorColor = indicatorColor
    
    self.borderClass = borderClass
    self.borderOptions = borderOptions
    self.borderColor = borderColor
    
    self.font = font
    self.selectedFont = selectedFont
    self.textColor = textColor
    self.selectedTextColor = selectedTextColor
    
    self.backgroundColor = backgroundColor
    self.selectedBackgroundColor = selectedBackgroundColor
	}
}
