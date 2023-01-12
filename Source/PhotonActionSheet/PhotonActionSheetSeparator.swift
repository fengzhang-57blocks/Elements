//
//  PhotonActionSheetSeparator.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/1/9.
//

import UIKit

public class PhotonActionSheetSeparator: UITableViewHeaderFooterView {
  let view = UIView()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    view.backgroundColor = UIColor.separator
    view.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(view)
    NSLayoutConstraint.activate([
      view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      view.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
