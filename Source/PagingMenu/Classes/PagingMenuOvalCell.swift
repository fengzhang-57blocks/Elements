//
//  PagingMenuOvalCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class PagingMenuOvalCell: PagingMenuCell {
	private var button: UIButton!
	
	public override init(frame: CGRect) {
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
    button.isUserInteractionEnabled = false

    contentView.addSubview(button)

		NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
		])
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	public override func layoutSubviews() {
		super.layoutSubviews()
    if #available(iOS 15.0, *) {} else {
      button.layer.cornerRadius = half(bounds.height)
    }
	}
  
	override func configure(_ tab: Tab, layout: PagingMenuOptions) {
		super.configure(tab, layout: layout)
    
		button.setAttributedTitle(tab.title, for: .normal)
    
		if #available(iOS 15.0, *) {
			button.configuration?.contentInsets = NSDirectionalEdgeInsets(insets: layout.contentInsets)
      button.configuration?.background.strokeWidth = layout.borderWidth
      button.configuration?.background.strokeColor = layout.borderColor
      
      if tab.isSelected {
        button.configuration?.baseForegroundColor = layout.selectedTitleColor
        button.configuration?.baseBackgroundColor = layout.selectedBackgroundColor
      } else {
        button.configuration?.baseForegroundColor = layout.titleColor
        button.configuration?.baseBackgroundColor = layout.backgroundColor
      }
		} else {
			button.contentEdgeInsets = layout.contentInsets
      button.layer.borderColor = layout.borderColor.cgColor
      button.layer.borderWidth = layout.borderWidth
      
      if tab.isSelected {
        button.setTitleColor(layout.selectedTitleColor, for: .normal)
        button.backgroundColor = layout.selectedBackgroundColor
      } else {
        button.setTitleColor(layout.titleColor, for: .normal)
        button.backgroundColor = layout.backgroundColor
      }
		}
	}
  
}
