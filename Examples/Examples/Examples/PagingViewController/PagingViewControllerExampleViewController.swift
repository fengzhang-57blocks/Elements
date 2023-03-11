//
//  PagingViewControllerExampleViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

class PagingViewControllerExampleViewController: UITableViewController {
  private let examples = [
    "Self Sizing",
    "Navigation Bar Title View",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 50
  }
}

extension PagingViewControllerExampleViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return examples.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = examples[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch examples[indexPath.row] {
    case "Self Sizing":
      navigationController?.pushViewController(PagingViewControllerSelfSizingExample(), animated: true)
    case "Navigation Bar Title View":
      navigationController?.pushViewController(PagingViewControllerTitleViewExample(), animated: true)
    default:
      break
    }
  }
}
