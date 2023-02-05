//
//  PageDemoViewController.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/5.
//

import UIKit

class PageDemoViewController: BaseViewController {
  lazy var label: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
}
