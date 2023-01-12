//
//  NSDirectionalEdgeInsetsExtensions.swift
//  Elements
//
//  Created by 57block on 2023/1/5.
//

import UIKit

public extension NSDirectionalEdgeInsets {
	init(insets: UIEdgeInsets) {
		self.init(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
	}
}
