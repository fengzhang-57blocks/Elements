//
//  PagingMenuIndexItem.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/10.
//

import Foundation

public struct PagingMenuIndexItem: PagingMenuItem, Equatable, Comparable, Hashable {
  public let index: Int
  
  public let title: String
  
  public init(index: Int, title: String) {
    self.index = index
    self.title = title
  }
  
  public static func < (lhs: PagingMenuIndexItem, rhs: PagingMenuIndexItem) -> Bool {
    return lhs.index < rhs.index
  }
}

