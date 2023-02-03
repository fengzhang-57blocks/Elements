//
//  PageControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PageControllerDataSource: AnyObject {
	func pageController(_ pageController: PageController, viewControllerFor index: Int) -> UIViewController
}

extension PageControllerDataSource {
	
}
