//
//  TabControl.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public class TabControl: UIView {

	public var layout: TabControlOptions = TabControlOptions() {
		didSet {
			collectionView.reloadData()
		}
	}

  public var alignment: TabControlAlignment = .centered

  public var style: TabControlStyle = .indicator

	public weak var dataSource: TabControlDataSource?
	public weak var delegate: TabControlDelegate?

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
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false

		collectionView.register(TabControlOvalCell.self, forCellWithReuseIdentifier: "oval")
		collectionView.register(TabControlIndicatorCell.self, forCellWithReuseIdentifier: "indicator")

		collectionView.dataSource = self
		collectionView.delegate = self

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
    
    collectionView(collectionView, didSelectItemAt: IndexPath(item: index, section: 0))
  }
}

extension TabControl: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let dataSource = dataSource {
      return dataSource.numberOfItems(in: self)
    }

		return tabs.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let dataSource = dataSource {
      return dataSource.tabControl(self, cellForItemAt: indexPath.item)
    }

		var identifier = "oval"
		if style == .indicator {
			identifier = "indicator"
		}
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TabControlCell
    if let tab = dataSource?.tabControl(self, tabAt: indexPath.item) {
      cell.configure(tab, layout: layout)
    } else {
      cell.configure(tabs[indexPath.item], layout: layout)
    }

		return cell
	}
}

extension TabControl: UICollectionViewDelegateFlowLayout {
	public func collectionView
	(_ collectionView: UICollectionView,
	 layout collectionViewLayout: UICollectionViewLayout,
	 sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let size = delegate?.tabControl(self, layout: collectionViewLayout, sizeForItemAt: indexPath.item),
				!size.equalTo(.zero) {
      return size
    }

    switch alignment {
		case .tiled, .centered:
			return CGSize(
				width: tabs[indexPath.item].title.boundingRectSize(bounds.size).width + layout.contentInsets.horizontal,
				height: bounds.height
			)
    case .equalization:
      return CGSize(
				width: (
					bounds.width - CGFloat(tabs.count - 1) * layout.itemSpacing
				) / CGFloat(tabs.count),
				height: bounds.height
			)
    }
	}

	public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
			if let spacing = delegate?.minimumInteritemSpacingForTabControl(self, layout: collectionViewLayout),
					!spacing.isEqual(to: .zero) {
        return spacing
      }

      return layout.itemSpacing
	}

	public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if let spacing = delegate?.minimumInteritemSpacingForTabControl(self, layout: collectionViewLayout),
				 !spacing.isEqual(to: .zero) {
        return spacing
      }

      return layout.itemSpacing
	}

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let tab = tabs[indexPath.item]

		if let selectedTab = selectedTab,
			 selectedTab.isEqual(to: tab),
				!layout.isRepeatTouchEnabled {
			return
		}

		selectedTab = tab
		tabs = tabs.map { s in
      var nexts = s
      nexts.isSelected = tab.title.isEqual(to: s.title)
      return nexts
    }

    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    collectionView.reloadData()

    handleSelectTab(tab, at: indexPath)
	}
}

extension TabControl: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
}

private extension TabControl {
	func handleSelectTab(_ tab: Tab, at indexPath: IndexPath) {
		if let actionHandler = tab.handler {
			actionHandler(tab)
		} else if let delegate = delegate {
			delegate.tabControl(self, didSelect: tab, at: indexPath.item)
		}
	}
}
