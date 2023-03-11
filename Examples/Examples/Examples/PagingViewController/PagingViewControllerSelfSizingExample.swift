//
//  PagingViewControllerSelfSizingExample.swift
//  Examples
//
//  Created by feng.zhang on 2023/3/11.
//

import UIKit
import SwiftElements

class PagingViewControllerSelfSizingExample: BaseViewController {
  
  private let movies = [
    "The Godfather",
    "The Shawshank Redemption",
    "Schindler's List",
    "Raging Bull",
    "Casablanca",
    "Citizen Kane",
    "Gone with the Wind",
    "The Wizard of Oz",
    "One Flew Over the Cuckoo's Nest",
    "Lawrence of Arabia",
    "Vertigo",
    "Psycho",
    "The Godfather Part II",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var options = PagingOptions()
    options.itemSize = .selfSizing(estimatedWidth: 100, height: 40)
    
    lazy var pagingViewController = PagingViewController(options: options)
    
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    pagingViewController.dataSource = self
    pagingViewController.delegate = self
  }
}

extension PagingViewControllerSelfSizingExample: PagingViewControllerDataSource {
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return movies.count
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: movies[index])
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let viewController = PagingContentViewController()
    viewController.label.text = movies[index]
    viewController.title = movies[index]
    return viewController
  }
  
}

extension PagingViewControllerSelfSizingExample: PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem item: PagingItem) {
//    print("didSelectItem")
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    isScrollingFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
//    print("isScrollingFrom:to:", fromViewController.title!, toViewController.title!)
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    willBeginScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController
  ) {
//    print("willBeginScrollFrom:to:", fromViewController.title!, toViewController.title!)
  }
  
  func pagingViewController(
    _ pagingViewController: PagingViewController,
    didEndScrollFrom fromViewController: UIViewController,
    to toViewController: UIViewController,
    transitionSuccessful successful: Bool
  ) {
//    print("didEndScrollFrom:to:transitionSuccessful:", fromViewController.title!, toViewController.title!, successful)
  }
}

