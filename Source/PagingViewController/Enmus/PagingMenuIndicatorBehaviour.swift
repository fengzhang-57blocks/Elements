//
//  PagingMenuIndicatorBehaviour.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/6.
//

import UIKit

public enum PagingMenuIndicatorBehaviour {
	case hidden
	case visible(
    height: CGFloat,
    spacing: UIEdgeInsets,
    insets: UIEdgeInsets,
    zIndex: Int
  )
	// TODO: Worm for indicator scrolling
//	case worm(
//		dampingRatio: CGFloat,
//		velocity: CGFloat
//	)
}
