//
//  PagingMenuDataSource.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

public protocol PagingMenuDataSource: AnyObject {
  func numberOfItems(in pagingMenu: PagingMenu) -> Int
  func pagingMenu(_ pagingMenu: PagingMenu, cellForItemAt index: Int) -> UICollectionViewCell
  func pagingMenu(_ pagingMenu: PagingMenu, tabAt index: Int) -> Tab
}
