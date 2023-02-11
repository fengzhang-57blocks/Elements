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
	}
}

extension PagingControllerDemoViewController: PagingViewControllerDataSource {
  func numberOfViewControllers() -> Int {
    return 15
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, pagingMenuItemAt index: Int) -> PagingMenuItem {
    return PagingMenuIndexItem(index: index, title: "\(index)")
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let viewController = PageDemoViewController()
    viewController.label.text = "View \(index)"
    
    return viewController
  }
  
}
