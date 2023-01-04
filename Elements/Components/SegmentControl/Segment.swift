//
//  Segment.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

struct Segment {
	let title: String
	var selected: Bool
	var disabled: Bool
	
	init(
		title: String,
		selected: Bool = false,
		disabled: Bool = false
	) {
		self.title = title
		self.selected = selected
		self.disabled = disabled
	}
	
}
