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
    viewControllerFor item: PagingMenuItem
  ) -> UIViewController
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    itemBefore item: PagingMenuItem
  ) -> PagingMenuItem?
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    itemAfter item: PagingMenuItem
  ) -> PagingMenuItem?
}
