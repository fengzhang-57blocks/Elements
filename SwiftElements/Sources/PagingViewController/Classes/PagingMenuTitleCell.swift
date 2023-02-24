//
//  PagingMenuTitleCell.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/10.
//

import UIKit

open class PagingMenuTitleCell: PagingMenuCell {
  public let titleLabel: UILabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
		configure()
  }
  
  open func configure() {
    titleLabel.textAlignment = .center
    contentView.addSubview(titleLabel)
    
    let views = ["titleLabel": titleLabel]
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[titleLabel]|",
        metrics: nil,
        views: views
      )
    )
    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[titleLabel]|",
        metrics: nil,
        views: views
      )
    )
  }
  
	open override func setItem(_ item: PagingItem, selected: Bool, options: PagingOptions) {
		if let indexItem = item as? PagingIndexItem {
			titleLabel.text = "\(indexItem.title)"
		}
	}
	
	// TODO: color transition
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
	}
}
