//
//  GestureConfigMainController.swift
//  ReceiverMac
//
//  Created by Marc D. Nichitiu on 12/11/21.
//  Copyright © 2021 MultiTouchFX. All rights reserved.
//

import Foundation
import Cocoa

class MasterViewController: NSViewController {
	
	@IBOutlet weak var TabView: NSTabView!
	public static var TabViewS: NSTabView!
	

	
	public static var windowMain: NSWindow!
	
	override func viewDidLoad() {
        MasterViewController.TabViewS = TabView
        MasterViewController.windowMain = self.view.window
	}
	func update(tab: Int)
	{
		TabView.selectTabViewItem(at: tab)
	}
	@IBOutlet weak var TwoFingerDragView: NSView!
	
	@IBOutlet weak var TwoFingerTapView: NSView!
	

}
