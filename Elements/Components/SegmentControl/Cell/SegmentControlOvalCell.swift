//
//  SegmentControlOvalCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class SegmentControlOvalCell: SegmentControlCell {
	private var button: UIButton!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		if #available(iOS 15, *) {
			var config = UIButton.Configuration.filled()
			config.cornerStyle = .capsule
			config.baseBackgroundColor = .white
			config.baseForegroundColor = .blue
			button = UIButton(configuration: config, primaryAction: nil)
		} else {
			button = UIButton()
			button.backgroundColor = .white
			button.setTitleColor(.blue, for: .normal)
			button.setTitleColor(.white, for: .selected)
			button.layer.masksToBounds = true
		}
		
		button.translatesAutoresizingMaskIntoConstraints = false

		button.addTarget(self, action: #selector(onTouchButton(_:)), for: .touchDown)
    
    addSubview(button)

		NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard #available(iOS 15.0, *) else {
			button.layer.cornerRadius = half(bounds.height)
		}
	}
  
	override func configure(_ segment: Segment, layout: SegmentControl.Layout) {
		super.configure(segment, layout: layout)
		button.setAttributedTitle(segment.title, for: [])
		if #available(iOS 15.0, *) {
			button.configuration?.contentInsets = NSDirectionalEdgeInsets(insets: layout.contentInsets)
		} else {
			button.contentEdgeInsets = layout.contentInsets
		}
	}
	
	@objc private func onTouchButton(_ sender: UIButton) {
		
	}
}


