//
//  PageViewControllersCache.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/16.
//

import UIKit

public class PageViewControllersCache {
  enum Index {
    case before
    case selected
    case after
  }
  
  private var indexes: [Index: UIViewController?] = [:]
  
  init(indexes: [Index : UIViewController?]) {
    self.indexes = indexes
  }
  
  func update(_ viewController: UIViewController?, for index: Index) {
    indexes[index] = viewController
  }
  
  func viewController(for index: Index) -> UIViewController? {
    return indexes[index]
  }
  
  func visibleViewControllers() -> [UIViewController] {
    return indexes.values.filter {
      $0 != nil
    }.map {
      $0!
    }
  }
  
//  func pageState() -> PageState {
//
//  }
}
