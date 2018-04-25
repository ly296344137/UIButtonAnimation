//
//  LYWaveTouchButton.swift
//  点击Button水波纹效果
//
//  Created by Yoyo on 2018/4/19.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class LYWaveTouchButton: UIButton {
    var animationDuration = 1.0
    var hightLightColor: UIColor = UIColor.clear
    var loopCount: Int {
        return Int(animationDuration / 0.02)
    }
    var circles = [Int: LYButtonCircle]()
    var circleFlag: Int = 0
    
    //重写
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.touchedDown(sender:events:)), for: UIControlEvents.touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("")
    }
    
    @objc func touchedDown(sender: LYWaveTouchButton, events: UIEvent) {
        let touch = events.touches(for: sender)?.first
        let point = touch?.location(in: sender)//以button为坐标系
        
        let buttonCircle: LYButtonCircle = LYButtonCircle()//点击事件类
        buttonCircle.circleCenterX = (point?.x)!//圆心
        buttonCircle.circleCenterY = (point?.y)!
        buttonCircle.circleRait = 0.0//初始半径
        //以button中点为基准，判断最大半径值
        let maxX = point!.x > (self.frame.size.width - point!.x) ? point!.x : (self.frame.size.width - point!.x)
        let maxY = point!.y > (self.frame.size.height - point!.y) ? point!.y : (self.frame.size.height - point!.y)
        buttonCircle.circleWidth = maxX > maxY ? maxX : maxY
        circles[circleFlag] = buttonCircle
        
        //为每个点击事件增加一个定时器,每隔0.01s画一个半径不断增大的圆
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(self.timerFunction(timer:)), userInfo: circleFlag, repeats: true)
        
        circleFlag += 1
    }
    
    @objc func timerFunction(timer: Timer) {
        self.setNeedsDisplay()//会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了
        let index:Int = timer.userInfo! as! Int
        let buttonCircle: LYButtonCircle = circles[index]!
        //circleRait：半径缩放系数，circleRait若等于1则圆达到最大半径，字典中删除点击事件，结束定时任务
        if buttonCircle.circleRait <= 1 {
            buttonCircle.circleRait += 1.0/CGFloat(self.loopCount)
        } else {
            circles.removeValue(forKey: index)
            timer.invalidate()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let endAngel = CGFloat(Double.pi * 2)
        for buttonCircle: LYButtonCircle in circles.values {
            //画圆
            context.addArc(center: CGPoint(x: buttonCircle.circleCenterX, y: buttonCircle.circleCenterY), radius: buttonCircle.circleRait*buttonCircle.circleWidth, startAngle:0, endAngle: endAngel, clockwise: false)
            self.hightLightColor.withAlphaComponent(1-buttonCircle.circleRait).setStroke()
            self.hightLightColor.withAlphaComponent(1-buttonCircle.circleRait).setFill()
            context.fillPath()
        }
    }
}

class LYButtonCircle: NSObject {
    var circleCenterX: CGFloat = 0.0
    var circleCenterY: CGFloat = 0.0
    var circleWidth: CGFloat = 0.0
    var circleRait: CGFloat = 0.0
}
