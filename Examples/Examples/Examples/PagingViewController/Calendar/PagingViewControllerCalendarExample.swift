//
//  PagingViewControllerCalendarExample.swift
//  Examples
//
//  Created by feng.zhang on 2023/3/12.
//

import UIKit
import SwiftElements

struct CalendarItem: PagingItem, Hashable, Comparable {
  let date: Date
  let dateText: String
  let weekdayText: String

  init(date: Date) {
    self.date = date
    dateText = DateFormatters.dateFormatter.string(from: date)
    weekdayText = DateFormatters.weekdayFormatter.string(from: date)
  }

  static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date < rhs.date
  }
}

class PagingViewControllerCalendarExample: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let pagingViewController = PagingViewController()
    pagingViewController.register(CalendarPagingCell.self, for: CalendarItem.self)
    pagingViewController.itemSize = .fixed(width: 48, height: 58)
    pagingViewController.textColor = UIColor.gray

    // Add the paging view controller as a child view
    // controller and constrain it to all edges
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)

    // Set our custom data source
    pagingViewController.infiniteDataSource = self

    // Set the current date as the selected paging item
    pagingViewController.selectItem(CalendarItem(date: Date()), animated: false)
  }
}

extension PagingViewControllerCalendarExample: PagingViewControllerDynamicDataSource {
  func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(86400))
  }

  func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(-86400))
  }

  func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
    let calendarItem = pagingItem as! CalendarItem
    let formattedDate = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
    return PagingContentViewController(title: formattedDate)
  }
}

