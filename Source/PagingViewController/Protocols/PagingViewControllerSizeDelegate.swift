//
//  PagingViewControllerSizeDelegate.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/11.
//

import UIKit

public protocol PagingViewControllerSizeDelegate: AnyObject {
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    widthForItem item: PagingItem,
    selected isSelected: Bool
  ) -> CGFloat
}
