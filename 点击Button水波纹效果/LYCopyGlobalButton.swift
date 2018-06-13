//
//  LYCopyGlobalButton.swift
//  点击Button水波纹效果
//
//  Created by Yoyo on 2018/4/26.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class LYCopyGlobalButton: UIView {
    static let ButtonSize: CGFloat = 60
    static let SubButtonsViewSize: CGFloat = 300
    var appWindow = UIWindow()//window
    let markView = UIButton(type: UIButtonType.custom)//黑色遮罩
    var superFrame = CGRect()//上级view的frame
    var hasSelected = false//是否展开
    var subButtonsView = UIButton(type: UIButtonType.custom)//展开的view
    var subButtonSize = CGSize()//展开页面里的button尺寸
    
    init(frame: CGRect, viewFrame: CGRect) {
        var f = frame
        f.size.width = LYCopyGlobalButton.ButtonSize
        f.size.height = LYCopyGlobalButton.ButtonSize
        f.origin.x = frame.origin.x > viewFrame.size.width-frame.origin.x ? viewFrame.size.width-10-LYCopyGlobalButton.ButtonSize : 10
        super.init(frame: f)
        
        superFrame = viewFrame

        setupButton()
        self.backgroundColor = UIColor.clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
        self.isUserInteractionEnabled = true
        
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(showSubButtons))
        tagGesture.numberOfTapsRequired = 1
        
        panGesture.require(toFail: tagGesture)
        tagGesture.require(toFail: panGesture)
        
        self.addGestureRecognizer(tagGesture)
        self.addGestureRecognizer(panGesture)
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appWindow = appDelegate.window!
        
        markView.frame = CGRect(x: 0, y: 0, width: appWindow.frame.size.width, height: appWindow.frame.size.height)
        markView.alpha = 0
        markView.backgroundColor = UIColor(white: 0, alpha: 0)
        markView.addTarget(self, action: #selector(showSelf), for: UIControlEvents.touchUpInside)
        
        subButtonsView.frame = CGRect(x: 0, y: 0, width: LYCopyGlobalButton.SubButtonsViewSize, height: LYCopyGlobalButton.SubButtonsViewSize)
        subButtonsView.layer.cornerRadius = 30
        subButtonsView.layer.backgroundColor = UIColor(white: 0, alpha: 0.85).cgColor
        subButtonsView.addTarget(self, action: #selector(showSelf), for: UIControlEvents.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLaye(path: UIBezierPath, white: Float, alpha: Float) {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor(white: CGFloat(white), alpha: CGFloat(alpha)).cgColor
        layer.strokeColor = UIColor(white: CGFloat(white), alpha: CGFloat(alpha)).cgColor
        self.layer.addSublayer(layer)
    }
    
    func setupButton() {
        let centerP = CGPoint(x:frame.size.width/2, y:frame.size.height/2)
        var path = UIBezierPath()
        path.addArc(withCenter: centerP, radius: LYCopyGlobalButton.ButtonSize/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        setupLaye(path: path, white: 0, alpha: 0.85)
        
        path = UIBezierPath()
        path.addArc(withCenter: centerP, radius: LYCopyGlobalButton.ButtonSize/2.7, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        setupLaye(path: path, white: 1, alpha: 0.2)
        
        path = UIBezierPath()
        path.addArc(withCenter: centerP, radius: LYCopyGlobalButton.ButtonSize/3.4, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        setupLaye(path: path, white: 1, alpha: 0.3)
        
        path = UIBezierPath()
        path.addArc(withCenter: centerP, radius: LYCopyGlobalButton.ButtonSize/4.8, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        setupLaye(path: path, white: 1, alpha: 1)
    }
    
    //拖拽
    @objc func panGestureAction(pan: UIPanGestureRecognizer) {
        if hasSelected {
            return
        }
        switch pan.state {
        case UIGestureRecognizerState.began:
            self.superview?.bringSubview(toFront: self)
            break
        case UIGestureRecognizerState.changed:
            let point = pan.translation(in: self)
            let f = self.frame
            let dx = point.x + f.origin.x
            let dy = point.y + f.origin.y
            self.frame = CGRect(x: dx, y: dy, width: LYCopyGlobalButton.ButtonSize, height: LYCopyGlobalButton.ButtonSize)
            //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint(x: 0, y: 0), in: self)
            break
        case UIGestureRecognizerState.ended:
            let f = self.frame
            var dx = f.origin.x
            var dy = f.origin.y
            if dx > superFrame.size.width-10-LYCopyGlobalButton.ButtonSize {
                dx = superFrame.size.width-10-LYCopyGlobalButton.ButtonSize
            } else if dx < 10 {
                dx = 10.0
            } else {
                dx = dx > superFrame.size.width-dx ? superFrame.size.width-10-LYCopyGlobalButton.ButtonSize : 10
            }

            if dy > superFrame.size.height-10-LYCopyGlobalButton.ButtonSize {
                dy = superFrame.size.height-10-LYCopyGlobalButton.ButtonSize
            } else if dy < 10 {
                dy = 10.0
            }
            
            UIView.animate(withDuration: 0.2) {
                self.frame = CGRect(x: dx, y: dy, width: f.size.width, height: f.size.height)
            }
            break
            
        default: break
            
        }
        let point:CGPoint = pan.translation(in: self)
        self.transform = CGAffineTransform.init(translationX: point.x, y: point.y)
    }
    
    //点击
    @objc func showSubButtons() {
        if !hasSelected {
            hasSelected = true
            self.isHidden = true
            appWindow.addSubview(markView)
            appWindow.addSubview(subButtonsView)
            
            var y = self.frame.origin.y+LYCopyGlobalButton.ButtonSize/2-LYCopyGlobalButton.SubButtonsViewSize/2
            if y + LYCopyGlobalButton.SubButtonsViewSize + 50 > appWindow.frame.size.height {
                y = appWindow.frame.size.height-(LYCopyGlobalButton.SubButtonsViewSize + 50)
            }
            y = y < 50 ? 50 : y
            subButtonsView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: LYCopyGlobalButton.ButtonSize, height: LYCopyGlobalButton.ButtonSize)
            UIView.animate(withDuration: 0.3) {
                self.markView.alpha = 1
                self.subButtonsView.frame = CGRect(x: (self.appWindow.frame.size.width-LYCopyGlobalButton.SubButtonsViewSize)/2, y: y, width: LYCopyGlobalButton.SubButtonsViewSize, height: LYCopyGlobalButton.SubButtonsViewSize)
            }
        }
    }
    
    @objc func showSelf() {
        UIView.animate(withDuration: 0.3, animations: {
            self.markView.alpha = 0
            self.subButtonsView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: LYCopyGlobalButton.ButtonSize, height: LYCopyGlobalButton.ButtonSize)
        }) { (true) in
            self.isHidden = false
            self.hasSelected = false
            self.markView.removeFromSuperview()
            self.subButtonsView.removeFromSuperview()
        }
    }
}
