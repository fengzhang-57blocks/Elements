//
//  PagingControllerDataSource.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PagingControllerDataSource: AnyObject {
  func numberOfPages(for pagingController: PagingController) -> Int
  func pagingController(_ pagingController: PagingController, pageAt index: Int) -> PagingController.Page
}
