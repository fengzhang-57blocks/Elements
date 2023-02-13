//
//  PagingMenuItemDirection.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/13.
//

import UIKit

public enum PagingMenuItemDirection {
  case none
  case forward(isSibling: Bool)
  case reverse(isSibling: Bool)
}

extension PagingMenuItemDirection {
  var navigationDirection: UIPageViewController.NavigationDirection {
    switch self {
    case .forward, .none:
      return .forward
    case .reverse:
      return .reverse
    }
  }
}
