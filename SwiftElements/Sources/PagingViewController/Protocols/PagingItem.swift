//
//  PagingItem.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/7.
//

import Foundation

public protocol PagingItem {
	var identifier: Int { get }
	func isEqual(to item: PagingItem) -> Bool
  func isBefore(to item: PagingItem) -> Bool
}

public extension PagingItem where Self: Hashable {
  var identifier: Int {
    return hashValue
  }
}

public extension PagingItem where Self: Equatable {
	func isEqual(to item: PagingItem) -> Bool {
		guard let item = item as? Self else {
			return false
		}
		return self == item
	}
}

public extension PagingItem where Self: Comparable {
  func isBefore(to item: PagingItem) -> Bool {
    guard let item = item as? Self else {
      return false
    }
    return self < item
  }
}
