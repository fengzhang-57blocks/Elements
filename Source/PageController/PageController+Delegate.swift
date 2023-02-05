//
//  PageControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PageControllerDelegate: AnyObject {
	func segmentControl(for pageController: PageController) -> SegmentControl?
  func edgeInsetsForSegmentControl(_ pageController: PageController) -> UIEdgeInsets
  func pageController(_ pageController: PageController, didDisplay page: PageController.Page)
}

public extension PageControllerDelegate {
  func segmentControl(for pageController: PageController) -> SegmentControl? {
    return nil
  }
  
  func edgeInsetsForSegmentControl(_ pageController: PageController) -> UIEdgeInsets {
    return .zero
  }
  
  func pageController(_ pageController: PageController, didDisplay page: PageController.Page) {
    // 
  }
}
