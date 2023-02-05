//
//  PageControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PageControllerDataSource: AnyObject {
  func numberOfPages(for pageController: PageController) -> Int
  func pageController(_ pageController: PageController, pageAt index: Int) -> PageController.Page
}
