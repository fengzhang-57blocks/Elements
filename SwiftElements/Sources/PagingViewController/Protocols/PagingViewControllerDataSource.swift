//
//  PagingViewControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PagingViewControllerDataSource: AnyObject {
	func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int
	func pagingViewController(_ pagingViewController: PagingViewController, pagingItemAt index: Int) -> PagingItem
	func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController
}
