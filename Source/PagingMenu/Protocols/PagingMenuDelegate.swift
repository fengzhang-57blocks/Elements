//
//  PagingMenuDelegate.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

public protocol PagingMenuDelegate: AnyObject {
  func pagingMenu(_ pagingMenu: PagingMenu, didSelect tab: Tab, at index: Int)
  func pagingMenu(
    _ pagingMenu: PagingMenu,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize
  func minimumInteritemSpacingForPagingMenu(_ pagingMenu: PagingMenu, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
}

public extension PagingMenuDelegate {
  func pagingMenu(_ pagingMenu: PagingMenu, didSelect tab: Tab, at index: Int) {
    // do nothing
  }
  
  func pagingMenu(
    _ pagingMenu: PagingMenu,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize {
      return .zero
    }
  
  func minimumInteritemSpacingForPagingMenu(_ pagingMenu: PagingMenu, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat {
    return .zero
  }
}
