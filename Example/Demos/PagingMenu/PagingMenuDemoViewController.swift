//
//  PagingMenuDemoViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/6.
//

import UIKit

class PagingMenuDemoViewController: BaseViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
		
		let s1Tabs = makeTabs(["C", "Objective-C", "Swift", "Go"])
		let s1 = makePagingMenu(s1Tabs, style: .indicator, alignment: .centered)
		s1.bounds.size = CGSize(width: view.bounds.width, height: 50)
		navigationItem.titleView = s1
		s1.delegate = self
		s1.reloadData()
		

		let s2Tabs = makeTabs(["C", "Objective-C", "Swift", "Go"])
		let s2 = makePagingMenu(s2Tabs, style: .indicator, alignment: .equalization)
		s2.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s2.delegate = self
		view.addSubview(s2)
		s2.translatesAutoresizingMaskIntoConstraints = false
		s2.reloadData()

		NSLayoutConstraint.activate([
			s2.heightAnchor.constraint(equalToConstant: 50),
			s2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			s2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			s2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
		])

		let s3Tabs = makeTabs(["C", "Objective-C", "Swift", "Go", "Python", "Javascript", "HTML", "CSS", "ES6"])
		let s3 = makePagingMenu(s3Tabs, style: .oval, alignment: .tiled)
		s3.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s3.delegate = self
		view.addSubview(s3)
		s3.translatesAutoresizingMaskIntoConstraints = false
		s3.reloadData()

		NSLayoutConstraint.activate([
			s3.heightAnchor.constraint(equalToConstant: 50),
			s3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			s3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			s3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
		])
	}
	
	func makeTabs(_ titles: [String]) -> [Tab] {
		return titles.enumerated().map { index, title in
			Tab(
				title: NSAttributedString(
					string: title,
					attributes: [
						.font: UIFont.systemFont(ofSize: 15, weight: .medium),
					]
				),
				isSelected: index == 0)
		}
	}

	func makePagingMenu(
		_ tabs: [Tab],
		style: PagingMenuStyle,
		alignment: PagingMenuAlignment
	) -> PagingMenu {
			let s = PagingMenu(tabs: tabs)

			var layout = PagingMenuOptions()
			if style == .indicator {
				layout.itemSpacing = 0
				layout.indicatorSize = .init(width: .fixed(20), height: 3)
			} else {
				layout.selectedTitleColor = .white
				layout.selectedBackgroundColor = .systemBlue
			}
			s.layout = layout

			return s
	}
}

extension PagingMenuDemoViewController: PagingMenuDelegate {
	func pagingMenu(_ pagingMenu: PagingMenu, didSelect tab: Tab, at index: Int) {
		print(tab.title.string)
	}
}
