//
//  PagingControllerDemoViewController.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/3.
//

import UIKit

class PagingControllerDemoViewController: BaseViewController {
  let pagingController = PagingController()
  
  var pages = [PagingController.Page]()
  
	override func viewDidLoad() {
		super.viewDidLoad()
    
    pagingController.dataSource = self
    pagingController.delegate = self
    
    view.addSubview(pagingController.view)
    pagingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pagingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pagingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pagingController.view.topAnchor.constraint(equalTo: view.centerYAnchor),
      pagingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    pagingController.view.backgroundColor = .orange
	}
}

extension PagingControllerDemoViewController: PagingControllerDataSource {
  func numberOfPages(for pagingController: PagingController) -> Int {
    return 5
  }
  
  func pagingController(_ pagingController: PagingController, pageAt index: Int) -> PagingController.Page {
    if let page = pages.filter({ $0.index == index }).first {
      return page
    }
    
    let pagingController = PageDemoViewController()
    let page = PagingController.Page(index: index, title: "\(index)", viewController: pagingController)
    pages.append(page)
    
    return page
  }
}

extension PagingControllerDemoViewController: PagingControllerDelegate {
  func pagingController(_ pagingController: PagingController, didDisplay page: PagingController.Page) {
    (page.viewController as! PageDemoViewController).label.text = "\(page.index)"
  }
}
