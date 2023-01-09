//
//  SegmentControlCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControlCell: UICollectionViewCell {
	func configure(_ segment: Segment, layout: SegmentControl.Layout) {
		self.layout = layout
		self.segment = segment
		// in subclass
	}
	
	var segment: Segment?
	var layout: SegmentControl.Layout?
	
}
