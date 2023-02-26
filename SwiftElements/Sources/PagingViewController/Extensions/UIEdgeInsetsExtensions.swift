//
//  UIEdgeInsetsExtensions.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/4.
//

import UIKit

public extension UIEdgeInsets {
	var horizontal: CGFloat {
		return left + right
	}
	
  init(horizontal: CGFloat) {
    self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
  }
}
