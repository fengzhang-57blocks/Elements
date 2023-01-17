//
//  Layout.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public extension SegmentControl {
	struct Layout {
		public var itemSpacing: CGFloat
		public var contentInsets: UIEdgeInsets
		
		public var titleColor: UIColor
		public var selectedTitleColor: UIColor
    
		public var backgroundColor: UIColor
		public var selectedBackgroundColor: UIColor
		
		// Only works when style is indicator
		public var indicatorColor: UIColor
    public var indicatorWidth: Layout.IndicatorWidth
		
		// Only works when style is oval
		public var borderWidth: CGFloat
		public var borderColor: UIColor
		
		public var isRepeatTouchEnabled: Bool
    
		public init(
			itemSpacing: CGFloat = 8,
			contentInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12),
			titleInsets: UIEdgeInsets = .zero,
      titleColor: UIColor = .systemBlue,
      selectedTitleColor: UIColor = .systemBlue,
      backgroundColor: UIColor = .white,
      selectedBackgroundColor: UIColor = .white,
      indicatorColor: UIColor = .systemBlue,
      indicatorWidth: Layout.IndicatorWidth = .automation,
      borderWidth: CGFloat = 2,
			borderColor: UIColor = .systemBlue,
			isRepeatTouchEnabled: Bool = false
		) {
			self.itemSpacing = itemSpacing
      self.contentInsets = contentInsets
      self.titleColor = titleColor
      self.selectedTitleColor = selectedTitleColor
      self.backgroundColor = backgroundColor
      self.selectedBackgroundColor = selectedBackgroundColor
      self.indicatorColor = indicatorColor
      self.indicatorWidth = indicatorWidth
      self.borderWidth = borderWidth
      self.borderColor = borderColor
			self.isRepeatTouchEnabled = isRepeatTouchEnabled
		}
	}
}

public extension SegmentControl.Layout {
  enum IndicatorWidth {
    case automation
    case fixed(CGFloat)
  }
}
