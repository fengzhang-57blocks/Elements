//
//  PagingViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/10.
//

import UIKit

extension PagingViewController {
  enum DataSourceReference {
    case none
    case finite(PagingViewControllerFiniteDataSource)
    case `static`(PagingViewControllerStaticDataSource)
  }
}

open class PagingViewController: UIViewController {
  
	public weak var delegate: PagingViewControllerDelegate?
  public weak var sizeDelegate: PagingViewControllerSizeDelegate?
  public weak var infiniteDataSource: PagingViewControllerDynamicDataSource?
  public weak var dataSource: PagingViewControllerDataSource? {
    didSet {
      configureFiniteDataSource()
    }
  }
	
	public private(set) var pageViewController: PageViewController
	
	public let collectionView: UICollectionView
	public private(set) var collectionViewLayout: PagingMenuCollectionViewLayout {
		didSet {
//			collectionViewLayout.itemsCache = 
		}
	}
  
  public private(set) var viewControllers: [UIViewController]?
  
  private var dataSourceReference: DataSourceReference = .none
	
  public private(set) var options: PagingMenuOptions
  
  private var itemCache: PagingMenuItemCache {
    didSet {
      collectionViewLayout.itemCache = itemCache
    }
  }
  
  private(set) var sizeCache: PagingMenuItemSizeCache {
    didSet {
      collectionViewLayout.sizeCahce = sizeCache
    }
  }
  
  private(set) var state: PagingMenuState {
    didSet {
      collectionViewLayout.state = state
    }
  }
  
  private var didLayoutSubviews: Bool = false
	
	public init(options: PagingMenuOptions = PagingMenuOptions()) {
		self.options = options
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
    sizeCache = PagingMenuItemSizeCache(options: options)
    itemCache = PagingMenuItemCache(items: [])
    state = .empty
		super.init(nibName: nil, bundle: nil)
		collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.contentInsetAdjustmentBehavior = .never
    
    register(PagingMenuTitleCell.self, for: PagingMenuIndexItem.self)
	}
  
  public convenience init(
    options: PagingMenuOptions = PagingMenuOptions(),
    viewControllers: [UIViewController]
  ) {
    self.init(options: options)
    configureStaticDataSource()
  }
	
	public required init?(coder: NSCoder) {
		options = PagingMenuOptions()
		collectionViewLayout = PagingMenuCollectionViewLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		pageViewController = PageViewController(options: options)
    sizeCache = PagingMenuItemSizeCache(options: options)
    itemCache = PagingMenuItemCache(items: [])
    state = .empty
		super.init(coder: coder)
		collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.contentInsetAdjustmentBehavior = .never
    
    register(PagingMenuTitleCell.self, for: PagingMenuIndexItem.self)
	}
	
	open var pagingView: PagingView {
		return view as! PagingView
	}
	
	open override func loadView() {
		view = PagingView(
			collectionView: collectionView,
			pageView: pageViewController.view,
			options: options
		)
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		addChild(pageViewController)
    pagingView.createLayout()
		pageViewController.didMove(toParent: self)
    
    pageViewController.delegate = self
		pageViewController.dataSource = self
	}
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didLayoutSubviews {
      didLayoutSubviews = true
      switch state {
      case let .selected(item):
//        reloadItems(closeTo: item)
        collectionView.selectItem(
          at: itemCache.indexPath(for: item),
          animated: true,
          scrollPosition: .centeredHorizontally
        )
      default:
        break
      }
    }
  }
}

// MARK: Public Functions

public extension PagingViewController {
  func register(_ cellClass: AnyClass?, for item: PagingMenuItem.Type) {
    collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func register(_ nib: UINib?, for item: PagingMenuItem.Type) {
    collectionView.register(nib, forCellWithReuseIdentifier: String(describing: item))
  }
  
  func selectItem(_ item: PagingMenuItem, animated: Bool) {
    if collectionView.superview == nil || collectionView.window == nil {
      state = .selected(item: item)
      return
    }
    
    switch state {
    case .empty:
      state = .selected(item: item)
//      reloadItems(closeTo: item)
      collectionView.selectItem(
        at: itemCache.indexPath(for: item),
        animated: animated,
        scrollPosition: .centeredHorizontally
      )
    case let .selected(currentSelectedItem) where !currentSelectedItem.isEqual(to: item):
      if animated {
        state = .scrolling(
          currentPagingItem: currentSelectedItem,
          upcomingPagingItem: item,
          progress: 0,
          initialContentOffset: collectionView.contentOffset,
          distance: 0
        )
      } else {
        state = .selected(item: item)
//        reloadItems(closeTo: item)
        collectionView.selectItem(
          at: itemCache.indexPath(for: item),
          animated: animated,
          scrollPosition: .centeredHorizontally
        )
      }
    default:
      break
    }
  }
  
  func selectIndex(_ index: Int, animated: Bool) {
    switch dataSourceReference {
    case let .static(dataSource):
      selectItem(dataSource.itemForIndex(index), animated: animated)
    case let .finite(dataSource):
      selectItem(dataSource.itemForIndex(index), animated: animated)
    case .none:
      fatalError("selectIndex(_:animated:): You need to implement the dataSource.")
    }
  }
  
  func reloadData() {
    var items: [PagingMenuItem] = []
    switch dataSourceReference {
    case let .static(dataSource):
      dataSource.reloadItems()
      items = dataSource.items
    case let .finite(dataSource):
      items = allPagingMenuItems()
      dataSource.updateItems(items)
    case .none:
      break
    }
    
    if let prevSelectedItem = state.currentPagingMenuItem {
      if let currentSelectedItem = items.first(where: { $0.isEqual(to: prevSelectedItem) }) {
        state = .selected(item: currentSelectedItem)
      }
    } else if let firstItem = items.first {
      state = .selected(item: firstItem)
    } else {
      resetToDefaultState()
    }
  }
}

// MARK: Private Functions

private extension PagingViewController {
  func configureFiniteDataSource() {
    let items = allPagingMenuItems()
    itemCache = PagingMenuItemCache(items: items)
    let dataSource = PagingViewControllerFiniteDataSource(items: items)
    dataSource.viewControllerForIndex = { [unowned self] index in
      self.dataSource?.pagingViewController(self, viewControllerAt: index)
    }
    dataSourceReference = .finite(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func configureStaticDataSource() {
    guard let viewControllers = viewControllers else {
      return
    }
    let dataSource = PagingViewControllerStaticDataSource(viewControllers: viewControllers)
    itemCache = PagingMenuItemCache(items: dataSource.items)
    dataSourceReference = .static(dataSource)
    infiniteDataSource = dataSource
    
    if let firstItem = dataSource.items.first {
      selectItem(firstItem, animated: false)
    }
  }
  
  func allPagingMenuItems() -> [PagingMenuItem] {
    guard let dataSource = dataSource else {
      return []
    }
    
    var items: [PagingMenuItem] = []
    for index in 0..<dataSource.numberOfViewControllers() {
      items.append(dataSource.pagingViewController(self, pagingMenuItemAt: index))
    }
    
    return items
  }
  
  func resetToDefaultState() {
    state = .empty
    sizeCache.clearCahces()
    itemCache = PagingMenuItemCache(items: [])
    collectionView.reloadData()
  }
  
  func pagingMenuItem(before item: PagingMenuItem) -> PagingMenuItem? {
    return nil
  }
  
  func pagingMenuItem(after item: PagingMenuItem) -> PagingMenuItem? {
    return nil
  }
}

// MARK: UICollectionViewDataSource

extension PagingViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemCache.items.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let pagingMenuItem = itemCache.item(for: indexPath)
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: type(of: pagingMenuItem)),
      for: indexPath) as! PagingMenuCell
    var isSelected = false
    if let currentPagingItem = state.currentPagingMenuItem {
      isSelected = currentPagingItem.isEqual(to: pagingMenuItem)
    }
    cell.setPagingMenuItem(pagingMenuItem, selected: isSelected, options: options)
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension PagingViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

// MARK: PageViewControllerDataSource

extension PagingViewController: PageViewControllerDataSource {
  public func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
        let currentPagingMenuItem = state.currentPagingMenuItem,
          let item = dataSource.pagingViewController(self, itemBefore: currentPagingMenuItem) else {
      return nil
    }
    
    return dataSource.pagingViewController(self, viewControllerFor: item)
  }
  
  public func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let dataSource = infiniteDataSource,
        let currentPagingMenuItem = state.currentPagingMenuItem,
          let item = dataSource.pagingViewController(self, itemAfter: currentPagingMenuItem) else {
      return nil
    }
    
    return dataSource.pagingViewController(self, viewControllerFor: item)
  }
}

// MARK: PageViewControllerDelegate

extension PagingViewController: PageViewControllerDelegate {
	public func pageViewController(
		_ pageViewController: PageViewController,
		willBeginScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	) {
		
	}
	
	public func pageViewController(
		_ pageViewController: PageViewController,
		isScrolling fromViewController: UIViewController,
		to destinationViewController: UIViewController,
		with progress: CGFloat
	) {
		
	}
	
	public func pageViewController(
		_ pageViewController: PageViewController,
		didEndScroll fromViewController: UIViewController,
		to destinationViewController: UIViewController
	) {
		
	}
}

// MARK: UIScrollViewDelegate

extension PagingViewController: UIScrollViewDelegate {
	
}
