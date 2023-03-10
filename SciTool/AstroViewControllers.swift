//
//  ViewController.swift
//  StarCalc
//
//  Created by Marc D. Nichitiu on 3/9/23.
//

import Cocoa

class LumMagViewController: NSViewController {

    @IBOutlet weak var knownQuantity: NSTextField!
    
    @IBOutlet weak var whatToSolveFor: NSPopUpButton!
    
    
    @IBOutlet weak var distField: NSTextField!
    @IBOutlet weak var ResultField: NSTextField!
    
    @IBOutlet weak var distUnits: NSPopUpButton!
    
    @IBOutlet weak var isMainSequence: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        let input = Double(knownQuantity.stringValue)
        var dist = Double(distField.stringValue)
        let distUnit = distUnits.indexOfSelectedItem // 0 = pc, 1 = ly, 2 = mas
        
        if(distUnit == 1) {
            dist = dist!/3.261563
        }
        else if(distUnit == 2) {
            // d = 1/p
            dist = 1/(dist!/1000)
        }
        
        
        let whatGiven = whatToSolveFor.indexOfSelectedItem
        if(whatGiven == 2) { // FIND LUMINOSITY
            let L0 = 3.0128e28 // W
            let exp = -0.4*(input!+5-5*log10(dist!))
            
            let Lsun = 3.9e26 // W

            let lum = L0 * pow(10, exp)
            let lumFactor = lum / Lsun
            
            var strExtra = ""
            if(isMainSequence.state == NSControl.StateValue.on) {
                let mass = pow(lumFactor,1/3.5)
                let Msun = 1.989E30 //kg
                let massKg = mass*Msun
                strExtra = ". Mass \(mass) Msun =  \(massKg) kg"
            }
            
            ResultField.stringValue = "Luminosity of star is \(lum) W or \(lumFactor) L_sun. Distance is \(dist!) pc, \(dist!*3.261563) ly, and has a parallax of \(1/dist! * 1000) mas. Abs Magnitude: \(input!+5-5*log10(dist!)), App Magnitude: \(input!)\(strExtra)"
            
            
            
            
        }
        else if (whatGiven == 0) { // FIND Magnitude
            print("Calculating Magnitudes given \(input!) L_sun at a distance \(dist) pc")
            let Lsun = 3.9e26 // W
            let input2 = input!*Lsun
            let Mbol = -2.5*log10(input2) + 71.1974 // magnitude
            let M_app = Mbol - 5 + 5*log10(dist!)
            
            var strExtra = ""
            if(isMainSequence.state == NSControl.StateValue.on) {
                let mass = pow(input!,1/3.5)
                let Msun = 1.989E30 //kg
                let massKg = mass*Msun
                strExtra = ". Mass \(mass) Msun =  \(massKg) kg"
            }
            
            ResultField.stringValue = "Absolute magnitude of star is \(Mbol); apparent magnitude is \(M_app). Distance is \(dist!) pc, \(dist!*3.261563) ly, and has a parallax of \(1/dist! * 1000) mas.\(strExtra)"
        }
        else if (whatGiven == 1){ // FIND Magnitude
            let Lsun = 3.9e26 // W
            //let input2 = input!*Lsun
            let Mbol = -2.5*log10(input!) + 71.1974 // magnitude
            let M_app = Mbol - 5 + 5*log10(dist!)
            
            var strExtra = ""
            if(isMainSequence.state == NSControl.StateValue.on) {
                let mass = pow(input!/Lsun,1/3.5)
                let Msun = 1.989E30 //kg
                let massKg = mass*Msun
                strExtra = ". Mass \(mass) Msun =  \(massKg) kg"
            }
            
            
            
            ResultField.stringValue = "Absolute magnitude of star is \(Mbol); apparent magnitude is \(M_app). Distance is \(dist!) pc, \(dist!*3.261563) ly, and has a parallax of \(1/dist! * 1000) mas. Abs Magnitude: \(Mbol), App Magnitude: \(M_app)\(strExtra)"
        }
        else { // FIND LUMINOSITY FROM ABS MAG
            let L0 = 3.0128e28 // W
            let Lsun = 3.9e26 // W
            
            let exp = -0.4*(input!)
            let lum = L0 * pow(10, exp)
            let lumFactor = lum / Lsun
            
            var strExtra = ""
            if(isMainSequence.state == NSControl.StateValue.on) {
                let mass = pow(lumFactor,1/3.5)
                let Msun = 1.989E30 //kg
                let massKg = mass*Msun
                strExtra = ". Mass \(mass) Msun =  \(massKg) kg"
            }
            
            
            ResultField.stringValue = "Luminosity of star is \(lum) W or \(lumFactor) L_sun. Distance is \(dist!) pc, \(dist!*3.261563) ly, and has a parallax of \(1/dist! * 1000) mas. Abs Magnitude: \(input!), App Magnitude: \(input!  - 5 + 5*log10(dist!))\(strExtra)"
        }
        
    }
    
    

}





class BinSysViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBOutlet var periodField: NSTextField!
    @IBOutlet var separationField: NSTextField!
    @IBOutlet var resultField: NSTextField!
    @IBOutlet var periodUnits: NSPopUpButton!
    @IBOutlet var separationUnits: NSPopUpButton!
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func calculate(_ sender: Any?) {
        var orbitalPeriodYears = 0.0
        switch periodUnits.indexOfSelectedItem {
        case 0:
            orbitalPeriodYears = Double(periodField.stringValue)!
        case 1:
            orbitalPeriodYears = Double(periodField.stringValue)!/365
        case 2:
            orbitalPeriodYears = Double(periodField.stringValue)!/365/24/60/60
        default:
            orbitalPeriodYears = Double(periodField.stringValue)!
        }
        
        var separationAU = 0.0
        switch separationUnits.indexOfSelectedItem {
        case 0:
            separationAU = Double(separationField.stringValue)!
        case 1:
            separationAU = Double(separationField.stringValue)!*63241.077088066
        case 2:
            separationAU = 1/(Double(separationField.stringValue)!/1000)*63241.077088066*3.261563
        default:
            separationAU = Double(separationField.stringValue)!
        }
        
        var mTot = separationAU*separationAU*separationAU/orbitalPeriodYears/orbitalPeriodYears
        
        resultField.stringValue = "Total mass is \(mTot) solar masses = \(mTot*1.9891e30) kg"
        
        
    }
    
    
    
    
    
    
    
}



class RRLyraeViewController: NSViewController {
    
    @IBOutlet var periodField: NSTextField!
    @IBOutlet var brightnessField: NSTextField!
    @IBOutlet var distanceField: NSTextField!
    
    @IBOutlet var periodUnit: NSPopUpButton!
    @IBOutlet var brightnessUnit: NSPopUpButton!
    @IBOutlet var distanceUnit: NSPopUpButton!
    
    @IBAction func calculatePeriod(_ sender: Any?) {
        let L0 = 3.0128e28 // W
        let Lsun = 3.9e26 // W
        
        
        var distance = 0.0
        if distanceField.stringValue == "" {
            var distTMP = Double(distanceField.stringValue)!
            switch brightnessUnit.indexOfSelectedItem {
            case 0:
                distance = distTMP
            case 1:
                distance = distTMP/3.261563
            case 2:
                distance = 1/(distTMP/1000)
            default:
                distance = distTMP
            }
        }
        
        
        var absmag = 0.0
        
        switch brightnessUnit.indexOfSelectedItem {
        case 0:
            //lum = L0 * pow(10, exp)
            absmag = log10(Double(brightnessField.stringValue)!*Lsun/L0)
        case 1:
            absmag = log10(Double(brightnessField.stringValue)!/L0)
        case 2:
            absmag = Double(brightnessField.stringValue)! + 5 - 5*log10(distance)
        case 3:
            absmag = Double(brightnessField.stringValue)!
        default:
            absmag = Double(brightnessField.stringValue)!
        }
        
        // M = −2.81 • log(P) − 1.43
        // (M+1.43)/(-2.81) = log(P)
        // P = 10^((M+1.43)/(-2.81))
        
        var periodDays = pow(10,(absmag + 1.43)/(-2.81))
        var periodPrint = 0.0
        switch periodUnit.indexOfSelectedItem {
        case 0:
            periodPrint = periodDays/365
        case 1:
            periodPrint = periodDays
        case 2:
            periodPrint = periodDays*24
        case 3:
            periodPrint = periodDays*3600*24
        default:
            periodPrint = periodDays
        }
        
        periodField.stringValue = "\(periodPrint)"
                
    }
    
    func calculatePeriodNONIB() -> Double {
        let L0 = 3.0128e28 // W
        let Lsun = 3.9e26 // W
        
        
        var distance = 0.0
        if distanceField.stringValue == "" {
            var distTMP = Double(distanceField.stringValue)!
            switch brightnessUnit.indexOfSelectedItem {
            case 0:
                distance = distTMP
            case 1:
                distance = distTMP/3.261563
            case 2:
                distance = 1/(distTMP/1000)
            default:
                distance = distTMP
            }
        }
        
        
        var absmag = 0.0
        
        switch brightnessUnit.indexOfSelectedItem {
        case 0:
            //lum = L0 * pow(10, exp)
            absmag = log10(Double(brightnessField.stringValue)!*Lsun/L0)
        case 1:
            absmag = log10(Double(brightnessField.stringValue)!/L0)
        case 2:
            absmag = Double(brightnessField.stringValue)! + 5 - 5*log10(distance)
        case 3:
            absmag = Double(brightnessField.stringValue)!
        default:
            absmag = Double(brightnessField.stringValue)!
        }
        
        // M = −2.81 • log(P) − 1.43
        // (M+1.43)/(-2.81) = log(P)
        // P = 10^((M+1.43)/(-2.81))
        
        var periodDays = pow(10,(absmag + 1.43)/(-2.81))
        var periodPrint = 0.0
        switch periodUnit.indexOfSelectedItem {
        case 0:
            periodPrint = periodDays/365
        case 1:
            periodPrint = periodDays
        case 2:
            periodPrint = periodDays*24
        case 3:
            periodPrint = periodDays*3600*24
        default:
            periodPrint = periodDays
        }
        
        periodField.stringValue = "\(periodPrint)"
        
        return periodDays
    }
    
    
    @IBAction func calculateBrightness(_ sender: Any?) {
        var periodDays = 0.0
        switch periodUnit.indexOfSelectedItem {
        case 0:
            periodDays = Double(periodField.stringValue)! * 365
        case 1:
            periodDays = Double(periodField.stringValue)!
        case 2:
            periodDays = Double(periodField.stringValue)! / 24
        case 3:
            periodDays = Double(periodField.stringValue)! / 3600 / 24
        default:
            periodDays = Double(periodField.stringValue)!
        }
        
        var Mag = -2.81 * log10(periodDays)-1.43
        
        var distance = 0.0
        if distanceField.stringValue == "" {
            var distTMP = Double(distanceField.stringValue)!
            switch brightnessUnit.indexOfSelectedItem {
            case 0:
                distance = distTMP
            case 1:
                distance = distTMP/3.261563
            case 2:
                distance = 1/(distTMP/1000)
            default:
                distance = distTMP
            }
        }
        
        
        var brightnessPrint = 0.0
        switch brightnessUnit.indexOfSelectedItem {
        case 3:
            brightnessPrint = Mag
        case 2:
            brightnessPrint = Mag - 5 + 5*log10(distance)
        case 0:
            let Lsun = 3.9e26 // W
            let L0 = 3.0128e28 // W
            let exp = -0.4*(Mag)
            let lum = L0 * pow(10, exp)
            brightnessPrint = lum / Lsun
        case 1:
            let Lsun = 3.9e26 // W
            let L0 = 3.0128e28 // W
            let exp = -0.4*(Mag)
            brightnessPrint = L0 * pow(10, exp)
        default:
            brightnessPrint = 0.0
        }
        
        brightnessField.stringValue = "\(brightnessPrint)"
    
        
    }
    
    func calculateBrightnessNONIB() -> Double {
        var periodDays = 0.0
        switch periodUnit.indexOfSelectedItem {
        case 0:
            periodDays = Double(periodField.stringValue)! * 365
        case 1:
            periodDays = Double(periodField.stringValue)!
        case 2:
            periodDays = Double(periodField.stringValue)! / 24
        case 3:
            periodDays = Double(periodField.stringValue)! / 24 / 3600
        default:
            periodDays = Double(periodField.stringValue)!
        }
        
        var Mag = -2.81 * log10(periodDays)-1.43
        print("Found absolute magnitude of \(Mag)")
        return Mag
    }
    
    
    @IBAction func calculateDistance(_ sender: Any?) {
        print("calculating distance")
        if(brightnessUnit.indexOfSelectedItem == 2) {
            var absmag = calculateBrightnessNONIB()
            var dist = pow(10,(Double(brightnessField.stringValue)!-absmag+5)/5)
            switch brightnessUnit.indexOfSelectedItem {
            case 0:
                distanceField.stringValue = "\(dist)"
            case 1:
                distanceField.stringValue = "\(dist*3.261563)"
            case 2:
                distanceField.stringValue = "\(1/dist * 1000)"
            default:
                distanceField.stringValue = "\(dist) pc"
            }
        }
        
        else {
            distanceField.stringValue = "NEED M_APP"
        }

    }
    
    
}
