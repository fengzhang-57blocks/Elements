//
//  Segment.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import Foundation

typealias SegmentActionHandler = (Segment) -> Void

struct Segment {
  
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
	
}
