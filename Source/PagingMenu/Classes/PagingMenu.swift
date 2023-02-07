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

  public var alignment: PagingMenuAlignment = .centered

  public var style: PagingMenuStyle = .indicator

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
//		layout.scrollDirection = .horizontal

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

		switch alignment {
		case .centered:
			var cellSpacings: CGFloat = 0
			if tabs.count > 0 {
				cellSpacings = CGFloat(tabs.count - 1) * layout.itemSpacing
			}

			let contentWidth = tabs.reduce(0) {
				layout.contentInsets.horizontal +
				$0 +
				$1.title.boundingRectSize(bounds.size).width
			} + cellSpacings
      let realWidth = CGFloat.minimum(contentWidth, bounds.width)
      if realWidth.isEqual(to: bounds.width) {
				print(-half(contentWidth - realWidth))
        collectionView.contentOffset.x = half(contentWidth - realWidth)
      }

      collectionView.frame.size = CGSize(width: realWidth, height: bounds.height)
		case .tiled, .equalization:
			collectionView.frame.size = bounds.size
		}

		collectionView.center = CGPoint(x: half(bounds.width), y: half(bounds.height))
    
    // Recalculate cell size incase of device orientation change.
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
		DispatchQueue.main.asyncAfter(deadline: .now()) {
			if let selectedTab = self.selectedTab,
				 let index = self.tabs.firstIndex(of: selectedTab) {
				let indexPath = IndexPath(item: index, section: 0)
				self.collectionView.selectItem(
					at: indexPath,
					animated: true,
					scrollPosition: .centeredHorizontally
				)
				self.handleSelectTab(selectedTab, at: indexPath)
			}
		}
	}
  
  public func scrollTo(index: Int, animated: Bool) {
    guard index < tabs.count else {
      return
    }
  }
}

extension PagingMenu: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    if let dataSource = dataSource {
//      return dataSource.numberOfItems(in: self)
//    }

		return tabs.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if let dataSource = dataSource {
//      return dataSource.pagingMenu(self, cellForItemAt: indexPath.item)
//    }

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

private extension PagingMenu {
	func handleSelectTab(_ tab: Tab, at indexPath: IndexPath) {
		if let actionHandler = tab.handler {
			actionHandler(tab)
		} else if let delegate = delegate {
			delegate.pagingMenu(self, didSelect: tab, at: indexPath.item)
		}
	}
}
