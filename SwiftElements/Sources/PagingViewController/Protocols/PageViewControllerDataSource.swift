//
//  PageViewControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PageViewControllerDataSource: AnyObject {
  func pageViewController(
    _ pageViewController: PageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController?
  
  func pageViewController(
    _ pageViewController: PageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController?
}
