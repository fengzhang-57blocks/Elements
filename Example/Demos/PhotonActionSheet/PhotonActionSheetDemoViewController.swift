//
//  PhotonActionSheetDemoViewController.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/1/9.
//

import UIKit

class PhotonActionSheetDemoViewController: BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "show",
      style: .plain,
      target: self,
      action: #selector(showPhotonActionSheet)
    )
  }
  
  @objc func showPhotonActionSheet() {
    let actions = [
      [
        PhotonAction(title: NSAttributedString(string: "Title Action", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)])),
        PhotonAction(
          title: NSAttributedString(string: "Title and Image Action"),
          iconType: .image,
          iconImage: UIImage(named: "github")
        ),
        PhotonAction(title: NSAttributedString(string: "Disabled Action"), isEnabled: false),
        PhotonAction(title: NSAttributedString(string: "Default Selected Action"), isSelected: true),
        PhotonAction(title: NSAttributedString(string: "Height provided Action"), customHeight: { action in
          return 100
        }),
        PhotonAction(title: NSAttributedString(string: "Action Handler"), actionHandler: { action, cell in
          print("Click cell with action: \(action.title.string)")
        })
      ],
      [
        PhotonAction(title: NSAttributedString(string: "This Action is on another Section"))
      ]
    ]
    let sheet = PhotonActionSheet(actions: actions)
    sheet.photonActionSheetTransitioningDelegate = PhotonActionSheetAnimator()
    sheet.modalPresentationStyle = .overFullScreen
    present(sheet, animated: true)
  }
}
