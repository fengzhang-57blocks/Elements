//
//  PagingItems.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import Foundation

public struct PagingItems {
	public let items: [PagingItem]
  
	private var cachedItems: [Int: PagingItem] = [:]
	
  init(items: [PagingItem]) {
    self.items = items
    items.forEach {
      cachedItems[$0.identifier] = $0
    }
  }
  
  public func indexPath(for item: PagingItem) -> IndexPath? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: item) }) else {
      return nil
    }
    
    return IndexPath(item: index, section: 0)
  }
  
  public func item(for indexPath: IndexPath) -> PagingItem {
    return items[indexPath.item]
  }
  
  public func contains(_ item: PagingItem) -> Bool {
    return cachedItems[item.identifier] != nil
  }
	
	public func direction(from: PagingItem, to: PagingItem) -> PagingTransitionDirection {
		if from.isBefore(to: to) {
			return .forward
		} else if to.isBefore(to: from) {
			return .reverse
		}
		
		return .none
	}
}
