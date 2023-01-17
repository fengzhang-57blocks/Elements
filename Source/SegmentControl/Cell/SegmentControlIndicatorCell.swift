//
//  SegmentControlIndicatorCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class SegmentControlIndicatorCell: SegmentControlCell {
	private(set) public lazy var label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
  private(set) public lazy var indicator: UIView = {
		let indicator = UIView()
		indicator.isHidden = true
		indicator.backgroundColor = .blue
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
    contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
		
    contentView.addSubview(indicator)
		
		NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: label.centerXAnchor),
			indicator.heightAnchor.constraint(equalToConstant: 3),
      indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
		])
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func configure(_ segment: Segment, layout: SegmentControl.Layout) {
		super.configure(segment, layout: layout)
    label.attributedText = segment.title
    indicator.isHidden = !segment.isSelected
    indicator.backgroundColor = layout.indicatorColor
		
    if segment.isSelected {
      label.textColor = layout.selectedTitleColor
      contentView.backgroundColor = layout.backgroundColor
    } else {
      label.textColor = layout.titleColor
      contentView.backgroundColor = layout.selectedBackgroundColor
    }
    
    switch layout.indicatorWidth {
    case let .fixed(width):
      NSLayoutConstraint.activate([indicator.widthAnchor.constraint(equalToConstant: width)])
    case .automation:
      NSLayoutConstraint.activate([
        indicator.leadingAnchor.constraint(equalTo: label.leadingAnchor),
        indicator.trailingAnchor.constraint(equalTo: label.trailingAnchor)
      ])
    }
	}
}
