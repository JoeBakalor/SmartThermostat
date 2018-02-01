//
//  ThermostatMainViewController.swift
//  BLUHome
//
//  Created by Joe Bakalor on 4/7/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import UIKit

class ThermostatMainViewController: UIViewController
{
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    @IBOutlet weak var twoPiView: UIView!
    @IBOutlet weak var twoPiLabel: UILabel!
    
    @IBOutlet weak var piOver6View: UIView!
    @IBOutlet weak var piOver6Label: UILabel!
    
    @IBOutlet weak var piOver3View: UIView!
    @IBOutlet weak var piOver3Label: UILabel!
    
    @IBOutlet weak var piOver2View: UIView!
    @IBOutlet weak var piOver2Label: UILabel!
    
    @IBOutlet weak var twoPiOver3View: UIView!
    @IBOutlet weak var twoPiOver3Label: UILabel!
    
    @IBOutlet weak var fivePiOver6View: UIView!
    @IBOutlet weak var fivePiOver6Label: UILabel!
    
    @IBOutlet weak var piView: UIView!
    @IBOutlet weak var piLabel: UILabel!
    
    @IBOutlet weak var sevenPiOver6View: UIView!
    @IBOutlet weak var sevenPiOver6Label: UILabel!
    
    @IBOutlet weak var fourPiOver3View: UIView!
    @IBOutlet weak var fourPiOver3Label: UILabel!
    
    @IBOutlet weak var threePiOver2View: UIView!
    @IBOutlet weak var threePiOver2Label: UILabel!
    
    @IBOutlet weak var fivePiOver3View: UIView!
    @IBOutlet weak var fivePiOver3Label: UILabel!
    
    @IBOutlet weak var elevenPiOver6View: UIView!
    @IBOutlet weak var elevenPiOver6Label: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var baseLayerView: UIImageView!
    
    @IBOutlet weak var climateControlView: UIView!
    @IBOutlet weak var fanControlView: UIView!
    /*============================================================================*/
    var timeStampLastAngle: Date?
    var lastAngleChange: CGFloat?
    var slowDownTimer: Timer?
    var initialAngularRate: CGFloat = 0
    var orderArrayInicator: Double = 0
    
    var xCenter: CGFloat?
    var yCenter: CGFloat?
    
    var xStartTouch: CGFloat?
    var yStartTouch: CGFloat?

    var initialAngle: Double = Double.pi/2
    
    var baseAngle: CGFloat?
    var nextAngle: CGFloat?
    
    var temperatureViewArray: [UIView]? //= [twoPiView, piOver6View, piOver3View]
    var temperatureViewArrayLabelOrdered: [UILabel]?
    var temperatureLabelArray: [UILabel]?
    
    var rotationVectorMagnitude: Double?
    var slowDownVelocity: CGFloat?
    var incrmineter = 100
    
    var decayValue: CGFloat = 0
    let decayTime: TimeInterval = 0.5
    var touchUpTimeStamp: Date?
    var decayConstant: Double?
    
    var weAreSlowingDown: Bool = false
    let temperatureSettingValues = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, /**/ 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73,/**/ 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85/**/]
    var currentTempValues = [0]
    var startValues = Array(50...61)
    var thermostatInstance: Thermostat?
    
    var animationController: RotationAnimations?
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // init classes
        thermostatInstance = Thermostat()
        
        
        xCenter = baseLayerView.frame.midX
        yCenter = baseLayerView.frame.midY
        
        
        print("Center = (\(xCenter!),\(yCenter!))")
        
        temperatureViewArray = [twoPiView, piOver6View, piOver3View, piOver2View, twoPiOver3View, fivePiOver6View, piView, sevenPiOver6View, fourPiOver3View, threePiOver2View, fivePiOver3View, elevenPiOver6View]
        
        currentTempValues = Array(60...71)
        
        temperatureLabelArray = [twoPiLabel, piOver6Label, piOver3Label, piOver2Label, twoPiOver3Label, fivePiOver6Label, piLabel, sevenPiOver6Label, fourPiOver3Label, threePiOver2Label, fivePiOver3Label, elevenPiOver6Label]

        rotationVectorMagnitude = (Double(baseLayerView.frame.height/CGFloat(2)) * 0.77)

        animationController = RotationAnimations(arrayOfViews: temperatureViewArray!, unitVectorSize: CGFloat(rotationVectorMagnitude!), center: CGPoint(x: xCenter!, y: yCenter!))
        
        initTemperatureValueViews(rotateByAngle: Double(initialAngle))
        

        for i in 0...11{
            initTemperatureValueViews(rotateByAngle: -Double.pi/6)
        }
        for i in 0...11{
            initTemperatureValueViews(rotateByAngle: Double.pi/6)
        }
        setupUI()
        
    }
    func setupUI()
    {
        climateControlView.layer.borderColor = UIColor.black.cgColor
        climateControlView.layer.borderWidth = 1
        
        
        fanControlView.layer.borderWidth = 1
        fanControlView.layer.borderColor = UIColor.black.cgColor
    }
    //*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func initTemperatureValueViews(rotateByAngle angle: Double)
    {
        
        let angleIncrement = Double.pi/6
        var i: Double = 0
        
        for value in temperatureViewArray!{
            
            value.translatesAutoresizingMaskIntoConstraints = true
            
            value.layer.position.y = CGFloat(sin(initialAngle + i * angleIncrement + angle) * rotationVectorMagnitude!) + yCenter!
            value.layer.position.x = CGFloat(cos(initialAngle + i * angleIncrement + angle) * rotationVectorMagnitude!) + xCenter!
            value.alpha =  abs(CGFloat(cos((( initialAngle + i * angleIncrement + angle + Double.pi/2) / 2)))) - 0.15
            i += 1
            
        }
        
        initialAngle += angle
        timeStampLastAngle = Date()
        print("Current angle = \(initialAngle * 180/Double.pi)")

        
        orderArrayInicator += angle
        //rotating forward, rotate array forward or reverse adding new value to front for forward and back for reverse
        if orderArrayInicator >= Double.pi/12 {
            
            print("shift last to first")
            
            orderArrayInicator -= Double.pi/6
            
            let replacementElement = temperatureLabelArray?.removeLast()
            temperatureLabelArray?.insert(replacementElement!, at: 0)
            
            currentTempValues.removeLast()
            currentTempValues.insert(currentTempValues.first! - 1, at: 0)
            
            temperatureLabelArray?.first?.text = "\(currentTempValues.first!)"
            
            print("\(currentTempValues)")
            
        }else if orderArrayInicator <= -Double.pi/12{ //rotating backward
            
            print("shift first to last")
            
            orderArrayInicator += Double.pi/6
            
            let replaceElement = temperatureLabelArray?.removeFirst()
            temperatureLabelArray?.append(replaceElement!)
            
            currentTempValues.removeFirst()
            currentTempValues.append(currentTempValues.last! + 1)
            
            temperatureLabelArray?.last?.text = "\(currentTempValues.last!)"
            
            print("\(currentTempValues)")
        }
        
        print("current Temp values = \(currentTempValues)")
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        temperatureLabelArray![6].font = UIFont(name: temperatureLabelArray![6].font.fontName, size: 40)
        
        let touchPoint = touches.first?.location(in: self.view)
        xStartTouch = touchPoint!.x - xCenter!
        yStartTouch = touchPoint!.y -  yCenter!
        baseAngle = atan(yStartTouch!/xStartTouch!)
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let newTouchPoint = touches.first?.location(in: self.view)
        let xNewTouch = newTouchPoint!.x - xCenter!
        let yNewTouch = newTouchPoint!.y -  yCenter!
        
        nextAngle = (atan(yNewTouch/xNewTouch))
        
        if baseAngle! < CGFloat(0) && nextAngle! > CGFloat(0) || nextAngle! < CGFloat(0) && baseAngle! > CGFloat(0){
            
            lastAngleChange = baseAngle! + nextAngle!
            initTemperatureValueViews(rotateByAngle: Double(baseAngle! + nextAngle!))
            
        }else{
            
            lastAngleChange = baseAngle! - nextAngle!
            initTemperatureValueViews(rotateByAngle: Double(nextAngle! - baseAngle!))
            
        }
        baseAngle = nextAngle
        
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let timeDifToLastAngle = Date().timeIntervalSince(timeStampLastAngle!)
        let angleRateToUse = lastAngleChange!/CGFloat(timeDifToLastAngle)//in radians per second
        
        slowDownVelocity = angleRateToUse
        touchUpTimeStamp =  Date()
        initialAngularRate = angleRateToUse/2
        decayConstant = abs(Double(10/(Double(angleRateToUse)*decayTime)))
        
        if initialAngularRate > 10{
            
            initialAngularRate = 10
            
        }else if initialAngularRate < -10{
            
            initialAngularRate = -10
            
        }
        weAreSlowingDown = true
        slowDownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.slowRotationToStop), userInfo: nil, repeats: false)
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func slowRotationToStop()
    {
        //motion should decay to 0 in specified decayTime
        var shiftTemp: Double = 0
        print("Initial Angular Rate = \(initialAngularRate)")
        shiftTemp = Double(initialAngularRate) * pow(M_E, ((Date().timeIntervalSince(touchUpTimeStamp!) * (-1)*12)))
        
        print("Move temp by \(shiftTemp)")
        
        if initialAngularRate > 0{
            
            if shiftTemp >= 0.01{
                
                initTemperatureValueViews(rotateByAngle: Double(-shiftTemp * 0.01))
                slowDownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.slowRotationToStop), userInfo: nil, repeats: false)
                
            }else{
                
                weAreSlowingDown = false
                initialAngularRate = 0
                slowDownTimer?.invalidate()
                finish()
            }
            
        }else if initialAngularRate < 0{
            
            if shiftTemp <= -0.01{
                
                initTemperatureValueViews(rotateByAngle: Double(-shiftTemp * 0.01))
                slowDownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.slowRotationToStop), userInfo: nil, repeats: false)
                
            }else{
                
                weAreSlowingDown = false
                initialAngularRate = 0
                slowDownTimer?.invalidate()
                finish()
            }
            
        }else{
            
            weAreSlowingDown = false
            print("Angular rate was zero so do nothing")
            finish()
        }
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func finish()
    {
        let xTest = piOver2View.layer.position.x - xCenter!
        let yTest = piOver2View.layer.position.y - yCenter!
        let restingAngleRemainder = (atan(yTest/xTest)).truncatingRemainder(dividingBy: CGFloat(Double.pi/6))
        
        //print("xTest = \(xTest) yTest = \(yTest)")
        
        if (xTest > 0 && yTest > 0) || (xTest < 0 && yTest < 0){
            
            //print("First Quadrant or third quadrant")
            if restingAngleRemainder > CGFloat(Double.pi/12){
                
                //print("Angle greater")
                initTemperatureValueViews(rotateByAngle: Double(CGFloat(Double.pi/6) - restingAngleRemainder))
                
            }else{
                
                //print("Angle less")
                initTemperatureValueViews(rotateByAngle: Double(-restingAngleRemainder))
            }
            
        }else if (xTest < 0 && yTest > 0) || (xTest > 0 && yTest < 0){
            
            //print("Second Quadrant or fourth quadrant")
            if restingAngleRemainder < CGFloat(-Double.pi/12){
                
                //print("Angle greater")
                initTemperatureValueViews(rotateByAngle: Double((-1) * (CGFloat(Double.pi/6) + restingAngleRemainder)))
                
            }else{
                
                //print("Angle less")
                initTemperatureValueViews(rotateByAngle: Double(-restingAngleRemainder))
            }
            
        }else{
            
            //print("this should never be called")
        }
        
        print("value selected = \(currentTempValues[6])")
        thermostatInstance?.thermostatState?.desiredTemeprature = currentTempValues[6]
        
        temperatureLabelArray![6].font = UIFont(name: temperatureLabelArray![6].font.fontName, size: 50)
        //temperatureLabelArray![6].layer.frame.size.width = 100
        //temperatureLabelArray![6].layer.frame.size.height = 100
        updateBaseLayer()
        slowDownVelocity = 0
        //touchUpTimeStamp =  nil
        initialAngularRate = 0
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func updateBaseLayer()
    {
        
        if (thermostatInstance?.thermostatState?.desiredTemeprature)! > Int(currentTemperatureLabel.text!)!{
            
            print("turn on the heat")
            //baseLayerView.image = #imageLiteral(resourceName: "BaseLayerBlank.png")
            let newImage = UIImage(named:"BaseLayerHot.png")
            UIView.transition(with: self.baseLayerView, duration: 1.5, options: .transitionCrossDissolve, animations:{self.baseLayerView.image = newImage}, completion: nil)
            
        }else if (thermostatInstance?.thermostatState?.desiredTemeprature)! < Int(currentTemperatureLabel.text!)!{
        
            print("turn on the AC")
            //baseLayerView.image = #imageLiteral(resourceName: "BaseLayerBlank.png")
            let newImage = UIImage(named:"BaseLayer.png")
            UIView.transition(with: self.baseLayerView, duration: 1.5, options: .transitionCrossDissolve, animations:{self.baseLayerView.image = newImage}, completion: nil)
        }
        
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func updateTemperatureViewArrayPositions()
    {
        
    }
    /*============================================================================*/
}


