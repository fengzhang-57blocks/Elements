//
//  PagingMenuCell.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class PagingMenuCell: UICollectionViewCell {
  lazy var label: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .center
    return label
  }()
  
	public override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .orange
	}
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = bounds
  }
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	var layout: PagingMenuOptions?
}
