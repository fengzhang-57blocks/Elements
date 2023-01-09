//
//  PhotonActionSheetAnimator.swift
//  SwiftElements
//
//  Created by 57block on 2023/1/9.
//

import UIKit

class PhotonActionSheetAnimator: NSObject {
	var isPresenting: Bool = false
	
}

extension PhotonActionSheetAnimator: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension PhotonActionSheetAnimator: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let from = transitionContext.viewController(forKey: .from),
			let to = transitionContext.viewController(forKey: .to),
				let sheet = (isPresenting ? to : from) as? PhotonActionSheet else {
			return
		}
		
		
		if isPresenting {
			
		} else {
			
		}
	}
	
}
