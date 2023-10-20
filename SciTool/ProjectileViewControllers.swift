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
    
    @IBOutlet weak var square: NSImageView!
    @IBOutlet weak var squareRed: NSImageView!

    @IBOutlet weak var squareBlue: NSImageView!
    
    var launchParams: [Double] = []
    
    
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
        launchParams = [iniVelVal,iniAngVal,deltaHVal]
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
    
    
    @IBOutlet weak var ball: NSImageView!
    
    
    @IBOutlet weak var platformL: NSTextField!
    
    @IBOutlet weak var platformR: NSTextField!
    
    func getPlatformDist() -> Double {
        let xL = platformL.layer!.position.x
        let xR = platformR.layer!.position.x
        return Double(xR-xL)
    }
    
    @IBAction func animateBall(_ sender: Any) {
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
        launchParams = [iniVelVal,iniAngVal,deltaHVal]
        if((totalT.isNaN) || (Int(iniAngVal*180/Double.pi) == 90)) {
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
        
        
        // x = x0 + v0x*t
        // y = y0 + v0y*t - gt^2/2
        // y = x\cdot\tan\theta - \frac{g}{2v0*\cos\theta*\cos\theta}*x*x
        //
        let quadPolyToDraw = QuadraticPolynomial(-g/(2*iniVelVal*cos(iniAngVal)*cos(iniAngVal)),tan(iniAngVal),0)
        var points = convertQuadToBezier(quadPolyToDraw,0,totalX)
        let scaleFactor = getPlatformDist() / totalX
        let shiftX = Double(platformL.layer!.position.x)
        let shiftY = Double(platformR.layer!.position.y)
        
        
        ball.layer!.bounds = CGRect(x: ball.layer!.bounds.minX, y: ball.layer!.bounds.minY, width: ball.layer!.bounds.width*scaleFactor*10, height: ball.layer!.bounds.height*scaleFactor*10)

        
        for i in 0...2 {
            print("Point before transform: \(points[i])")
            points[i] = CGPoint(x: CGFloat(scaleFactor) * (points[i].x) + CGFloat(shiftX), y: CGFloat(scaleFactor) * (points[i].y) + CGFloat(shiftY))
            print("Point after transform: \(points[i])")
        }
        points[2] = platformR.layer!.position
        
        var path: CGMutablePath = CGMutablePath()
        path.move(to: platformL.layer!.position)
        let ini = points[0]
        let ctrlPt = points[1]
        let final = points[2]
        print("ini : \(ini)")
        print("ctrl : \(ctrlPt)")
        print("fin : \(final)")
        
        path.addQuadCurve(to: platformR.layer!.position, control: ctrlPt)
        print("Will follow path \(path)")
        
       
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = CFTimeInterval(1.5)
        ball.layer!.add(animation, forKey: "position")
        ball.layer!.position = platformR.layer!.position
        
        
        
    }
    
    
    
    @IBAction func resetSquares(_ sender: Any) {
        square.layer!.position = CGPoint(x: 100,y: 100)
        squareRed.layer!.position = CGPoint(x: 200,y: 100)
        squareBlue.layer!.position = CGPoint(x:0,y:100)

    }
    @IBAction func printSquarePos(_ sender: Any) {
        print("Y: \(square.layer!.position)")
        print("R: \(squareRed.layer!.position)")
        print("B: \(squareBlue.layer!.position)")
    }
    
    @IBAction func animateSquareLeft(_ sender: Any) {
        //https://www.desmos.com/calculator/7fn9cakjzz?lang=fr for converting bezier to polynomial and back.
        // https://math.stackexchange.com/questions/335226/convert-segment-of-parabola-to-quadratic-bezier-curve
        
        let quadPolyToDraw = QuadraticPolynomial(1,0,0)
        var points = convertQuadToBezier(quadPolyToDraw,-3,3)
        let iniCGPT = square.layer!.position
        print("Found initial square position \(iniCGPT)")
        let scaleX = 10
        let scaleY = 1
        let shiftX = iniCGPT.x - points[0].x*CGFloat(scaleX)
        let shiftY = iniCGPT.y - points[0].y*CGFloat(scaleY)
        for i in 0...2 {
            print("Point before transform: \(points[i])")
            points[i] = CGPoint(x: CGFloat(scaleX) * (points[i].x) + CGFloat(shiftX), y: CGFloat(scaleY) * (points[i].y) + CGFloat(shiftY))
            print("Point after transform: \(points[i])")
        }
        
        
        var path: CGMutablePath = CGMutablePath()
        path.move(to: iniCGPT)
        let ini = points[0]
        let ctrlPt = points[1]
        let final = points[2]
        print("ini : \(ini)")
        print("ctrl : \(ctrlPt)")
        print("fin : \(final)")
        
        path.addQuadCurve(to: final, control: ctrlPt)
        print("Will follow path \(path)")
        
       
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = CFTimeInterval(1)
        square.layer!.add(animation, forKey: "position")
        square.layer!.position = final
        squareRed.layer!.position = ctrlPt
        squareBlue.layer!.position = iniCGPT
        //squareRed.layer!.position = ctrlPt
//
//
//        let dt = Float(1.0/11.0)
//        let xT = linspace(0,10,11)
//        var yT = linspace(0,5,6)
//        let yT2 = linspace(5,1,5)
//        yT.append(contentsOf: yT2)
//        for i in 0...10 {
//            print(i)
//            animateDeltaXYobject(layer: square.layer!, x: xT[i], y: yT[i], duration: dt)
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(dt)), execute: {
//                print("done")
//            })
//        }
    }
    
    
    func convertPolynomialDeg2ToBezier(a: Double,b: Double,c: Double,minX: Double, maxX: Double) -> [CGPoint] {
        let startPt =  CGPoint(x: minX, y: quadratic(a,b,c,minX))
        let endPt = CGPoint(x: maxX,y:quadratic(a,b,c,maxX))
        let midPtx = (minX+maxX)/2
        let derivAtMidPt = 2*a*minX+b
        let controlPt = CGPoint(x: midPtx, y: startPt.y+derivAtMidPt*midPtx)
        print("From quadratic (\(a))x^2 + (\(b))x + (\(c)) on interval (\(minX),\(maxX)) we obtain Bézier curve")
        print("with points \(startPt), \(controlPt), \(endPt)")
        return [startPt,controlPt,endPt]
    }
    
    func convertQuadToBezier(_ poly: QuadraticPolynomial,_ minX: Double, _ maxX: Double) -> [CGPoint] {
        return convertPolynomialDeg2ToBezier(a: poly.a, b: poly.b, c: poly.c, minX: minX, maxX: maxX)
    }
    
    func quadratic(_ a: Double,_ b: Double,_ c: Double,_ x: Double) -> Double {
        return x*x*a+x*b+c
    }
    
    
    
    /*func quadraticArr(a: Float, b: Float, c: Float,xs: [Float]) -> [Float] {
        let xstar = SIMD64<Float>(xs)
        let x2star = xstar &* xstar
        let resultA = a * x2star
        let resultB = b * xstar
        let resultC = c*SIMD64<Float>(Array(repeating: 0, count: xs.count))
    }*/
 
    func linspace(_ start: Float,_ end: Float,_ numPts: Int) -> [Float] {
        let interval = (end-start)/(Float(numPts-1))
        var arr: [Float] = []
        for i in 0...numPts-1 {
            let next = start + interval*Float(i)
            arr.append(next)
        }
        return arr
    }
    
    
    
}

class QuadraticPolynomial {
    var a: Double = 0
    var b: Double = 0
    var c: Double = 0
    
    init(_ a: Double, _ b: Double, _ c: Double) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    func getCoeffs() -> [Double] {
        return [a,b,c]
    }
    func eval(_ x: Double) -> Double {
        return a*x*x+b*x + c
    }
    func evalDeriv(_ x: Double) -> Double {
        return 2*a*x+b
    }
    func integralFromTo(_ xi: Double, _ xf: Double) -> Double {
        return a/3*(xf*xf*xf - xi*xi*xi) + b/2 * (xf*xf-xi*xi) + c*(xf-xi)
    }
}

