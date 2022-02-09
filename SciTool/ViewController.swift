//
//  ViewController.swift
//  SciTool
//
//  Created by Marc D. Nichitiu on 2/7/22.
//

import PythonKit
import os
import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img: NSImageView!
    
    
    @IBAction func exec(_ sender: Any) {
        var dirPath = FileManager.default.temporaryDirectory.absoluteString
        print(dirPath)
        dirPath.removeFirst(6)
        runPythonCode(dirPathSave: dirPath)
        img.image = NSImage(contentsOfFile: "\(dirPath)/result.png")
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func runPythonCode(dirPathSave: String){
       // var mainBundle = resourcePath
        let dirPath = Bundle.main.resourcePath!
        print(dirPath)
      let sys = Python.import("sys")
      sys.path.append(dirPath)
      let engine = Python.import("voltage")
        engine.drawGraph(PythonObject.StringLiteralType(dirPathSave))
        
    }


}

