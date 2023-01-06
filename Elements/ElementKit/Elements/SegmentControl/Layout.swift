//
//  Layout.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

extension SegmentControl {
	struct Layout {
		var itemSpacing: CGFloat
		var contentInsets: UIEdgeInsets
		
		// Only works when style is indicator
		var titleInsets: UIEdgeInsets
    
		var titleColor: UIColor
		var selectedTitleColor: UIColor
    
		var backgroundColor: UIColor
		var selectedBackgroundColor: UIColor
		
		// Only works when style is indicator
		var indicatorColor: UIColor
		
		// Only works when style is oval
		var borderWidth: CGFloat
		var borderColor: UIColor
		
		var isRepeatTouchEnabled: Bool
    
		init(
			itemSpacing: CGFloat = 8,
			contentInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12),
			titleInsets: UIEdgeInsets = .zero,
      titleColor: UIColor = .systemBlue,
      selectedTitleColor: UIColor = .systemBlue,
      backgroundColor: UIColor = .white,
      selectedBackgroundColor: UIColor = .white,
      indicatorColor: UIColor = .systemBlue,
      borderWidth: CGFloat = 2,
			borderColor: UIColor = .systemBlue,
			isRepeatTouchEnabled: Bool = false
		) {
			self.itemSpacing = itemSpacing
      self.contentInsets = contentInsets
			self.titleInsets = titleInsets
      self.titleColor = titleColor
      self.selectedTitleColor = selectedTitleColor
      self.backgroundColor = backgroundColor
      self.selectedBackgroundColor = selectedBackgroundColor
      self.indicatorColor = indicatorColor
      self.borderWidth = borderWidth
      self.borderColor = borderColor
			self.isRepeatTouchEnabled = isRepeatTouchEnabled
		}
	}
}
