//
//  PhotonActionSheetExampleViewController.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/1/9.
//

import UIKit
import SwiftElements

class PhotonActionSheetExampleViewController: BaseViewController {
	lazy var actions = makeActions()
	
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
    let sheet = PhotonActionSheet(actions: actions)
    sheet.photonTransitioningDelegate = PhotonActionSheetAnimator()
    sheet.modalPresentationStyle = .overFullScreen
    present(sheet, animated: true)
  }
	
	func makeHandlerAction(
		with title: NSAttributedString,
		iconType: PhotonAction.IconType = .none,
		iconImage: UIImage? = nil,
		isEnabled: Bool = true,
		isChecked: Bool = false,
		customHeight: PhotonAction.PhotonActionCustomHeight? = nil
	) -> PhotonAction {
		return PhotonAction(
			title: title,
			iconType: iconType,
			iconImage: iconImage,
			isChecked: isChecked,
			isEnabled: isEnabled) { action, cell in
				print("Click cell with action: \(action.title.string)")
				self.actions = self.actions.map { actionGroup -> [PhotonAction] in
					return actionGroup.map { tar in
						var mutableAction = tar
						mutableAction.isChecked = tar == action
						return mutableAction
					}
				}
			} customHeight: { action -> CGFloat in
				return customHeight?(action) ?? 50
			}
	}
	
	private func makeActions() -> [[PhotonAction]] {
		return [
			[
				makeHandlerAction(with: NSAttributedString(string: "Title Action", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)])),
				makeHandlerAction(with: NSAttributedString(string: "Title and Image Action"), iconType: .image, iconImage: UIImage(named: "github")),
				makeHandlerAction(with: NSAttributedString(string: "Disabled Action"), isEnabled: false),
				makeHandlerAction(with: NSAttributedString(string: "Default Selected Action"), isChecked: true),
				makeHandlerAction(with: NSAttributedString(string: "Height provided Action"), customHeight: { action in
					return 100
				}),
				makeHandlerAction(with: NSAttributedString(string: "Action Handler"))
			],
			[
				makeHandlerAction(with: NSAttributedString(string: "This Action is on another Section"))
			]
		]
	}
}
