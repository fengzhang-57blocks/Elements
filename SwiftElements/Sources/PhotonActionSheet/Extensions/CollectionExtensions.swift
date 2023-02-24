//
//  CollectionExtensions.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

public extension Collection {
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
