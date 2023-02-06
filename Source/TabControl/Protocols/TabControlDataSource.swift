//
//  TabControlDataSource.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

public protocol TabControlDataSource: AnyObject {
  func numberOfItems(in tabControl: TabControl) -> Int
  func tabControl(_ tabControl: TabControl, cellForItemAt index: Int) -> UICollectionViewCell
  func tabControl(_ tabControl: TabControl, tabAt index: Int) -> Tab
}
