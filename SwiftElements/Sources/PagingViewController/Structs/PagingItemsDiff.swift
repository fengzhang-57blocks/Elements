//
//  PagingItemsDiff.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/3/5.
//

import Foundation

struct PagingItemsDiff {
  private let previous: PagingItems
  private var previousCache: [Int: PagingItem] = [:]
  
  private let new: PagingItems
  private var newCache: [Int: PagingItem] = [:]
  
  private var lastDuplicatedItem: PagingItem?
  
  init(previous: PagingItems, new: PagingItems) {
    self.previous = previous
    self.new = new
    
    previous.items.forEach {
      previousCache[$0.identifier] = $0
    }
    
    new.items.forEach {
      newCache[$0.identifier] = $0
    }
    
    for prevItem in previous.items {
      for newItem in new.items {
        if prevItem.isEqual(to: newItem) {
          lastDuplicatedItem = prevItem
          break
        }
      }
    }
  }
  
  func diff(from visibleItems: PagingItems, compare: [Int: PagingItem]) -> [IndexPath] {
    return visibleItems.items.compactMap {
      if compare[$0.identifier] == nil {
        return visibleItems.indexPath(for: $0)
      }
      
      return nil
    }
  }
  
  func removed() -> [IndexPath] {
    let removedDiff = diff(from: previous, compare: newCache)
    var results: [IndexPath] = []
    
    if let lastDuplicatedItem = lastDuplicatedItem {
      if let lastDuplicatedIndexPath = previous.indexPath(for: lastDuplicatedItem) {
        for indexPath in removedDiff {
          if indexPath.item < lastDuplicatedIndexPath.item {
            results.append(indexPath)
          }
        }
      }
    }
    
    return results
  }
  
  func added() -> [IndexPath] {
    let addedDiff = diff(from: new, compare: previousCache)
    let removedCount = removed().count
    var results: [IndexPath] = []
    
    if let lastDuplicatedItem = lastDuplicatedItem {
      if let lastDuplicatedIndexPath = previous.indexPath(for: lastDuplicatedItem) {
        for indexPath in addedDiff {
          if indexPath.item + removedCount <= lastDuplicatedIndexPath.item {
            results.append(indexPath)
          }
        }
      }
    }
    
    return results
  }
}
