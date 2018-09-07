//
//  ViewController.swift
//  JingDataStateSwitch
//
//  Created by tianziyao on 08/31/2018.
//  Copyright (c) 2018 tianziyao. All rights reserved.
//

import UIKit
import JingDataStateSwitch

class ViewController: UIViewController, JingDataStateSwitch {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(aboveView: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        state = .loading
    }
}

