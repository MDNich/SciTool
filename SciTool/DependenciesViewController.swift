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
                nextpage.isEnabled = true
            }
        }
        nextpage.isEnabled = false
    }
    
    func updateButtons()
    {
        if let _ = tabView {
            print(tabView.numberOfTabViewItems)
            print(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!))
            if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == 0)
            {
                prevPage.isHidden = true
                nextpage.title = "Continue"
                nextpage.action = #selector(nextPage)
            }
            else if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == tabView.numberOfTabViewItems-1)
            {
                nextpage.title = "Finish"
                nextpage.action = #selector(finish)
                nextpage.isEnabled = true
            }
            else {
                nextpage.title = "Continue"
                nextpage.action = #selector(nextPage)
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
    @IBOutlet weak var plotlyVersion: NSTextField!
    @IBOutlet weak var plotlyInstall: NSButton!
    @IBOutlet weak var plotlyProgressBar: NSProgressIndicator!
    @IBOutlet weak var pandasVersion: NSTextField!
    @IBOutlet weak var pandasInstall: NSButton!
    @IBOutlet weak var pandasProgressBar: NSProgressIndicator!
    
    
    
    
    @IBAction func checkIfPythonExist(_ sender: Any) {
        var version: String = ""
        do {
            try version = safeShell("""
python3 --version | cut -c 8-
""")
            if(version.contains("zsh")) {
                throw InstallerErrror.PythonNotFound
            }
            versionPrint.stringValue = version
            nextpage.isEnabled = true
        }
        catch {
            //print("\(error)") //handle or silence the error here
            versionPrint.stringValue = "Python 3 is not installed or is not in PATH."
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
                try self.safeShell("python3 -m pip install matplotlib --disable-pip-version")
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
            try version = safeShell("python3 -m pip list --disable-pip-version-check | grep matplotlib | cut -c 17-")
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
            try version = safeShell("python3 -m pip list --disable-pip-version-check | grep numpy | cut -c 17-")
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
                try self.safeShell("python3 -m pip install numpy --disable-pip-version")
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
    
    @IBAction @objc func nextPage(_ sender: Any) {
        updateButtons()
        if(tabView.indexOfTabViewItem(tabView.selectedTabViewItem!) == tabView.numberOfTabViewItems - 2)
        {
            nextpage.title = "Finish"
            nextpage.action = #selector(finish)
            nextpage.isEnabled = true
        }
        else {
            nextpage.isEnabled = false
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
    
    @IBAction func checkIfPlotlyExist(_ sender: Any) {
        // pip3 list | grep matplotlib | cut -c 20-
        var version: String = ""
        do {
            nextpage.isEnabled = true
            try version = safeShell("python3 -m pip list --disable-pip-version-check | grep plotly | cut -c 17-")
            print(version)
            if(version == "") {
                version = "Plotly is not installed."
                plotlyInstall.isEnabled = true
                nextpage.isEnabled = false
            }
            plotlyVersion.stringValue = version
        }
        catch {
            //print("\(error)") //handle or silence the error here
            plotlyVersion.stringValue = "pip3 is not installed. Please reinstall Python 3."
            nextpage.isEnabled = false
            
        }
    }
    @IBAction func installPlotly(_ sender: Any) {
        plotlyProgressBar.isIndeterminate = true
        plotlyProgressBar.isHidden = false
        plotlyProgressBar.isDisplayedWhenStopped = true
        plotlyProgressBar.startAnimation(sender)
        DispatchQueue.main.async {
            do {
                try self.safeShell("python3 -m pip install plotly --disable-pip-version")
            }
            catch {
                print(error)
            }
            self.plotlyProgressBar.stopAnimation(sender)
            self.plotlyProgressBar.isIndeterminate = false
            self.plotlyProgressBar.doubleValue = 100
            self.nextpage.isEnabled = true

        }
    }
    
    @IBAction func checkIfPandasExist(_ sender: Any) {
        // pip3 list | grep matplotlib | cut -c 20-
        var version: String = ""
        do {
            nextpage.isEnabled = true
            try version = safeShell("pip3 list --disable-pip-version-check 2>/dev/null | grep pandas | grep pandas | cut -c 21-")
            print(version)
            if(version == "") {
                version = "Pandas is not installed."
                pandasInstall.isEnabled = true
                nextpage.isEnabled = false
            }
            pandasVersion.stringValue = version
        }
        catch {
            //print("\(error)") //handle or silence the error here
            pandasVersion.stringValue = "pip3 is not installed. Please reinstall Python 3."
            nextpage.isEnabled = false
            
        }
    }
    @IBAction func installPandas(_ sender: Any) {
        pandasProgressBar.isIndeterminate = true
        pandasProgressBar.isHidden = false
        pandasProgressBar.isDisplayedWhenStopped = true
        pandasProgressBar.startAnimation(sender)
        DispatchQueue.main.async {
            do {
                try self.safeShell("/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 -m pip install pandas --disable-pip-version")
            }
            catch {
                print(error)
            }
            self.pandasProgressBar.stopAnimation(sender)
            self.pandasProgressBar.isIndeterminate = false
            self.pandasProgressBar.doubleValue = 100
            self.nextpage.isEnabled = true

        }
    }
    
    
    
    // MARK: Misc Helper Methods
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
    
    
    enum InstallerErrror: Error {
        case PythonNotFound
        case ShellError
        case outOfStock
    }

    
}
