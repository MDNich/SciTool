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

    var imgIsReset: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img: NSImageView!
    
    @IBOutlet weak var ChargeXList: NSTextField!
    
    @IBOutlet weak var ChargeYList: NSTextField!
    
    @IBOutlet weak var ChargeQList: NSTextField!
    
    @IBOutlet weak var CoulombConstant: NSTextField!
    
    @IBOutlet weak var WindowLowerX: NSTextField!
    
    @IBOutlet weak var WindowUpperX: NSTextField!
    
    @IBOutlet weak var WindowLowerY: NSTextField!
    
    @IBOutlet weak var WindowUpperY: NSTextField!
    
    @IBOutlet weak var CounterNumber: NSTextField!
    
    @IBOutlet weak var ScatterPtDensity: NSTextField!
    
    @IBOutlet weak var DPI: NSTextField!
    
    
    //pathToSave,chargeXarr,chargeYarr,chargeQarr,windowLBoundX,windowLBoundY,windowUBoundX,windowUBoundY,steps,countourprec
    @IBOutlet weak var ProgressBar: NSProgressIndicator!
    
    
    
    
    
    
    func doImgRender()
    {
        var dirPath = FileManager.default.temporaryDirectory.absoluteString
        print(dirPath)
        dirPath.removeFirst(6)
        do {
            try runPythonCode(dirPathSave: dirPath) }
        catch {
            print("FAILED")
        }
        img.image = NSImage(contentsOfFile: "\(dirPath)/result.png")
        self.imgIsReset = false
    }
    
    @IBAction func exec(_ sender: Any) {
        self.ProgressBar.doubleValue = 30
        if(!imgIsReset) {
            img.image = NSImage(named: "Empty")
            self.imgIsReset = true
            DispatchQueue.main.async {
                self.doImgRender()
                self.ProgressBar.doubleValue = 100
            }
            
            return
        }
        else {
            doImgRender()
        }
        
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func convertStringToArr(str: String) -> Array<Int>
    {
        let tmp = str.split(separator: Character(","))
        var tmp2 = Array<Int>()
        for str in tmp {
            tmp2.append(Int(str) ?? 0)
        }
        return tmp2
        
    }
    func runPythonCode(dirPathSave: String) throws {
       // var mainBundle = resourcePath
        let dirPath = Bundle.main.resourcePath!
        print(dirPath)
        let xs = convertStringToArr(str: ChargeXList.stringValue)
        let ys = convertStringToArr(str: ChargeYList.stringValue)
        let qs = convertStringToArr(str: ChargeQList.stringValue)
        
        let sys = Python.import("sys")
        sys.path.append(dirPath)
        let engine = Python.import("voltage")
        let arr = [PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(ScatterPtDensity.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!),PythonObject.FloatLiteralType(Double(DPI.stringValue)!)] as [PythonConvertible]
        try engine.drawGraph.throwing.dynamicallyCall(withArguments: arr)
       // try engine.from_env.throwing.dynamicallyCall(withArguments: arr)
        /*try engine.drawGraph(PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(ScatterPtDensity.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!),PythonObject.FloatLiteralType(Double(DPI.stringValue)!))*/
       //try engine.drawGraph()*/
    }


}

