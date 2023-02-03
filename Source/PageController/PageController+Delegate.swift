//
//  PageControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PageControllerDelegate: AnyObject {
	func pageController(_ pageController: PageController, didDisplayPageAt index: Int)
	func segmentControlForPageController(_ pageController: PageController) -> SegmentControl
	func edgeInsetsForSegmentControl(_ pageController: PageController) -> UIEdgeInsets
}

public extension PageControllerDelegate {
	
}
