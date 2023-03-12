//
//  ExampleListViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

struct Demo {
	let title: String
  let ViewController: UIViewController.Type
	
  init(title: String, ViewController: UIViewController.Type) {
		self.title = title
		self.ViewController = ViewController
	}
}

class ExampleListViewController: UITableViewController {
	
	lazy var demos = getDemos()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
    
		navigationItem.backBarButtonItem = UIBarButtonItem()
		
	}
	
	func getDemos() -> [Demo] {
		return [
      Demo(title: "PagingViewController", ViewController: PagingViewControllerExampleViewController.self),
      Demo(title: "PhotonActionSheet", ViewController: PhotonActionSheetExampleViewController.self),
		]
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return demos.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		cell.textLabel?.text = demos[indexPath.row].title
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
    let viewController = demos[indexPath.row].ViewController.init()
		navigationController?.pushViewController(viewController, animated: true)
	}
	
}

