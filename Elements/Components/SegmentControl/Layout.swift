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
    let horizontalSpacing: CGFloat
    
    let font: UIFont
    let contentInsets: UIEdgeInsets
    
		init(
      itemSpacing: CGFloat = 30,
      horizontalSpacing: CGFloat = 8,
      font: UIFont = .systemFont(ofSize: 15, weight: .medium),
      contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    ) {
			self.itemSpacing = itemSpacing
      self.horizontalSpacing = horizontalSpacing
      self.font = font
      self.contentInsets = contentInsets
		}
	}
}
