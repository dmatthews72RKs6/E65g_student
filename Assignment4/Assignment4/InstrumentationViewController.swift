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
    let name = Notification.Name(rawValue: "InstrumentationRunSim")
    
    @IBOutlet weak var gridSizeBox: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var gridRefreshRate: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  gridRefreshRate.setMax
       // gridRefreshRate.setMin
       // gridSizeStepper.set
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func runSimulationSwitch(_ sender: UISwitch) {
        let n = Notification(name: name,
                             object: sender.isOn,
                             userInfo: ["InstrumentationRunSim" : sender])
        nc.post(n)
        print ("InstrumentationViewController sent an NSNotification \(sender.isOn)")
    }
    
    @IBAction func updateRefreshRate(_ sender: UISlider) {
        let n = Notification(name: name,
                             object: sender.value,
                             userInfo: ["InstrumentationRefreshRate" : sender])
        nc.post(n)
    }
    

}

