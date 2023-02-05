//
//  PageController+Page.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/5.
//

import UIKit

public extension PageController {
  struct Page {
    public let index: Int
    public let title: String
    public let viewController: UIViewController
    public init(index: Int, title: String, viewController: UIViewController) {
      self.index = index
      self.title = title
      self.viewController = viewController
    }
  }
}

extension PageController.Page: Equatable {
  public static func == (lhs: PageController.Page, rhs: PageController.Page) -> Bool {
    return lhs.viewController.hash == rhs.viewController.hash
  }
}
