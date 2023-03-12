//
//  PagingViewControllerSelfSizingExample.swift
//  Examples
//
//  Created by feng.zhang on 2023/3/11.
//

import UIKit
import SwiftElements

class PagingViewControllerSizeToFitExample: BaseViewController {
  
  private let movies = [
//    "The Godfather",
//    "The Shawshank Redemption",
//    "Schindler's List",
    "Raging Bull",
    "Casablanca",
//    "Citizen Kane",
//    "Gone with the Wind",
//    "The Wizard of Oz",
//    "One Flew Over the Cuckoo's Nest",
//    "Lawrence of Arabia",
//    "Vertigo",
//    "Psycho",
//    "The Godfather Part II",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var options = PagingOptions()
    options.itemSize = .sizeToFit(minWidth: 100, height: 40)
    
    lazy var pagingViewController = PagingViewController(options: options)
    
    pagingViewController.willMove(toParent: self)
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    pagingViewController.dataSource = self
  }
}

extension PagingViewControllerSizeToFitExample: PagingViewControllerDataSource {
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
