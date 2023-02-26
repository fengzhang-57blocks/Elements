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
		willBeginScrollFrom startViewController: UIViewController,
		to destinationViewController: UIViewController
	)
	
	func pageViewController(
		_ pageViewController: PageViewController,
		isScrollingFrom startViewController: UIViewController,
		to destinationViewController: UIViewController,
		with progress: CGFloat
	)
	
	func pageViewController(
		_ pageViewController: PageViewController,
		didEndScrollFrom startViewController: UIViewController,
		to destinationViewController: UIViewController,
    transitionSuccessful successful: Bool
	)
}
