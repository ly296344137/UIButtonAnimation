//
//  LYCopyAliPayButton.swift
//  仿支付宝付款按钮
//
//  Created by Yoyo on 2018/4/20.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class LYCopyAliPayButton: UIButton, CAAnimationDelegate {
    
    init(frame: CGRect, backgroundColor: UIColor) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10.0
        self.backgroundColor = backgroundColor
        self.setTitle("立即付款", for: UIControlState.normal)
        self.setTitle("面容ID支付处理中", for: UIControlState.disabled)
        self.layer.cornerRadius = 10
        self.addTarget(self, action: #selector(payAction), for: UIControlEvents.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("")
    }
    
    @objc func payAction() {
        self.setNeedsDisplay()
        self.isEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        if !self.isEnabled {
            let frame = self.titleLabel!.frame
            let x = frame.origin.x-frame.size.height*1.3
            let y = frame.origin.y+frame.size.height/2
            let path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: frame.size.height*0.6, startAngle: -CGFloat.pi/2, endAngle:CGFloat.pi*2, clockwise: true)
            path.lineWidth = 2
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.white.cgColor
            layer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(layer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1.0
            animation.duration = 1.0
            animation.isRemovedOnCompletion = false
            animation.repeatCount = 10
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            layer.add(animation, forKey: "RotationAnimation")
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        for layer in self.layer.sublayers! {
            if layer.animationKeys()?.first == "RotationAnimation" {
                layer.removeFromSuperlayer()
            }
        }
        self.setTitle("支付成功", for: UIControlState.normal)
        self.isEnabled = true
    }
}


