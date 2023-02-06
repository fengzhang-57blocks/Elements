//
//  TabConfigurations.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public struct TabControlOptions {
	public var itemSpacing: CGFloat
	public var contentInsets: UIEdgeInsets
	
	public var titleColor: UIColor
	public var selectedTitleColor: UIColor
	
	public var backgroundColor: UIColor
	public var selectedBackgroundColor: UIColor
	
	// Only works when style is indicator
	public var indicatorSize: TabControlOptions.IndicatorSize
	
	// Only works when style is oval
	public var borderWidth: CGFloat
	public var borderColor: UIColor
	
	public var isRepeatTouchEnabled: Bool
	
	// ----
  
  public var insets: UIEdgeInsets
  
  public var height: CGFloat {
    return tabSize.height + insets.top + insets.bottom
  }
  
  public var position: TabControlPosition
  
  public var tabSize: TabSize
	
  public var indicatorOptions: TabIndicatorOptions
  public var indicatorColor: UIColor
  public var indicatorClass: TabIndicatorView.Type
	
	
	public init(
		itemSpacing: CGFloat = 8,
		contentInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12),
		titleInsets: UIEdgeInsets = .zero,
		titleColor: UIColor = .systemBlue,
		selectedTitleColor: UIColor = .systemBlue,
		backgroundColor: UIColor = .white,
		selectedBackgroundColor: UIColor = .white,
		indicatorColor: UIColor = .systemBlue,
		indicatorSize: TabControlOptions.IndicatorSize = .init(width: .equal, height: 3),
		borderWidth: CGFloat = 2,
		borderColor: UIColor = .systemBlue,
		isRepeatTouchEnabled: Bool = false,
    
    insets: UIEdgeInsets = .zero,
    position: TabControlPosition = .top,
    tabSize: TabSize = .fixed(width: 50, height: 50),
		indicatorClass: TabIndicatorView.Type = TabIndicatorView.self,
    indicatorOptions: TabIndicatorOptions = .visible(height: 3, insets: .zero, zIndex: Int.max)
	) {
		self.itemSpacing = itemSpacing
		self.contentInsets = contentInsets
		self.titleColor = titleColor
		self.selectedTitleColor = selectedTitleColor
		self.backgroundColor = backgroundColor
		self.selectedBackgroundColor = selectedBackgroundColor
		self.indicatorColor = indicatorColor
		self.indicatorSize = indicatorSize
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.isRepeatTouchEnabled = isRepeatTouchEnabled
    
    self.insets = insets
    self.position = position
    self.tabSize = tabSize
		self.indicatorClass = indicatorClass
    self.indicatorOptions = indicatorOptions
	}
}

public extension TabControlOptions {
	enum IndicatorSizeBehaviour {
		case equal
		case fixed(CGFloat)
	}
	
	struct IndicatorSize {
		public var width: IndicatorSizeBehaviour
		public var height: CGFloat
		
		public init(width: IndicatorSizeBehaviour, height: CGFloat) {
			self.width = width
			self.height = height
		}
	}
}
