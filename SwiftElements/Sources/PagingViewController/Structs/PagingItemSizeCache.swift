//
//  PagingItemSizeCache.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/9.
//

import Foundation

class PagingItemSizeCache {
  var options: PagingOptions
  var implementedSizeDelegate: Bool = false
  var sizeForPagingMenuItem: ((PagingItem, Bool) -> CGFloat?)?
  
  private var cachedSize: [Int: CGFloat] = [:]
  private var selectedCachedSize: [Int: CGFloat] = [:]
  
  init(options: PagingOptions) {
    self.options = options
  }
  
  func clearCahces() {
    cachedSize = [:]
    selectedCachedSize = [:]
  }
  
  func widthForItem(_ item: PagingItem) -> CGFloat {
    if let size = cachedSize[item.identifier] {
      return size
    }
    
    let size = sizeForPagingMenuItem?(item, false)
    cachedSize[item.identifier] = size
    return size ?? options.estimatedItemWidth
  }
  
  func widthForSelectedItem(_ item: PagingItem) -> CGFloat {
    if let size = selectedCachedSize[item.identifier] {
      return size
    }
    
    let size = sizeForPagingMenuItem?(item, false)
    cachedSize[item.identifier] = size
    return size ?? options.estimatedItemWidth
  }
}
