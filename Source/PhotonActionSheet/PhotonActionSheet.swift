//
//  PhotonActionSheet.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

struct PhotonActionSheetUX {
	static let Padding: CGFloat = 6
	static let RowHeight: CGFloat = 48
	static let CornerRadius: CGFloat = 10
	static let CloseButtonHeight: CGFloat = 56
	static let SeparatorRowHeight: CGFloat = 13
}

class PhotonActionSheet: UIViewController {
  var photonActionSheetTransitioningDelegate: UIViewControllerTransitioningDelegate? {
    didSet {
      transitioningDelegate = photonActionSheetTransitioningDelegate
    }
  }
  
  private var tableConstrains: [NSLayoutConstraint]?
  
	lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.addTarget(self, action: #selector(dismissViewController))
		tapGesture.numberOfTouchesRequired = 1
		tapGesture.cancelsTouchesInView = false
		tapGesture.delegate = self
		return tapGesture
	}()
	
	lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setTitle("关闭", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
		button.layer.cornerRadius = PhotonActionSheetUX.CornerRadius
		button.backgroundColor = .white
		return button
	}()
	
	let actions: [[PhotonAction]]
	
	let tableView = UITableView(frame: .zero, style: .grouped)
	
	required init(actions: [[PhotonAction]]) {
		self.actions = actions
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addGestureRecognizer(tapGesture)
		
		let width = view.bounds.width - PhotonActionSheetUX.Padding * 2
		
		view.addSubview(closeButton)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			closeButton.widthAnchor.constraint(equalToConstant: width),
			closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			closeButton.heightAnchor.constraint(equalToConstant: PhotonActionSheetUX.CloseButtonHeight),
			closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: PhotonActionSheetUX.Padding),
		])
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.layer.cornerRadius = PhotonActionSheetUX.CornerRadius
		tableView.register(PhotonActionSheetCell.self, forCellReuseIdentifier: NSStringFromClass(PhotonActionSheetCell.self))
		tableView.register(PhotonActionSheetSeparator.self, forHeaderFooterViewReuseIdentifier: "Separator")
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
		self.view.addSubview(tableView)
		
		tableView.sectionFooterHeight = 1
		
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: PhotonActionSheetUX.Padding))
		
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		tableView.backgroundView = blurEffectView
		tableView.backgroundColor = .clear
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
    if let constraints = tableConstrains {
      NSLayoutConstraint.deactivate(constraints)
      tableConstrains!.removeAll()
    }
    
    // TODO: - Detect device orientation so adjust table width
    
		let height = CGFloat.minimum(view.safeAreaLayoutGuide.layoutFrame.size.height * 0.9, tableView.contentSize.height)
    let width = view.bounds.width - PhotonActionSheetUX.Padding * 2
    preferredContentSize = tableView.contentSize
    tableConstrains = [
      tableView.widthAnchor.constraint(equalToConstant: width),
      tableView.heightAnchor.constraint(equalToConstant: height),
      tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -PhotonActionSheetUX.Padding),
    ]
    NSLayoutConstraint.activate(tableConstrains!)
	}
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    switch UIDevice.current.orientation {
    case .portrait, .portraitUpsideDown:
      break
    case .landscapeLeft, .landscapeRight:
      break
    default:
      break
    }
  }
	
	@objc private func dismissViewController() {
    dismiss(animated: true, completion: nil)
	}
	
}

extension PhotonActionSheet: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return actions.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actions[section].count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let section = actions[safe: indexPath.section], let action = section[safe: indexPath.row] {
			if let customHeight = action.customHeight {
				return customHeight(action)
			}
		}
		return PhotonActionSheetUX.RowHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let action = actions[indexPath.section][indexPath.row]
		let cellIdentifier = NSStringFromClass(PhotonActionSheetCell.self)
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PhotonActionSheetCell
    cell.configure(with: action)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return PhotonActionSheetUX.SeparatorRowHeight
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section > 0 {
			return tableView.dequeueReusableHeaderFooterView(withIdentifier: "Separator")
		}

		return tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)!
		let action = actions[indexPath.section][indexPath.row]
		guard let actionHandler = action.actionHandler else {
			dismiss(animated: true, completion: nil)
			return
		}

		dismiss(animated: true, completion: nil)

		actionHandler(action, cell)
	}
}

extension PhotonActionSheet: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if tableView.frame.contains(touch.location(in: self.view)) {
			return false
		}
		return true
	}
}
