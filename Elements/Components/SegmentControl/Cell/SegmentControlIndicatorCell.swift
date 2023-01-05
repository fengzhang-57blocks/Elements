//
//  SegmentControlIndicatorCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControlIndicatorCell: SegmentControlCell {
	lazy var label = UILabel()
	lazy var indicator = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(label)
		
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			label.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		addSubview(indicator)
		
		indicator.backgroundColor = .blue
		indicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			indicator.heightAnchor.constraint(equalToConstant: 3),
			indicator.widthAnchor.constraint(equalToConstant: 20),
			indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			indicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func configure(_ segment: Segment, layout: SegmentControl.Layout) {
		super.configure(segment, layout: layout)
		label.attributedText = segment.title
	}
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 200, height: 50)
  }
}

