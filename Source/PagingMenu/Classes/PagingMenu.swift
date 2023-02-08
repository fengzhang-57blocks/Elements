//
//  PagingMenu.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class PagingMenu: UIView {

	public var layout: PagingMenuOptions = PagingMenuOptions() {
		didSet {
			collectionView.reloadData()
		}
	}

	public weak var dataSource: PagingMenuDataSource?
	public weak var delegate: PagingMenuDelegate?

	public private(set) var collectionView: UICollectionView!

	private var selectedTab: Tab?

  private(set) public var tabs: [Tab]
	public required init(tabs: [Tab] = []) {
		self.tabs = tabs
		super.init(frame: .zero)

		selectedTab = tabs.filter({
			$0.isSelected
		}).first

		setupSubviews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupSubviews() {
		let layout = PagingMenuCollectionViewLayout()

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false

		collectionView.register(PagingMenuCell.self, forCellWithReuseIdentifier: "cell")

		collectionView.dataSource = self

		collectionView.bounces = true

		addSubview(collectionView)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		collectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		
    collectionView.reloadData()
	}
  
	public func reload(with tabs: [Tab]) {
		self.tabs = tabs

		selectedTab = tabs.filter({
			$0.isSelected
		}).first

    reloadData()
	}

	public func reloadData() {
		collectionView.reloadData()
	}
}

extension PagingMenu: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tabs.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = "cell"
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PagingMenuCell
    if let tab = dataSource?.pagingMenu(self, tabAt: indexPath.item) {
      cell.configure(tab, layout: layout)
    } else {
      cell.configure(tabs[indexPath.item], layout: layout)
    }

		return cell
	}
}

extension PagingMenu: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
}
