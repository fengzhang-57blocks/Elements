//
//  PagingViewControllerFiniteDataSource.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/11.
//

import UIKit

class PagingViewControllerFiniteDataSource: PagingViewControllerDynamicDataSource {
  private(set) var items: [PagingItem]
  var viewControllerForIndex: ((Int) -> UIViewController?)?
  
  init(items: [PagingItem]) {
    self.items = items
  }
  
  func updateItems(_ items: [PagingItem]) {
    self.items = items
  }
  
  func itemForIndex(_ index: Int) -> PagingItem {
    return items[index]
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    viewControllerFor item: PagingItem
  ) -> UIViewController {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item) }) else {
      fatalError("pagingViewController(_:viewControllerFor:) item not exists.")
    }
    
    guard let viewController = viewControllerForIndex?(index) else {
      fatalError("pagingViewController(_:viewControllerFor:) view controller not exists.")
    }
    
    return viewController
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, itemBefore item: PagingItem) -> PagingItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item)}),
					index > 0 else {
      return nil
    }
    
    return items[index - 1]
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, itemAfter item: PagingItem) -> PagingItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item) }),
					index < items.count - 1 else {
      return nil
    }
    
    return items[index + 1]
  }
}
