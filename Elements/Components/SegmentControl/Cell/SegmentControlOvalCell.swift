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
			button.setTitleColor(.white, for: .selected)
			button.setTitleColor(.blue, for: .normal)
		}

		button.addTarget(self, action: #selector(onTouchButton(_:)), for: .touchDown)
    
    button.translatesAutoresizingMaskIntoConstraints = false
		
    addSubview(button)

		NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
  
  override func configure(_ segment: Segment) {
    super.configure(segment)
    button.setTitle(segment.title, for: [])
  }
	
	@objc private func onTouchButton(_ sender: UIButton) {
		
	}
}


