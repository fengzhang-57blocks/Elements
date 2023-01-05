//
//  Layout.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

extension SegmentControl {
	struct Layout {
		let itemSpacing: CGFloat
		let contentInsets: UIEdgeInsets
    
    let titleColor: UIColor
    let selectedTitleColor: UIColor
    
    let backgroundColor: UIColor
    let selectedBackgroundColor: UIColor
    
    let indicatorColor: UIColor
    
    let borderWidth: CGFloat
    let borderColor: UIColor
    
		init(
			itemSpacing: CGFloat = 15,
			contentInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12),
      titleColor: UIColor = .systemBlue,
      selectedTitleColor: UIColor = .systemBlue,
      backgroundColor: UIColor = .white,
      selectedBackgroundColor: UIColor = .red,
      indicatorColor: UIColor = .systemBlue,
      borderWidth: CGFloat = 2,
      borderColor: UIColor = .red
		) {
			self.itemSpacing = itemSpacing
      self.contentInsets = contentInsets
      self.titleColor = titleColor
      self.selectedTitleColor = selectedTitleColor
      self.backgroundColor = backgroundColor
      self.selectedBackgroundColor = selectedBackgroundColor
      self.indicatorColor = indicatorColor
      self.borderWidth = borderWidth
      self.borderColor = borderColor
		}
	}
}
