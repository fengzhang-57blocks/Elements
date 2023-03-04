//
//  PagingContentViewController.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/5.
//

import UIKit

class PagingContentViewController: BaseViewController {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    print("viewWillAppear ", self.title ?? "")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    print("viewDidAppear ", self.title ?? "")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    print("viewWillDisappear ", self.title ?? "")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
//    print("viewDidDisappear ", self.title ?? "")
  }
}
