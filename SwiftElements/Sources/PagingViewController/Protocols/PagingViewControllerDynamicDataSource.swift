//
//  PagingViewControllerDynamicDataSource.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/11.
//

import UIKit

public protocol PagingViewControllerDynamicDataSource: AnyObject {
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    viewControllerFor item: PagingItem
  ) -> UIViewController
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    itemBefore item: PagingItem
  ) -> PagingItem?
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    itemAfter item: PagingItem
  ) -> PagingItem?
}
