//
//  Segment.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import Foundation

struct Segment {
	let title: NSAttributedString
	var selected: Bool
	var disabled: Bool
	
	init(
		title: NSAttributedString,
		selected: Bool = false,
		disabled: Bool = false
	) {
		self.title = title
		self.selected = selected
		self.disabled = disabled
	}
	
}
