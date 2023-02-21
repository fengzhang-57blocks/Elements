//
//  UICollectionViewExtensions.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/21.
//

import UIKit

public extension UICollectionView {
  enum Edge {
    case top
    case right
    case bottom
    case left
  }
  
  func closeTo(edge: Edge, offset: CGFloat) -> Bool {
    switch edge {
    case .top:
      return contentInset.top + contentOffset.y <= offset
    case .right:
      return contentOffset.x + bounds.width + offset >= contentSize.width
    case .bottom:
      return contentOffset.y + bounds.height + offset >= contentSize.height
    case .left:
      return contentOffset.x + contentInset.left <= offset
    }
  }
}
