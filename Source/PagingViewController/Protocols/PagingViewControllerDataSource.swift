//
//  PagingViewControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PagingViewControllerDataSource: AnyObject {
	func numberOfViewControllers() -> Int
	func pagingViewController(_ pagingViewController: PagingViewController, pagingMenuItemAt index: Int) -> PagingMenuItem
	func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController
}
