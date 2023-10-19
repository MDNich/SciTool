//
//  ViewController.swift
//  AnimationTest
//
//  Created by Marc D. Nichitiu on 10/12/23.
//

import Cocoa
import AppKit
import CoreGraphics

class ViewController: NSViewController {

    @IBOutlet weak var square: NSImageView!
    @IBOutlet weak var squareRed: NSImageView!

    @IBOutlet weak var squareBlue: NSImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func animateDeltaXYobject(layer: CALayer, x: Float, y: Float,duration: Float) {
        let iniPos = layer.position
        let delta = [CGFloat(x),CGFloat(y)]
        let ini = [CGFloat(iniPos.x),CGFloat(iniPos.y)]
        let final = [ini[0] + delta[0], ini[1] + delta[1]]
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = ini
        animation.toValue = final
        animation.duration = CFTimeInterval(duration)
        layer.add(animation, forKey: "position")
        layer.position = CGPoint(x: final[0],y: final[1])
    }
    
    @IBAction func animateSquareRight(_ sender: Any) {
        //animateDeltaXYobject(layer: square.layer!,x: 50,y: 0, duration: 1)
        
        var path: CGMutablePath = CGMutablePath()
        path.move(to: square.layer!.position)
        let iniCGPT = square.layer!.position
        let delta1 = [CGFloat(-50),CGFloat(100)]
        let delta2 = [CGFloat(-50),CGFloat(-100)]
        let ini = [CGFloat(iniCGPT.x),CGFloat(iniCGPT.y)]
        let final1 = [ini[0] + delta1[0], ini[1] + delta1[1]]
        let final2 = [ini[0] + delta1[0] + delta2[0], ini[1] + delta1[1] + delta2[1]]
        
        path.addQuadCurve(to: CGPoint(x: final2[0], y: final2[1]), control: CGPoint(x: final1[0], y: final1[1]))
       
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = CFTimeInterval(1)
        square.layer!.add(animation, forKey: "position")
        square.layer!.position = CGPoint(x: final2[0],y: final2[1])
        squareRed.layer!.position = CGPoint(x:final1[0],y:final1[1])
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
        let controlPt = CGPoint(x: midPtx, y: -startPt.y-derivAtMidPt*midPtx)
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
