//
//  TabControlCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class TabControlCell: UICollectionViewCell {
	func configure(_ tab: Tab, layout: TabControl.Layout) {
		self.layout = layout
		self.tab = tab
		// in subclass
	}
	
	var tab: Tab?
	var layout: TabControl.Layout?
	
}
