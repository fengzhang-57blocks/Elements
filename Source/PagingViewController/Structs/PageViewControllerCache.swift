//
//  PageViewControllerCache.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/12.
//

import UIKit

class PageViewControllerCache {
  var viewControllers: [UIViewController]
  
  init(viewControllers: [UIViewController]) {
    self.viewControllers = viewControllers
  }
  
  func index(for viewController: UIViewController) -> Int? {
    guard !viewControllers.isEmpty else {
      return nil
    }
    
    return viewControllers.firstIndex(of: viewController)
  }
  
//  func add(viewController: UIViewController) {
//    
//  }
//  
//  func remove(viewController: UIViewController) {
//    guard !viewControllers.isEmpty else {
//      return
//    }
//    
//    if viewControllers.contains(viewController),
//       let index = viewControllers.firstIndex(of: viewController) {
//      viewControllers.remove(at: index)
//    }
//  }
}
