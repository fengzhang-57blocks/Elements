//
//  PagingViewControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PagingViewControllerDelegate: AnyObject {
  func pagingViewController(_: PagingViewController, didSelectItem item: PagingMenuItem)
  func pagingViewController(
    _: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  )
  func pagingViewController(
    _: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  )
  func pagingViewController(
    _: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  )
}

extension PagingViewControllerDelegate {
  func pagingViewController(_: PagingViewController, didSelectItem item: PagingMenuItem) {}
  
  func pagingViewController(
    _: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
    
  }
  
  func pagingViewController(
    _: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
    
  }
  
  func pagingViewController(
    _: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
    
  }
}
