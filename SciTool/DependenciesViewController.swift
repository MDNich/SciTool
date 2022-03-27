//
//  DependenciesViewController.swift
//  SciTool
//
//  Created by Marc D. Nichitiu on 3/21/22.
//

import Foundation
import PythonKit
import os
import Cocoa
import WebKit

class DependenciesViewController: NSViewController, NSTabViewDelegate
{
    var fileDURL: URL? = URL(string: "")
    var isFileDownloaded: Bool = false
    var downloadTask: URLSessionTask? = nil
    
    
    override func viewDidLoad() {
        if let _ = tabView {
            tabView.delegate = self
            if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == 0)
            {
                prevPage.isHidden = true
            }
            else if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == tabView.numberOfTabViewItems-1)
            {
                nextpage.title = "Finish"
                
            }
        }
    }
    
    func updateButtons()
    {
        if let _ = tabView {
            print(tabView.numberOfTabViewItems)
            print(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!))
            if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == 0)
            {
                prevPage.isHidden = true
            }
            else if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == tabView.numberOfTabViewItems-1)
            {
                nextpage.title = "Finish"
            }
        }
    }
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var installbutton: NSButton!
    @IBOutlet weak var versionPrint: NSTextField!
    @IBOutlet weak var nextpage: NSButton!
    @IBOutlet weak var prevPage: NSButton!
    @IBOutlet weak var mplversion: NSTextField!
    @IBOutlet weak var mplProgress: NSProgressIndicator!
    @IBOutlet weak var mplInstall: NSButton!
    @IBOutlet weak var numpyInstall: NSButton!
    @IBOutlet weak var numpyVersion: NSTextField!
    @IBOutlet weak var numpyProgress: NSProgressIndicator!
    
    
    
    
    @IBAction func checkIfPythonExist(_ sender: Any) {
        var version: String = ""
        do {
            try version = safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 --version")
            versionPrint.stringValue = version
            nextpage.isEnabled = true
        }
        catch {
            //print("\(error)") //handle or silence the error here
            versionPrint.stringValue = "Python 3 is not installed."
            installbutton.isEnabled = true
        }
    }
    @IBAction func installMPL(_ sender: Any) {
        mplProgress.isIndeterminate = true
        mplProgress.isHidden = false
        mplProgress.isDisplayedWhenStopped = true
        mplProgress.startAnimation(sender)
        DispatchQueue.main.async {
            do {
                try self.safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 -m pip install matplotlib --disable-pip-version")
            }
            catch {
                print(error)
            }
            self.mplProgress.stopAnimation(sender)
            self.mplProgress.isIndeterminate = false
            self.mplProgress.doubleValue = 100
            self.nextpage.isEnabled = true

        }
    }
    @IBAction func checkIfMPLexist(_ sender: Any) {
        // pip3 list | grep matplotlib | cut -c 20-
        var version: String = ""
        do {
            nextpage.isEnabled = true
            try version = safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 -m pip list --disable-pip-version-check | grep matplotlib | cut -c 20-")
            print(version)
            if(version == "") {
                version = "Matplotlib is not installed."
                mplInstall.isEnabled = true
                nextpage.isEnabled = false
            }
            mplversion.stringValue = version
        }
        catch {
            //print("\(error)") //handle or silence the error here
            mplversion.stringValue = "pip3 is not installed. Please reinstall Python 3."
            nextpage.isEnabled = false
            
        }
    }
    @IBAction func checkIfNumpyExist(_ sender: Any) {
        var version: String = ""
        do {
            nextpage.isEnabled = true
            try version = safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 -m pip list --disable-pip-version-check | grep numpy | cut -c 20-")
            print(version)
            if(version == "") {
                version = "Numpy is not installed."
                numpyInstall.isEnabled = true
                nextpage.isEnabled = false
            }
            numpyVersion.stringValue = version
        }
        catch {
            //print("\(error)") //handle or silence the error here
            numpyVersion.stringValue = "pip3 is not installed. Please reinstall Python 3."
            nextpage.isEnabled = false
            
        }
    }
    @IBAction func installNumpy(_ sender: Any) {
        numpyProgress.isIndeterminate = true
        numpyProgress.isHidden = false
        numpyProgress.isDisplayedWhenStopped = true
        numpyProgress.startAnimation(sender)
        DispatchQueue.main.async {
            do {
                try self.safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 -m pip install numpy --disable-pip-version")
            }
            catch {
                print(error)
            }
            self.numpyProgress.stopAnimation(sender)
            self.numpyProgress.isIndeterminate = false
            self.numpyProgress.doubleValue = 100
            self.nextpage.isEnabled = true

        }
    }
    @objc
    func finish(_ sender: Any)
    {
        self.view.window?.close()
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "list") as! NSWindowController
        //self.view.window?.contentView = windowController.window?.contentView
    //self.view.window?.beginSheet(windowController.window!)
        windowController.showWindow(self)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        updateButtons()
        if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == tabView.numberOfTabViewItems - 2)
        {
            nextpage.title = "Finish"
            nextpage.action = #selector(finish)
        }
        tabView.selectNextTabViewItem(sender)
        prevPage.isHidden = false
        updateButtons()

    }
    @IBAction func prevPage(_ sender: Any) {
        tabView.selectPreviousTabViewItem(sender)
        updateButtons()
    }
    @IBAction func reqDownloadPY(_ sender: Any) {
        let url = URL(string: "https://www.python.org/downloads/")!
        if NSWorkspace.shared.open(url) {
            print("Browser Successfully opened")
        }
        nextpage.isEnabled = true
    }
    
    
    
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }

    
}
