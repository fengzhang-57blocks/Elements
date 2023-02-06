//
//  TabSize.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/6.
//

import Foundation

public enum TabSize {
  case fixed(width: CGFloat, height: CGFloat)
}

public extension TabSize {
  public var width: CGFloat {
    switch self {
    case let .fixed(width, _):
        return width
    }
  }
  
  public var height: CGFloat {
    switch self {
    case let .fixed(_, height):
      return height
    }
  }
}
