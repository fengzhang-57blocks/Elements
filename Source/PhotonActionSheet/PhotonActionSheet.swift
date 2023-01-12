//
//  PhotonActionSheet.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

public class PhotonActionSheet: UIViewController {
  var photonActionSheetTransitioningDelegate: UIViewControllerTransitioningDelegate? {
    didSet {
      transitioningDelegate = photonActionSheetTransitioningDelegate
    }
  }
  
	private var constrains = [NSLayoutConstraint]()
  
	private lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.addTarget(self, action: #selector(dismissViewController))
		tapGesture.numberOfTouchesRequired = 1
		tapGesture.cancelsTouchesInView = false
		tapGesture.delegate = self
		return tapGesture
	}()
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setTitle("关闭", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
		button.layer.cornerRadius = configure.cornerRadius
		button.backgroundColor = .white
		return button
	}()
	
	let actions: [[PhotonAction]]
	
	let configure: PhotonActionSheet.Configuration
	
	private let tableView = UITableView(frame: .zero, style: .grouped)
	
	required init(actions: [[PhotonAction]], configure: PhotonActionSheet.Configuration = .default) {
		self.actions = actions
		self.configure = configure
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addGestureRecognizer(tapGesture)
		
		view.addSubview(closeButton)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.layer.cornerRadius = configure.cornerRadius
		tableView.register(PhotonActionSheetCell.self, forCellReuseIdentifier: NSStringFromClass(PhotonActionSheetCell.self))
		tableView.register(PhotonActionSheetSeparator.self, forHeaderFooterViewReuseIdentifier: "Separator")
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
		self.view.addSubview(tableView)
		
		tableView.sectionFooterHeight = 1
		
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: configure.spacing))
		
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		tableView.backgroundView = blurEffectView
		tableView.backgroundColor = .clear
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if constrains.count > 0 {
      NSLayoutConstraint.deactivate(constrains)
			constrains.removeAll()
    }
		
		let deviceOrientation = UIDevice.current.orientation
		let safeSizeHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
		var height = CGFloat.minimum(safeSizeHeight * 0.9, tableView.contentSize.height)
		var width = view.bounds.width - configure.spacing * 2
		
		if deviceOrientation.isLandscape {
			height = CGFloat.minimum(safeSizeHeight * 0.7, configure.maxSheetHeight)
			width = configure.maxSheetWidth
		}
		
		constrains.append(contentsOf: [
			closeButton.widthAnchor.constraint(equalToConstant: width),
			closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			closeButton.heightAnchor.constraint(equalToConstant: configure.closeButtonHeight),
			closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: configure.spacing),
		])
		
		constrains.append(contentsOf:  [
			tableView.widthAnchor.constraint(equalToConstant: width),
			tableView.heightAnchor.constraint(equalToConstant: height),
			tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -configure.spacing),
		])
		
    NSLayoutConstraint.activate(constrains)
		
		preferredContentSize = tableView.contentSize
	}
  
	public override func updateViewConstraints() {
    super.updateViewConstraints()
  }
  
	public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
	public func numberOfSections(in tableView: UITableView) -> Int {
		return actions.count
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actions[section].count
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let section = actions[safe: indexPath.section], let action = section[safe: indexPath.row] {
			if let customHeight = action.customHeight {
				return customHeight(action)
			}
		}
		return configure.actionHeight
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let action = actions[indexPath.section][indexPath.row]
		let cellIdentifier = NSStringFromClass(PhotonActionSheetCell.self)
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PhotonActionSheetCell
    cell.configure(with: action)
		return cell
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return configure.separatorRowHeight
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section > 0 {
			return tableView.dequeueReusableHeaderFooterView(withIdentifier: "Separator")
		}

		return tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if tableView.frame.contains(touch.location(in: self.view)) {
			return false
		}
		return true
	}
}
