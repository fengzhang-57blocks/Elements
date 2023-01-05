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
    
		init(
			itemSpacing: CGFloat = 15,
			contentInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
		) {
			self.itemSpacing = itemSpacing
      self.contentInsets = contentInsets
		}
	}
}
