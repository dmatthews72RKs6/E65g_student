//
//  IntrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    let nc = NotificationCenter.default
    let name = Notification.Name(rawValue: "RunSimulation")
    
    
    @IBAction func runSimulation(_ sender: UISwitch) {
        let n = Notification(name: name,
                             object: sender.isOn,
                             userInfo: ["Instrumentation" : sender])
        nc.post(n)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

