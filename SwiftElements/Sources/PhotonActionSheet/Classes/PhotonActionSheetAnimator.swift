//
//  PhotonActionSheetAnimator.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

public class PhotonActionSheetAnimator: NSObject {
	public var isPresenting: Bool = false
	
  private lazy var shadowView: UIView = {
    let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    return view
  }()
}

extension PhotonActionSheetAnimator: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension PhotonActionSheetAnimator: UIViewControllerAnimatedTransitioning {
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let from = transitionContext.viewController(forKey: .from),
			let to = transitionContext.viewController(forKey: .to),
				let sheet = (isPresenting ? to : from) as? PhotonActionSheet else {
			return
		}
		
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)

		if isPresenting {
      containerView.addSubview(shadowView)
			NSLayoutConstraint.activate([
				shadowView.topAnchor.constraint(equalTo: containerView.topAnchor),
				shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
				shadowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
				shadowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			])
			
			shadowView.alpha = 0
      
      sheet.view.frame.origin = CGPoint(x: 0, y: containerView.bounds.height)
      sheet.view.frame.size = containerView.bounds.size
      containerView.addSubview(sheet.view)
      sheet.view.layoutIfNeeded()
      
      UIView.animate(
        withDuration: duration,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0.3,
        options: []
      ) {
        self.shadowView.alpha = 1
        sheet.view.frame = containerView.bounds
        sheet.view.layoutIfNeeded()
      } completion: { complete in
        transitionContext.completeTransition(complete)
      }
		} else {
      UIView.animate(
        withDuration: duration,
        delay: 0,
        usingSpringWithDamping: 1.2,
        initialSpringVelocity: 0,
        options: []
      ) {
        self.shadowView.alpha = 0
        sheet.view.frame.origin = CGPoint(x: 0, y: containerView.bounds.height)
        sheet.view.frame.size = containerView.bounds.size
        sheet.view.layoutIfNeeded()
      } completion: { complete in
        self.shadowView.removeFromSuperview()
        transitionContext.completeTransition(complete)
      }
		}
	}
	
}
