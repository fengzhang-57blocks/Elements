//
//  Tab.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import Foundation

public typealias TabActionHandler = (Tab) -> Void

public struct Tab {
  
	public let title: NSAttributedString
  
	public var isSelected: Bool
	public var isDisabled: Bool
  
	public let handler: TabActionHandler?
	
	public init(
		title: NSAttributedString,
    isSelected: Bool = false,
    isDisabled: Bool = false,
    handler: TabActionHandler? = nil
	) {
		self.title = title
		self.isSelected = isSelected
		self.isDisabled = isDisabled
    self.handler = handler
	}
	
	public func isEqual(to s: Tab) -> Bool {
		return value().elementsEqual(s.value())
	}
	
	public func value() -> String {
		return title.string
	}
	
}

extension Tab: Equatable {
	public static func == (lhs: Tab, rhs: Tab) -> Bool {
		return lhs.title.string.elementsEqual(rhs.title.string)
	}
}
