//
//  PageControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PageControllerDelegate: NSObjectProtocol {
  func pageController(_ pageController: PageController, didDisplay page: PageController.Page)
	var tabControl: TabControl? { get }
}

public extension PageControllerDelegate {
  func pageController(_ pageController: PageController, didDisplay page: PageController.Page) {
    // 
  }
	
	var tabControl: TabControl? {
		return nil
	}
}
