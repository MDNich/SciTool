//
//  ProjectileViewControllers.swift
//  SciTool
//
//  Created by Marc D. Nichitiu on 10/19/23.
//

import Foundation
import AppKit


class ProjectileViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    final let g = 9.81 // m/s^2
    final let G = 6.67e-11 // SI
    
    @IBOutlet weak var iniVel: NSTextField!
    @IBOutlet weak var iniAng: NSTextField!
    @IBOutlet weak var deltaH: NSTextField!
    
    @IBOutlet weak var iniVelUnit: NSPopUpButton!
    @IBOutlet weak var iniAngUnit: NSPopUpButton!
    @IBOutlet weak var deltaHUnit: NSPopUpButton!
    
    @IBOutlet weak var resultTotalTime: NSTextField!
    @IBOutlet weak var resultTotalRange: NSTextField!
    @IBOutlet weak var resultMaxHeight: NSTextField!
    @IBOutlet weak var resultImpactVel: NSTextField!
    
    
    @IBAction func calculate(_ sender: Any) {
        // first convert all fields to SI units.
        var iniVelVal = Double(iniVel.stringValue)!
        switch iniVelUnit.indexOfSelectedItem {
            case 0: // m/s only for now
                iniVelVal = iniVelVal*1
            default:
                iniVelVal = iniVelVal*1
        }
        var iniAngVal = Double(iniAng.stringValue)!
        switch iniAngUnit.indexOfSelectedItem {
            case 0: // deg
                iniAngVal = iniAngVal * Double.pi / 180.0
            case 1: // radian
                iniAngVal = iniAngVal * 1
            case 2: // gradian
                iniAngVal = iniAngVal / 400 * 2 * Double.pi
            default:
                iniAngVal = iniAngVal*1
        }
        var deltaHVal = Double(deltaH.stringValue)!
        switch deltaHUnit.indexOfSelectedItem {
            case 0: // m
                deltaHVal = deltaHVal * 1
            case 1: // km
                deltaHVal = deltaHVal / 1000
            case 2: // cm
                deltaHVal = deltaHVal * 100
            default:
                deltaHVal = deltaHVal*1
        }
        
        
        let vx0 = iniVelVal * Foundation.cos(iniAngVal)
        let vy0 = iniVelVal * Foundation.sin(iniAngVal)
        
        let totalT = (vy0+Foundation.sqrt(vy0*vy0-2*g*deltaHVal))/g
        if(totalT.isNaN) {
            resultTotalTime.stringValue = "Unsolvable"
            resultImpactVel.stringValue = "Unsolvable"
            resultMaxHeight.stringValue = "Unsolvable"
            resultTotalRange.stringValue = "Unsolvable"
            return
        }
        resultTotalTime.stringValue = "\(totalT)"
        
        let totalX = vx0*totalT
        resultTotalRange.stringValue = "\(totalX)"
        
        let maxHeight = vy0*vy0/2/g
        resultMaxHeight.stringValue = "\(maxHeight)"
        
        let vyf = abs(vy0-g*totalT)
        let vxf = vx0
        let vf = sqrt(vyf*vyf + vxf*vxf)
        
        resultImpactVel.stringValue = "\(vf)"
        
    }
    
    
}
