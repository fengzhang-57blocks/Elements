//
//  PagingControllerDelegate.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public protocol PagingControllerDelegate: NSObjectProtocol {
  func pagingController(_ pagingController: PagingController, didDisplay page: PagingController.Page)
	var pagingMenu: PagingMenu? { get }
}

public extension PagingControllerDelegate {
  func pagingController(_ pagingController: PagingController, didDisplay page: PagingController.Page) {
    // 
  }
	
	var pagingMenu: PagingMenu? {
		return nil
	}
}