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
    
    let pagingViewController = PagingViewController()
    
//    pagingViewController.menuInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    pagingViewController.willMove(toParent: self)
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    pagingViewController.dataSource = self
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
    return PagingContentViewController(title: movies[index])
  }
  
}
