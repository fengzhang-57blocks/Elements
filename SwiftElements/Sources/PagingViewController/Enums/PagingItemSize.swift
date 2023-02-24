//
//  PagingItemSize.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/6.
//

import Foundation

public enum PagingItemSize {
  case fixed(width: CGFloat, height: CGFloat)
  case selfSizing(estimatedWidth: CGFloat, height: CGFloat)
}

public extension PagingItemSize {
	var width: CGFloat {
    switch self {
    case let .fixed(width, _):
      return width
    case let .selfSizing(estimatedWidth, _):
      return estimatedWidth
    }
  }
  
	var height: CGFloat {
    switch self {
    case let .fixed(_, height):
      return height
    case let .selfSizing(_, height):
      return height
    }
  }
}
