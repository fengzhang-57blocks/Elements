//
//  PagingViewControllerStaticDataSource.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/11.
//

import UIKit

class PagingViewControllerStaticDataSource: PagingViewControllerDynamicDataSource {
  private(set) var items: [PagingMenuItem]
  private(set) var viewControllers: [UIViewController]
  
  init(viewControllers: [UIViewController]) {
    items = viewControllers.enumerated().map({
      PagingMenuIndexItem(index: $0, title: $1.title ?? "")
    })
    self.viewControllers = viewControllers
  }
  
  func itemForIndex(_ index: Int) -> PagingMenuItem {
    return items[index]
  }
  
  func reloadItems() {
    items = viewControllers.enumerated().map({
      PagingMenuIndexItem(index: $0, title: $1.title ?? "")
    })
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    viewControllerFor item: PagingMenuItem
  ) -> UIViewController {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item) }) else {
      fatalError("pagingViewController(_:viewControllerFor:) item not exists.")
    }
    
    return viewControllers[index]
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, itemBefore item: PagingMenuItem) -> PagingMenuItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item)}), index > 0 else {
      return nil
    }
    
    return items[index - 1]
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, itemAfter item: PagingMenuItem) -> PagingMenuItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item) }), index < items.count - 1 else {
      return nil
    }
    
    return items[index + 1]
  }
}
