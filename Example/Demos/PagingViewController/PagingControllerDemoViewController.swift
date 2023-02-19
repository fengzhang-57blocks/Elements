//
//  PagingControllerDemoViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

class PagingControllerDemoViewController: BaseViewController {
  
  lazy var pagingViewController: PagingViewController = PagingViewController()
  
	override func viewDidLoad() {
		super.viewDidLoad()
    
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    pagingViewController.dataSource = self
    pagingViewController.delegate = self
	}
}

extension PagingControllerDemoViewController: PagingViewControllerDataSource {
	func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
		return 15
	}
  
  func pagingViewController(_ pagingViewController: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: "\(index)")
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let viewController = PageDemoViewController()
    viewController.label.text = "\(index)"
		viewController.title = "\(index)"
    return viewController
  }
  
}

extension PagingControllerDemoViewController: PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem item: PagingItem) {
//    print("didSelectItem")
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
//    print("isScrollingFrom:to:", fromViewController.title!, toViewController.title!)
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
//    print("willBeginScrollFrom:to:", fromViewController.title!, toViewController.title!)
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController,
    transitionSuccessful successful: Bool
  ) {
//    print("didEndScrollFrom:to:transitionSuccessful:", fromViewController.title!, toViewController.title!, successful)
  }
}
