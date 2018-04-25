//
//  ViewController.swift
//  点击Button水波纹效果
//
//  Created by Yoyo on 2018/4/19.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //水波纹效果
        let button: LYWaveTouchButton = LYWaveTouchButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 50, y: 60, width: 250, height: 100)
        button.hightLightColor = UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1)
        button.backgroundColor = UIColor(red: 247.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1)
        button.setTitle("点我", for: UIControlState.normal)
        self.view.addSubview(button)
        
        //仿支付宝支付效果
        let aliPayButton = LYCopyAliPayButton(frame: CGRect(x: 20, y: 200, width: 330, height: 60), backgroundColor: UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1))
        self.view.addSubview(aliPayButton)
        
        //仿爱奇艺播放暂停按钮
        let qIYButton = LYCopyQIYButton(frame: CGRect(x: 100, y: 340, width: 100, height: 100), color:UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1))
        self.view.addSubview(qIYButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

