//
//  PageViewControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

public protocol PageViewControllerDelegate: AnyObject {
	func pageViewController(
		_ pageViewController: PageViewController,
		willBeginScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	)
	func pageViewController(
		_ pageViewController: PageViewController,
		isScrolling fromViewController: UIViewController,
		to destinationViewController: UIViewController,
		with progress: CGFloat
	)
	func pageViewController(
		_ pageViewController: PageViewController,
		didEndScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	)
}
