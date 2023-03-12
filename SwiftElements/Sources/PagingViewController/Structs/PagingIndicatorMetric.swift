//
//  PagingIndicatorMetric.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/9.
//

import UIKit

public struct PagingIndicatorMetric {
  let options: PagingIndicatorOptions
  let frame: CGRect
}

extension PagingIndicatorMetric {
  var x: CGFloat {
    switch options {
    case let .visible(width, _, spacing, _, _):
      switch width {
      case let .fixed(size):
        return frame.midX - size / 2
      case .flexible:
        return frame.origin.x + spacing.left
      }
    case .hidden:
      return .zero
    }
  }
  
  var width: CGFloat {
    switch options {
    case let .visible(width, _, spacing, _, _):
      switch width {
      case let .fixed(size):
        return CGFloat.minimum(size, frame.size.width)
      case .flexible:
        return frame.width - spacing.horizontal
      }
    case .hidden:
      return .zero
    }
  }
}
