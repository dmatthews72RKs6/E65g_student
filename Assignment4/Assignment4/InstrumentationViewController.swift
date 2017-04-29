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
    
    @IBOutlet weak var gridSizeBox: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var gridRefreshRate: UISlider!
    @IBOutlet weak var runSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSwitch.setOn(false, animated: false)
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
        let name = Notification.Name(rawValue: "InstrumentationRunSim")
        let n = Notification(name: name,
                             object: sender.isOn,
                             userInfo: ["InstrumentationRunSim" : sender])
        nc.post(n)
    }
    
    @IBAction func updateRefreshRate(_ sender: UISlider) {
        let name = Notification.Name(rawValue: "InstrumentationRefreshRate")
        let n = Notification(name: name,
                             object: (sender.value * 9 + 1),
                             userInfo: ["InstrumentationRefreshRate" : sender])
        nc.post(n)
    }
    
    @IBAction func changeGridSize(_ sender: UIStepper) {
        let newSize = Int(sender.value * 10)
        let name = Notification.Name(rawValue: "InstrumentationGridSize")
        let n = Notification(name: name,
                             object: newSize,
                             userInfo: ["InstrumentationGridSize" : sender])
        nc.post(n)
        gridSizeBox.text = ("\(StandardEngine.engine.size)")
    }

}

