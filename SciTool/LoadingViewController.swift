//
//  SplashViewController.swift
//  SciTool
//
//  Created by Marc Nich on 6/25/22.
//

import Foundation
import AppKit

class LoadingViewController: NSViewController {
    
    public static var qCont: Bool = false
    
    @IBOutlet weak var loadingLabel: NSTextField!
    @IBOutlet weak var progressbar: NSProgressIndicator!
    
    @IBOutlet weak var continuebutton: NSButton!
    override func viewDidLoad() {
        progressbar.isIndeterminate = false
        progressbar.startAnimation(nil)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (t) in
            self.progressbar.doubleValue = self.progressbar.doubleValue + 10
            if(self.progressbar.doubleValue >= 100) {
                LoadingViewController.qCont = true
                self.progressbar.isIndeterminate = false
                self.progressbar.doubleValue = 100.0
                self.loadingLabel.stringValue = "Ready!"
                self.continuebutton.isEnabled = true
            }
        }
        
    }
    
    
    @IBAction func `continue`(_ sender: Any) {
        print(" yo__")
        self.view.window?.close()
        self.view.window?.sheetParent?.close()
        self.view.window?.sheetParent?.endSheet((self.view.window)!)
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "splashController") as! NSWindowController
        windowController.showWindow(self)
    }
    
}
