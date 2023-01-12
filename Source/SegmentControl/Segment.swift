//
//  Segment.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import Foundation

public typealias SegmentActionHandler = (Segment) -> Void

public struct Segment {
  
	public let title: NSAttributedString
  
	public var isSelected: Bool
	public var isDisabled: Bool
  
	public let handler: SegmentActionHandler?
	
	public init(
		title: NSAttributedString,
    isSelected: Bool = false,
    isDisabled: Bool = false,
    handler: SegmentActionHandler? = nil
	) {
		self.title = title
		self.isSelected = isSelected
		self.isDisabled = isDisabled
    self.handler = handler
	}
	
	public func isEqual(to s: Segment) -> Bool {
		return value().elementsEqual(s.value())
	}
	
	public func value() -> String {
		return title.string
	}
	
}

extension Segment: Equatable {
	public static func == (lhs: Segment, rhs: Segment) -> Bool {
		return lhs.title.string.elementsEqual(rhs.title.string)
	}
}
