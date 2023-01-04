//
//  ViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let segments = ["Swift", "Objective-c", "Javascript", "Goland", "PHP"].map {
			Segment(title: $0)
		}
		let segmentControl = SegmentControl(segments: segments)
		segmentControl.translatesAutoresizingMaskIntoConstraints = false
//    segmentControl.alignment = .centered
		segmentControl.backgroundColor = .orange
    
    segmentControl.style = .oval
		
		view.addSubview(segmentControl)
		
		NSLayoutConstraint.activate([
			segmentControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			segmentControl.heightAnchor.constraint(equalToConstant: 50),
		])
	}


}

