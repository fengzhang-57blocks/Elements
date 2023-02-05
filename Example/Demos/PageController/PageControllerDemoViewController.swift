//
//  PageControllerDemoViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

class PageControllerDemoViewController: BaseViewController {
  let pageController = PageController()
  
  var pages = [PageController.Page]()
  
	override func viewDidLoad() {
		super.viewDidLoad()
    
    pageController.dataSource = self
    pageController.delegate = self
    
    view.addSubview(pageController.view)
    pageController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageController.view.topAnchor.constraint(equalTo: view.centerYAnchor),
      pageController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    pageController.view.backgroundColor = .orange
	}
}

extension PageControllerDemoViewController: PageControllerDataSource {
  func numberOfPages(for pageController: PageController) -> Int {
    return 5
  }
  
  func pageController(_ pageController: PageController, pageAt index: Int) -> PageController.Page {
    if let page = pages.filter({ $0.index == index }).first {
      return page
    }
    
    let pageController = PageDemoViewController()
    let page = PageController.Page(index: index, title: "\(index)", viewController: pageController)
    pages.append(page)
    
    return page
  }
}

extension PageControllerDemoViewController: PageControllerDelegate {
  func pageController(_ pageController: PageController, didDisplay page: PageController.Page) {
    (page.viewController as! PageDemoViewController).label.text = "\(page.index)"
  }
}
