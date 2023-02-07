//
//  PagingMenuCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class PagingMenuCell: UICollectionViewCell {
	func configure(_ tab: Tab, layout: PagingMenuOptions) {
		self.layout = layout
		self.tab = tab
		// in subclass
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .orange
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	var layout: PagingMenuOptions?
	var tab: Tab?
}