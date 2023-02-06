//
//  TabControlDelegate.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

public protocol TabControlDelegate: AnyObject {
  func tabControl(_ tabControl: TabControl, didSelect tab: Tab, at index: Int)
  func tabControl(
    _ tabControl: TabControl,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize
  func minimumInteritemSpacingForTabControl(_ tabControl: TabControl, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
}

public extension TabControlDelegate {
  func tabControl(_ tabControl: TabControl, didSelect tab: Tab, at index: Int) {
    // do nothing
  }
  
  func tabControl(
    _ tabControl: TabControl,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize {
      return .zero
    }
  
  func minimumInteritemSpacingForTabControl(_ tabControl: TabControl, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat {
    return .zero
  }
}
