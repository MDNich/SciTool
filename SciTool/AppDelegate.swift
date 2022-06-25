//
//  AppDelegate.swift
//  SciTool
//
//  Created by Marc D. Nichitiu on 2/7/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print("hello worlds")
        if(!flag) {
            if(NSApplication.shared.windows.count <= 1) {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                let windowController = storyboard.instantiateController(withIdentifier: "splashController") as! NSWindowController
                windowController.showWindow(self)
                
            }
        }
        return false
    }


}

