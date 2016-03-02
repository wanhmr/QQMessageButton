//
//  ViewController.swift
//  QQMessageButton
//
//  Created by Tpphha on 16/3/1.
//  Copyright © 2016年 tpphha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = QQMessageButton(frame: CGRectMake(0, 0, 44, 44))
        btn.center = view.center
        btn.badgeNumber = 99
        view.addSubview(btn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}



