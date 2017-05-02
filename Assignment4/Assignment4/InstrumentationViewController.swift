//
//  IntrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gridSizeBox: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var gridRefreshRate: UISlider!
    @IBOutlet weak var runSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    private var jsonGrids: [StoredGrid] = []
    private var engine = StandardEngine.engine
    
    // For storing a name associated with an engine for user recall
    private struct StoredGrid {
        var engine: StandardEngine
        var name: String
        
        public init (name: String, cellsOn: [[Int]]){
            self.name = name
            engine = StandardEngine(grid: Grid(cellsOn: cellsOn))
            
        }
        public init (name: String) {
            self.name = name
            engine = StandardEngine(grid: Grid(10, 10))
        }
        public init (name: String, grid: Grid){
            self.name = name
            engine = StandardEngine(grid: grid)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSwitch.setOn(false, animated: false)
        gridSizeStepper.stepValue = 10
        gridSizeStepper.maximumValue = 200
        gridSizeStepper.value = 10
        
        // downloads and parses the JSON, then updates the Table View
        fetchJSON()
        
        // Adds grids which are desired to be saved to the Table View
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "SaveGrid")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            if let grid = n.object as? (Grid, String) {
                self.jsonGrids.append(StoredGrid(name: grid.1, grid: grid.0))
                self.tableView.reloadData()
            }

        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: User Interface actions
    
    // Adds a new 
    @IBAction func addStoredGrid(_ sender: UIBarButtonItem) {
        jsonGrids.append(StoredGrid(name: "Untitled"))
        self.tableView.reloadData()
    }
    
    // Starts simulating the grid
    @IBAction func runSimulationSwitch(_ sender: UISwitch) {
        engine.runSim = sender.isOn
    }
    
    // Sets the speed of simulation when engine.runSim == true
    @IBAction func updateRefreshRate(_ sender: UISlider) {
       engine.refreshRate = (Double(sender.value * 9) + 1.0)
    }
    
  
    // updates the size of the grid as edited by the user through the stepper
    @IBAction func stepperChangeGridSize(_ sender: UIStepper) {
        let val = Int(sender.value)
        changeGridSize(val)
    }

    // updates the size of the grid as edited by the user through the TextField
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
    
    
    // helper method for changing the size of the grid. This method syncs up the stepper and the TextView, and informs the StandardEngine to update.
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
        navigationController?.isNavigationBarHidden = false
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
                gridSizeBox.text = ("\(vc.engine.size)")
                gridSizeStepper.value = Double(vc.engine.size)
                
                vc.saveClosure = { newValue in
                    self.jsonGrids[indexPath.item].name = vc.gridTitle.text!
                    self.jsonGrids[indexPath.item].engine = vc.engine
                    self.engine.size = vc.engine.size
                    self.engine.grid = vc.engine.grid
                    self.tableView.reloadData()
                    let nc = NotificationCenter.default
                    let name = Notification.Name(rawValue: "EngineUpdate")
                    let n = Notification(name: name,
                                         object: vc.engine.grid,
                                         userInfo: ["engine" : self])
                    nc.post(n)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            jsonGrids.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
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
                self.jsonGrids.append(StoredGrid(name: title, cellsOn: contents))
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

