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
        animateDeltaXYobject(layer: square.layer!,x: 50,y: 0, duration: 1)
    }
    @IBAction func animateSquareLeft(_ sender: Any) {
        //https://www.desmos.com/calculator/7fn9cakjzz?lang=fr for converting bezier to polynomial and back.
        var path: CGMutablePath = CGMutablePath()
        path.move(to: square.layer!.position)
        let iniCGPT = square.layer!.position
        let delta1 = [CGFloat(50),CGFloat(100)]
        let delta2 = [CGFloat(50),CGFloat(-100)]
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

