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

class DependenciesViewController: NSViewController
{
    var fileDURL: URL? = URL(string: "")
    var isFileDownloaded: Bool = false
    var downloadTask: URLSessionTask? = nil
    
    override func viewDidLoad() {
        
    }    
    @IBOutlet weak var installbutton: NSButton!
    @IBOutlet weak var versionPrint: NSTextField!
    @IBOutlet weak var nextpage: NSButton!
    
    @IBAction func goBack1(_ sender: Any) {
       
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.view.window?.windowController?.contentViewController =  storyboard.instantiateController(withIdentifier: "checker1") as! NSViewController
        print("new window")

        
    }

    @IBAction func checkIfPythonExist(_ sender: Any) {
        var version: String = ""
        do {
            try version = safeShell("python3 --version")
            versionPrint.stringValue = version
            nextpage.isEnabled = true
        }
        catch {
            //print("\(error)") //handle or silence the error here
            versionPrint.stringValue = "Python 3 is not installed."
            installbutton.isEnabled = true
        }
    }
    
    @IBAction func reqDownloadPY(_ sender: Any) {
        let url = URL(string: "https://www.python.org/downloads/")!
        if NSWorkspace.shared.open(url) {
            print("Browser Successfully opened")
        }
        nextpage.isEnabled = true
        
    }
    
    @IBAction func changePage(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        var newCtrl: DependenciesViewController? = DependenciesViewController()
        do {
            newCtrl = try storyboard.instantiateController(withIdentifier: "checker2") as! DependenciesViewController
            
        }
        catch {
            print("nope.")
        }
        print("is nil: \(newCtrl == nil)")
        do {
            try self.view.window?.windowController?.contentViewController = newCtrl
            
        }
        catch {
            print("nope2.")
        }
        self.view.window?.close()
        self.view.window?.windowController?.showWindow(self)
        print("new window")
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
