//
//  TabControlCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class TabControlCell: UICollectionViewCell {
	func configure(_ tab: Tab, layout: TabControlOptions) {
		self.layout = layout
		self.tab = tab
		// in subclass
	}
	
	var layout: TabControlOptions?
	var tab: Tab?
}
