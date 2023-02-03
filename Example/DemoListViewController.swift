//
//  DemoListViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

struct Demo {
	let title: String
	let viewController: UIViewController
	
	init(title: String, viewController: UIViewController) {
		self.title = title
		self.viewController = viewController
	}
}

class DemoListViewController: UITableViewController {
	
	lazy var demos = getDemos()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		navigationItem.backBarButtonItem = UIBarButtonItem()
		
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func getDemos() -> [Demo] {
		return [
      Demo(title: "PhotonActionSheet", viewController: PhotonActionSheetDemoViewController()),
			Demo(title: "SegmentControl", viewController: SegmentControlDemoViewController()),
			Demo(title: "PageController", viewController: PageControllerDemoViewController()),
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
		
		navigationController?.pushViewController(demos[indexPath.row].viewController, animated: true)
	}
	
}

