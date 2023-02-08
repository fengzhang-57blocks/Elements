//
//  PagingController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

public class PagingController: UIViewController {
	
	public lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
//		scrollView.showsVerticalScrollIndicator = false
//		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
  
  public private(set) var pages: [Page]?
  
  public lazy var pagingMenu = makePagingMenu()
  
  private lazy var defaultPagingMenu: PagingMenu = {
    let control = PagingMenu()
    control.delegate = self
    return control
  }()
  
	weak public var dataSource: PagingControllerDataSource?
	weak public var delegate: PagingControllerDelegate?
  
  public var selectedPageIndex: Int = 0
  
  public var layout: PagingController.Layout
  init(layout: PagingController.Layout = PagingController.Layout()) {
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
    
		pagingMenu.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
    scrollView.frame = CGRect(
      x: 0,
      y: pagingMenu.frame.maxY,
      width: view.bounds.width,
      height: view.bounds.height - pagingMenu.bounds.height
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
    view.addSubview(pagingMenu)
    view.addSubview(scrollView)
    
    tolePagingMenu()
  }
}

extension PagingController {
  func makePagingMenu() -> PagingMenu {
    if let customizedControl = delegate?.pagingMenu {
      return customizedControl
    }
    
    return defaultPagingMenu
  }
  
  func tolePagingMenu() {
    guard let count = dataSource?.numberOfPages(for: self) else {
      return
    }
    
    var tabs = [Tab]()
    for index in 0..<count {
      if let page = dataSource?.pagingController(self, pageAt: index) {
        let tab = Tab(
          title: NSAttributedString(string: page.title),
          isSelected: index == 0
        )
				tabs.append(tab)
      }
    }
		pagingMenu.reload(with: tabs)
  }
  
  func tolePages() {
    guard let dataSource = dataSource else {
      return
    }
    
    if pages == nil {
      pages = [Page]()
    }
    
    let count = dataSource.numberOfPages(for: self)
    
    let page = dataSource.pagingController(self, pageAt: selectedPageIndex)
    if !pages!.contains(page) {
      addChild(page.viewController)
      scrollView.addSubview(page.viewController.view)
      pages!.append(page)
    }
    
    let prevIndex = selectedPageIndex - 1
    if prevIndex >= 0 {
      let prevPage = dataSource.pagingController(self, pageAt: prevIndex)
      if !pages!.contains(prevPage) {
        addChild(prevPage.viewController)
        scrollView.addSubview(prevPage.viewController.view)
        pages!.append(prevPage)
      }
    }
    
    let nextIndex = selectedPageIndex + 1
    if nextIndex < count {
      let nextPage = dataSource.pagingController(self, pageAt: nextIndex)
      if !pages!.contains(nextPage) {
        addChild(nextPage.viewController)
        scrollView.addSubview(nextPage.viewController.view)
        pages!.append(nextPage)
      }
    }
    
    delegate?.pagingController(self, didDisplay: page)
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
}

extension PagingController: PagingMenuDelegate {
  public func pagingMenu(_ pagingMenu: PagingMenu, didSelect tab: Tab, at index: Int) {
    selectedPageIndex = index
    
    let offset = CGPoint(x: scrollView.bounds.width * CGFloat(selectedPageIndex), y: 0)
    scrollView.setContentOffset(offset, animated: true)
    
    tolePages()
  }
}

extension PagingController: UIScrollViewDelegate {
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
  }
}
