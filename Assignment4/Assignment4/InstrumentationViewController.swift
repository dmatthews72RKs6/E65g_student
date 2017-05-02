//
//  IntrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let nc = NotificationCenter.default
    
    @IBOutlet weak var gridSizeBox: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var gridRefreshRate: UISlider!
    @IBOutlet weak var runSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    let runSimNS = Notification.Name(rawValue: "InstrumentationRunSim")
    let refreshRateNS = Notification.Name(rawValue: "InstrumentationRefreshRate")
    let gridSizeNS = Notification.Name(rawValue: "InstrumentationGridSize")
    var jsonGrids: [[Any]] = []
    
    
    
    override func viewDidLoad() {
        print ("InstrumentationViewController Loaded")
        super.viewDidLoad()
        runSwitch.setOn(false, animated: false)
        gridSizeStepper.stepValue = 10
        gridSizeStepper.value = 10
        fetchJSON()
        print (jsonGrids)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func runSimulationSwitch(_ sender: UISwitch) {
        StandardEngine.engine.runSim = sender.isOn
    }
    
    @IBAction func updateRefreshRate(_ sender: UISlider) {
       StandardEngine.engine.refreshRate = (Double(sender.value * 9) + 1.0)
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
        var size = size
        
        if( size <= 0 ){
            size = 1
        }
        StandardEngine.engine.size = size
        gridSizeBox.text = ("\(size)")
        gridSizeStepper.value = Double(size)

    }
    //MARK: TableView DataSource and Delegate
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonGrids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = jsonGrids[indexPath.item][0] as? String
        print (label.text!)
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Grids"
    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let indexPath = tableView.indexPathForSelectedRow
//        if let indexPath = indexPath {
//            let fruitValue = jsonGrids[indexPath.section][indexPath.row]
////            if let vc = segue.destination as? GridEditorViewController {
////                vc.fruitValue = fruitValue
////                vc.saveClosure = { newValue in
////                    data[indexPath.section][indexPath.row] = newValue
////                    self.tableView.reloadData()
////                }
////            }
//        }
//    }
    
    //MARK: fetching JSON
    func fetchJSON() {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string: finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
          
            // let resultString = (json as AnyObject).description
            let jsonArray = json as! NSArray
            
            jsonArray.forEach{ dictionary in
                let dict = dictionary as! NSDictionary
                let title = dict["title"] as! String
                let contents = dict["contents"] as! [[Int]]
                self.jsonGrids.append([title, contents])
            }
            
           
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                print (self.jsonGrids)
                
            }
        }
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

