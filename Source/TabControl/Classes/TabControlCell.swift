//
//  TabControlCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class TabControlCell: UICollectionViewCell {
	func configure(_ tab: Tab, layout: TabControlConfigurations) {
		self.layout = layout
		self.tab = tab
		// in subclass
	}
	
	var layout: TabControlConfigurations?
	var tab: Tab?
	
}
