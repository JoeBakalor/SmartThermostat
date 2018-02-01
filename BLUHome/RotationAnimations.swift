//
//  RotationAnimations.swift
//  BLUHome
//
//  Created by Joe Bakalor on 4/11/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import Foundation
import UIKit

class RotationAnimations: NSObject
{
    /*============================================================================*/
    //Variables
    /*============================================================================*/
    var xCenter: CGFloat?
    var yCenter: CGFloat?
    var centerPoint: CGPoint?
    
    var unitVectorMagnitude: Double?
    var rotationVectorMagnitude: CGFloat?
    
    var initialAngle: Double = Double.pi/2
    
    var xStartTouch: CGFloat?
    var yStartTouch: CGFloat?
    
    var baseAngle: CGFloat?
    var timeStampLastAngle: Date?
    
    var labelArray: [UILabel]?
    var viewArray: [UIView]?
    
    //state variables
    var slowingDown = false
    var orderArrayInicator: Double = 0
    var initialAngularRate = 0
    var currentValueSet: [Int]?
    
    var angularRateDecayTimer: Timer?
    var startAngularRateDecay: Date?
    
    //constants
    let decayConstant: Double = 12
    /*============================================================================*/
    // Provide view array
    /*============================================================================*/
    init(arrayOfViews: [UIView], unitVectorSize: CGFloat, center: CGPoint)
    {
        viewArray = arrayOfViews
        rotationVectorMagnitude = unitVectorSize
        centerPoint = center
    }
    /*============================================================================*/
    // Rotate array of views byAngle provided in radians
    /*============================================================================*/
    func rotate(byAngle angle: Double)
    {
        let angleIncrement = Double.pi/6
        var i: Double = 0
        
        for view in viewArray!{
            
            view.layer.position.y = CGFloat(sin(initialAngle + i * angleIncrement + angle)) * (rotationVectorMagnitude!) + yCenter!
            view.layer.position.x = CGFloat(cos(initialAngle + i * angleIncrement + angle)) * (rotationVectorMagnitude!) + xCenter!
            let angle = cos((( initialAngle + i * angleIncrement + angle + Double.pi/2) / 2))
            view.alpha = abs(CGFloat(angle)) - 0.2

            i += 1
        }
        
        initialAngle += angle
        timeStampLastAngle = Date()
        
        orderArrayInicator += angle
        reOrderValueSetAndLabelArray()
    
        print("current Temp values = \(currentValueSet)")
    }
    /*============================================================================*/
    //rotating forward, rotate array forward or reverse adding new value to front for forward and back for reverse
    func reOrderValueSetAndLabelArray()
    {
        
        if orderArrayInicator >= Double.pi/12 {
            
            print("shift last to first")
            
            orderArrayInicator -= Double.pi/6
            
            let replacementElement = labelArray!.removeLast()
            labelArray!.insert(replacementElement, at: 0)
            
            currentValueSet!.removeLast()
            currentValueSet!.insert(currentValueSet!.first! - 1, at: 0)
            
            labelArray!.first!.text = "\(currentValueSet!.first!)"
            
            print("\(currentValueSet!)")
            
        }else if orderArrayInicator <= -Double.pi/12{ //rotating backward
            
            print("shift first to last")
            
            orderArrayInicator += Double.pi/6
            
            let replaceElement = labelArray?.removeFirst()
            labelArray?.append(replaceElement!)
            
            currentValueSet!.removeFirst()
            currentValueSet!.append(currentValueSet!.last! + 1)
            
            labelArray!.last!.text = "\(currentValueSet!.last!)"
            
            print("\(currentValueSet!)")
        }
    }
    /*============================================================================*/
    func setStartPointForRotation(xStartPoint: CGFloat, yStartPoint: CGFloat, startAngle: CGFloat)
    {
        xStartTouch = xStartPoint
        yStartTouch = yStartPoint
        baseAngle = startAngle
    }
    /*============================================================================*/
    func slowRotationToStop()
    {
        
    }
    /*============================================================================*/
    func touchesFinisedWith()
    {
        
    }
    /*============================================================================*/
    func decayRotationalVelocityToStop()
    {
        //motion should decay to 0 in specified decayTime
        var shiftViewArray: Double = 0
        print("Initial Angular Rate = \(initialAngularRate)")
        shiftViewArray = Double(initialAngularRate) * pow(M_E, ((Date().timeIntervalSince(startAngularRateDecay!) * (-1)*decayConstant)))
        
        print("Move temp by \(shiftViewArray)")
        
        if initialAngularRate > 0{
            
            if shiftViewArray >= 0.01{
                
                //initTemperatureValueViews(rotateByAngle: Double(-shiftTemp * 0.01))
                angularRateDecayTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.slowRotationToStop), userInfo: nil, repeats: false)
                
            }else{
                
                slowingDown = false
                initialAngularRate = 0
                angularRateDecayTimer?.invalidate()
                finishUp()
            }
            
        }else if initialAngularRate < 0{
            
            if shiftViewArray <= -0.01{
                
                //initTemperatureValueViews(rotateByAngle: Double(-shiftTemp * 0.01))
                angularRateDecayTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.slowRotationToStop), userInfo: nil, repeats: false)
                
            }else{
                
                slowingDown = false
                initialAngularRate = 0
                angularRateDecayTimer?.invalidate()
                finishUp()
            }
            
        }else{
            
            slowingDown = false
            print("Angular rate was zero so do nothing")
            finishUp()
        }
    }
    /*============================================================================*/
    func finishUp()
    {
        
    }
    /*============================================================================*/
}
