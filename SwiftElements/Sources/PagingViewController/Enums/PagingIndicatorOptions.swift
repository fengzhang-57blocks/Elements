//
//  PagingIndicatorOptions.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

public enum PagingIndicatorWidth {
  case flexible
  case fixed(CGFloat)
}

public enum PagingIndicatorOptions {
	case hidden
	case visible(
    width: PagingIndicatorWidth,
    height: CGFloat,
    spacing: UIEdgeInsets,
    insets: UIEdgeInsets,
    zIndex: Int
  )
	// TODO: Worm for indicator scrolling
//	case worm(
//    height: CGFloat,
//		dampingRatio: CGFloat,
//		velocity: CGFloat,
//    zIndex: Int
//	)
}
