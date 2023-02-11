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
    createLayout()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    createLayout()
  }
  
  open func createLayout() {
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
  
  open override func setPagingMenuItem(_ item: PagingMenuItem, selected: Bool, options: PagingMenuOptions) {
    if let indexItem = item as? PagingMenuIndexItem {
      titleLabel.text = "\(indexItem.title)"
    }
  }
}
