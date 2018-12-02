//  Created by Mitch Larson on 11/30/18.
//  Copyright © 2018 Mitch Larson. All rights reserved.
//  Template made by Satraj Bambra on 2015-03-20.
//  Updated and Modified by Mitch Larson

import UIKit

//protocal for going back to the view controller
protocol HolderViewDelegate:class {
  func animateTable()
}

class HolderView: UIView {
    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    let redRectangleLayer = RectangleLayer()
    let blueRectangleLayer = RectangleLayer()
    let arcLayer = ArcLayer()

    //frame set by template, for adding and removing stuff of the animation
  var parentFrame :CGRect = CGRect.zero
  weak var delegate:HolderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.clear
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
  }
    
    //First set, adding the circle at the beginning
    func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HolderView.wobbleOval),
                                               userInfo: nil, repeats: false)
    }
    
    //gives the Oval a 'buzz' to it
    //Calls the Triange after
    @objc func wobbleOval() {
        layer.addSublayer(triangleLayer) // Add this line
        ovalLayer.wobble()
        
        Timer.scheduledTimer(timeInterval: 0.9, target: self,
                             selector: #selector(HolderView.drawAnimatedTriangle), userInfo: nil,
                                               repeats: false)
    }
    
    //Forming the triangle
    //Also calls the spin and Transform after
    @objc func drawAnimatedTriangle() {
        triangleLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.spinAndTransform),
                                               userInfo: nil, repeats: false)
    }
    
    //Spins the Triangle calls the Rectangle after
    @objc func spinAndTransform() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(.pi * 2.0)
        rotationAnimation.duration = 0.45
        rotationAnimation.isRemovedOnCompletion = true
        layer.add(rotationAnimation, forKey: nil)
        
        
        ovalLayer.contract()
        
        Timer.scheduledTimer(timeInterval: 0.45, target: self,
                             selector: #selector(HolderView.drawRedAnimatedRectangle),
                                               userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 0.65, target: self,
                             selector: #selector(HolderView.drawBlueAnimatedRectangle),
                                               userInfo: nil, repeats: false)
    }
    
    //Draws the red rectangle
    @objc func drawRedAnimatedRectangle() {
        layer.addSublayer(redRectangleLayer)
        redRectangleLayer.animateStrokeWithColor(color: Colors.red)
    }
    
    //Draws the blue rectangle
    @objc func drawBlueAnimatedRectangle() {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(color: Colors.blue)
        Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(HolderView.drawArc),
                                               userInfo: nil, repeats: false)
    }
    
    //Does the filling of the rectangle
    @objc func drawArc() {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(HolderView.addLabel),
                                               userInfo: nil, repeats: false)
    }
    
    
    //called last, which calls the delegate
    @objc func addLabel() {
        delegate?.animateTable()
    }
}
