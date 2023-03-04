//
//  PagingViewControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PagingViewControllerDelegate: AnyObject {
  func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem item: PagingItem)
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  )
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  )
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController,
    transitionSuccessful successful: Bool
  )
}

public extension PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem item: PagingItem) {}
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
    
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
    
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController,
    transitionSuccessful successful: Bool
  ) {
    
  }
}
