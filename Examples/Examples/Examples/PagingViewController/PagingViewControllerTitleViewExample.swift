//
//  PagingViewControllerTitleViewExample.swift
//  Examples
//
//  Created by feng.zhang on 2023/3/11.
//

import UIKit
import SwiftElements

class TitleViewExamplePagingView: PagingView {
  override func setupConstraints() {
    pageView.translatesAutoresizingMaskIntoConstraints = false
    
    let views = [
      "pageView": pageView,
    ]
    
    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[pageView]|",
        metrics: nil,
        views: views
      )
    )
    
    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[pageView]|",
        metrics: nil,
        views: views
      )
    )
  }
}

class TitleViewPagingViewController: PagingViewController {
  override func loadView() {
    view = TitleViewExamplePagingView(
      collectionView: collectionView,
      pageView: pageViewController.view,
      options: options
    )
  }
}

class PagingViewControllerTitleViewExample: BaseViewController {
  let pagingOptions = PagingOptions(
    indicatorOptions: .hidden,
    borderOptions: .hidden,
    textColor: .white,
    backgroundColor: .clear,
    selectedBackgroundColor: .clear
  )
  
  lazy var pagingViewController: TitleViewPagingViewController = {
    return TitleViewPagingViewController(options: pagingOptions)
  }()
  
  private let viewTitles = [
    "View 1",
    "View 2",
    "View 3",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pagingViewController.willMove(toParent: self)
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)

    navigationItem.titleView = pagingViewController.collectionView
    
    pagingViewController.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let bar = navigationController?.navigationBar else {
      return
    }
    navigationItem.titleView?.frame = CGRect(origin: .zero, size: bar.bounds.size)
  }
}

extension PagingViewControllerTitleViewExample: PagingViewControllerDataSource {
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return viewTitles.count
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: viewTitles[index])
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let contentViewController = PagingContentViewController()
    contentViewController.title = viewTitles[index]
    
    return contentViewController
  }
}
