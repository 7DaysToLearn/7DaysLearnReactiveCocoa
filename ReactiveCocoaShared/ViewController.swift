//
//  ViewController.swift
//  ReactiveCocoaShared
//
//  Created by 陆晖 on 15/11/18.
//  Copyright © 2015年 陆晖. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Masonry

class ViewController: UIViewController {
    
    lazy var manager = BLEMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.numberOfLines = 2;
        label.textColor = UIColor.blackColor()
        view.addSubview(label)
        
        let startButton = UIButton(type: .System)
        startButton.setTitle("开始", forState: .Normal)
        startButton.addTarget(manager, action: Selector("start"), forControlEvents: .TouchUpInside)
        view.addSubview(startButton)
        
        let stopButton = UIButton(type: .System)
        stopButton.setTitle("停止", forState: .Normal)
        stopButton.addTarget(manager, action: Selector("stop"), forControlEvents: .TouchUpInside)
        view.addSubview(stopButton)
        
        label.mas_makeConstraints { (maker) -> Void in
            maker.center.equalTo()(label.superview).multipliedBy()(0.9)
        }
        startButton.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(label.mas_bottom).offset()(20)
            maker.centerX.offset()(0)
        }
        stopButton.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(startButton.mas_bottom).offset()(10)
            maker.centerX.offset()(0)
        }
        
        manager.didReceiveData = {(data) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                label.text = "\(data.fromDeviceIdentifier):\n\(data.value)"
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

