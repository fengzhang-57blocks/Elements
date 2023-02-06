//
//  PageController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public class PageController: UIViewController {
	
	public lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
//		scrollView.showsVerticalScrollIndicator = false
//		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
  
  public private(set) var pages: [Page]?
  
  public lazy var tabControl = makeTabControl()
  
  private lazy var defaultTabControl: TabControl = {
    let control = TabControl()
    control.style = .indicator
    control.alignment = .tiled
    control.delegate = self
    return control
  }()
  
	weak public var dataSource: PageControllerDataSource?
	weak public var delegate: PageControllerDelegate?
  
  public var selectedPageIndex: Int = 0
  
  public var layout: PageController.Layout
  init(layout: PageController.Layout = PageController.Layout()) {
    self.layout = layout
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
	
	public override func viewDidLoad() {
		super.viewDidLoad()
    
		setupSubviews()
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
    
		tabControl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
    scrollView.frame = CGRect(
      x: 0,
      y: tabControl.frame.maxY,
      width: view.bounds.width,
      height: view.bounds.height - tabControl.bounds.height
    )
    
    if let count = dataSource?.numberOfPages(for: self) {
      scrollView.contentSize = CGSize(
        width: view.bounds.width * CGFloat(count),
        height: scrollView.bounds.height
      )
    }
    
    if let pages = pages {
      for page in pages {
        page.viewController.view.frame.origin = CGPoint(
          x: scrollView.bounds.width * CGFloat(page.index),
          y: scrollView.frame.minX
        )
        page.viewController.view.frame.size = scrollView.bounds.size
        page.viewController.view.setNeedsLayout()
        page.viewController.view.layoutIfNeeded()
      }
    }
	}
  
  func setupSubviews() {
    view.addSubview(tabControl)
    view.addSubview(scrollView)
    
    toleTabControl()
  }
}

extension PageController {
  func makeTabControl() -> TabControl {
    if let customizedControl = delegate?.tabControl {
      return customizedControl
    }
    
    return defaultTabControl
  }
  
  func toleTabControl() {
    guard let count = dataSource?.numberOfPages(for: self) else {
      return
    }
    
    var tabs = [Tab]()
    for index in 0..<count {
      if let page = dataSource?.pageController(self, pageAt: index) {
        let tab = Tab(
          title: NSAttributedString(string: page.title),
          isSelected: index == 0
        )
				tabs.append(tab)
      }
    }
		tabControl.reload(with: tabs)
  }
  
  func tolePages() {
    guard let dataSource = dataSource else {
      return
    }
    
    if pages == nil {
      pages = [Page]()
    }
    
    let count = dataSource.numberOfPages(for: self)
    
    let page = dataSource.pageController(self, pageAt: selectedPageIndex)
    if !pages!.contains(page) {
      addChild(page.viewController)
      scrollView.addSubview(page.viewController.view)
      pages!.append(page)
    }
    
    let prevIndex = selectedPageIndex - 1
    if prevIndex >= 0 {
      let prevPage = dataSource.pageController(self, pageAt: prevIndex)
      if !pages!.contains(prevPage) {
        addChild(prevPage.viewController)
        scrollView.addSubview(prevPage.viewController.view)
        pages!.append(prevPage)
      }
    }
    
    let nextIndex = selectedPageIndex + 1
    if nextIndex < count {
      let nextPage = dataSource.pageController(self, pageAt: nextIndex)
      if !pages!.contains(nextPage) {
        addChild(nextPage.viewController)
        scrollView.addSubview(nextPage.viewController.view)
        pages!.append(nextPage)
      }
    }
    
    delegate?.pageController(self, didDisplay: page)
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
}

extension PageController: TabControlDelegate {
//  public func numberOfItems(in tabControl: TabControl) -> Int {
//    return dataSource?.numberOfViewControllers(for: self) ?? 0
//  }
//
//  public func tabControl(_ tabControl: TabControl, tabAt index: Int) -> Tab {
//    if let title = delegate?.pageController(self, titleAt: index) {
//      return Tab(
//        title: NSAttributedString(string: title),
//        isSelected: index == 0
//      )
//    } else if let title = dataSource?.pageController(self, viewControllerFor: index).title {
//      return Tab(
//        title: NSAttributedString(string: title),
//        isSelected: index == 0
//      )
//    }
//
//    return Tab(title: NSAttributedString(string: ""))
//  }
//
//  public func tabControl(
//    _ tabControl: TabControl,
//    cellForItemAt index: Int) -> UICollectionViewCell {
//    return UICollectionViewCell()
//  }
  
  public func tabControl(_ tabControl: TabControl, didSelect tab: Tab, at index: Int) {
    selectedPageIndex = index
    
    let offset = CGPoint(x: scrollView.bounds.width * CGFloat(selectedPageIndex), y: 0)
    scrollView.setContentOffset(offset, animated: true)
    
    tolePages()
  }
}

extension PageController: UIScrollViewDelegate {
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let offsetX = scrollView.contentOffset.x
    let index = offsetX / scrollView.bounds.width
    
    selectedPageIndex = Int(index)
    
		tabControl.scrollTo(index: selectedPageIndex, animated: true)
  }
}
