//
//  PagingMenuItem.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/7.
//

import Foundation

public protocol PagingMenuItem {
	var identifier: Int { get }
	func isEqual(to item: PagingMenuItem) -> Bool
}

public extension PagingMenuItem where Self: Equatable {
	func isEqual(to item: PagingMenuItem) -> Bool {
		guard let item = item as? Self else {
			return false
		}
		return self == item
	}
}

public extension PagingMenuItem where Self: Hashable {
	var identifier: Int {
		return hashValue
	}
}
