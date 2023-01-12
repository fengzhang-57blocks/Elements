//
//  Segment.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import Foundation

public typealias SegmentActionHandler = (Segment) -> Void

public struct Segment {
  
  let title: NSAttributedString
  
	var isSelected: Bool
	var isDisabled: Bool
  
  let handler: SegmentActionHandler?
	
	init(
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
	
	func isEqual(to s: Segment) -> Bool {
		return value().elementsEqual(s.value())
	}
	
	func value() -> String {
		return title.string
	}
	
}

extension Segment: Equatable {
	public static func == (lhs: Segment, rhs: Segment) -> Bool {
		return lhs.title.string.elementsEqual(rhs.title.string)
	}
}
