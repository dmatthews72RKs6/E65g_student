//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit


class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    subscript(row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col]  }
        set { engine.grid[row,col] = newValue}
    }
    
    @IBOutlet weak var gridView: GridView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    var size: Int {
        get {
            return engine.size
        }
    }
    
    public var name: String = "SimulationViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        engine.delegate = self as EngineDelegate
        gridView.gridDataSource = self as GridViewDataSource
    }
    

    // Progresses the Grid one state forward.
    @IBAction func Step(_ sender: Any) {
        _ = self.engine.step()
    }
    
    // resets the grid to every cell being of CellState .empty
    @IBAction func reset(_ sender: UIButton) {
        self.engine.size = self.size
    }
    
    // Adds the current grid state to the savedGrids TableView of the InstrumentationView
    @IBAction func save(_ sender: UIButton) {
   
        let alert = UIAlertController(title: "Save Grid", message: "Enter a title", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Saved Grid"
        }
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {(UIAlertAction) in
                                        let textField = alert.textFields![0].text
                                        let currentGrid = StandardEngine.engine.grid as! Grid
                                        let nc = NotificationCenter.default
                                        let name = Notification.Name(rawValue: "SaveGrid")
                                        let n = Notification(name: name,
                                                             object: (currentGrid, textField),
                                                             userInfo: ["SaveGrid" : self])
                                        nc.post(n)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Redraws GridView when needed
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

