//
//  TabIndicatorOptions.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

public enum TabIndicatorOptions {
	case hidden
	case visible(
    height: CGFloat,
    insets: UIEdgeInsets,
    zIndex: Int
  )
}
