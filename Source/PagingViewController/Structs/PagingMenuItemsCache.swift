//
//  PagingMenuItemsCache.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import Foundation

public struct PagingMenuItemsCache {
	let items: [PagingMenuItem]
	
	private var cachedItems: [Int: PagingMenuItem] = [:]
	
	init(items: [PagingMenuItem]) {
		self.items = items
		items.forEach {
			cachedItems[$0.identifier] = $0
		}
	}
}

public extension PagingMenuItemsCache {
	func indexPath(for item: PagingMenuItem) -> IndexPath? {
		guard let index = items.firstIndex(where: { $0.isEqual(to: item) }) else {
			return nil
		}
		
		return IndexPath(item: index, section: 0)
	}
}
