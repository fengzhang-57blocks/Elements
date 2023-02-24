//
//  PagingIndexItem.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/10.
//

import Foundation

public struct PagingIndexItem: PagingItem, Equatable, Comparable, Hashable {
  public let index: Int
  
  public let title: String
  
  public init(index: Int, title: String) {
    self.index = index
    self.title = title
  }
  
  public static func < (lhs: PagingIndexItem, rhs: PagingIndexItem) -> Bool {
    return lhs.index < rhs.index
  }
}

