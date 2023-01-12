//
//  SegmentControlIndicatorCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControlIndicatorCell: SegmentControlCell {
	lazy var label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var indicator: UIView = {
		let indicator = UIView()
		indicator.isHidden = true
		indicator.backgroundColor = .blue
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	private var indicatorLeadingConstaint: NSLayoutConstraint!
	private var indicatorTrailingConstaint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
    contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
		
    contentView.addSubview(indicator)
		
		indicatorLeadingConstaint = indicator.leadingAnchor.constraint(equalTo: label.leadingAnchor)
		indicatorTrailingConstaint = indicator.trailingAnchor.constraint(equalTo: label.trailingAnchor)
		
		NSLayoutConstraint.activate([
			indicatorLeadingConstaint,
			indicatorTrailingConstaint,
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
		
		if layout.titleInsets != .zero {
			NSLayoutConstraint.deactivate([indicatorLeadingConstaint, indicatorTrailingConstaint])
			indicatorLeadingConstaint = indicator.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: layout.titleInsets.left)
			indicatorTrailingConstaint = indicator.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -layout.titleInsets.right)
			NSLayoutConstraint.activate([
				indicatorLeadingConstaint,
				indicatorTrailingConstaint,
			])
		}
	}
  
}

