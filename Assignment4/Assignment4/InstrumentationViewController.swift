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
    private var jsonGrids: [storedGrid] = []
    private var engine = StandardEngine.engine
    
    private struct storedGrid {
        var engine: StandardEngine
        var name: String
        
        public init (name: String, cellsOn: [[Int]]){
            self.name = name
            engine = StandardEngine(grid: Grid(cellsOn: cellsOn))
            
        }
    }
    
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
        engine.runSim = sender.isOn
    }
    
    @IBAction func updateRefreshRate(_ sender: UISlider) {
       engine.refreshRate = (Double(sender.value * 9) + 1.0)
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
        engine.size = size
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Grids"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonGrids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = jsonGrids[indexPath.item].name
        return cell
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            if let vc = segue.destination as? GridEditorViewController {
                vc.engine = jsonGrids[indexPath.item].engine
                vc.gridName = jsonGrids[indexPath.item].name
                vc.saveClosure = { newValue in
                    self.jsonGrids[indexPath.item].name = vc.gridTitle.text!
                    self.jsonGrids[indexPath.item].engine = vc.engine
                    self.engine.size = vc.engine.size
                    self.engine.grid = vc.engine.grid
                    self.tableView.reloadData()
                }
                print ("set grid save closure")
            }
        }
    }
    
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
                self.jsonGrids.append(storedGrid(name: title, cellsOn: contents))
            }
            
           
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
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

