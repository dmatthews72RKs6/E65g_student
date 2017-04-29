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
    let runSimNS = Notification.Name(rawValue: "InstrumentationRunSim")
    let refreshRateNS = Notification.Name(rawValue: "InstrumentationRefreshRate")
    let gridSizeNS = Notification.Name(rawValue: "InstrumentationGridSize")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSwitch.setOn(false, animated: false)
        gridSizeStepper.stepValue = 10
        gridSizeStepper.value = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func runSimulationSwitch(_ sender: UISwitch) {
        let n = Notification(name: runSimNS,
                             object: sender.isOn,
                             userInfo: ["InstrumentationRunSim" : sender])
        nc.post(n)
    }
    
    @IBAction func updateRefreshRate(_ sender: UISlider) {
        
        let n = Notification(name: refreshRateNS,
                             object: (sender.value * 9 + 1),
                             userInfo: ["InstrumentationRefreshRate" : sender])
        nc.post(n)
    }
    
  
    @IBAction func stepperChangeGridSize(_ sender: UIStepper) {
        let val = Int(sender.value)
        changeGridSize(val)
    }

    @IBAction func textChangeGridSize(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = self.gridSizeBox.text
            }
            return
        }
        changeGridSize(val)

    }
    
    func changeGridSize (_ size: Int) {
       
        let n = Notification(name: gridSizeNS,
                             object: size,
                             userInfo: ["InstrumentationGridSize" : size])
        nc.post(n)
        print ("Instrumentation changed Grid Size \(size)")
        gridSizeBox.text = ("\(size)")
        gridSizeStepper.

    }
    
    //MARK: AlertController Handling
    func showErrorAlert(withMessage msg: String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

