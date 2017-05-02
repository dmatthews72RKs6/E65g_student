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
    public var size: Int {
        get {
             return StandardEngine.engine.size
        }
        set {
            print ("Simulation changed Grid Size \(size)")
            StandardEngine.engine.size = size
        }
       
    }

    public var name: String = "SimulationViewController"
   
   
    override func viewDidLoad() {
        print ("SimulationViewController Loaded")
        super.viewDidLoad()
        engine = StandardEngine.engine
        gridView.gridDataSource = self as GridViewDataSource
 
        
        
        
        // for updating the grid on the screen
        let nc = NotificationCenter.default
        let ncname = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: ncname,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
    }
    

    @IBAction func Step(_ sender: Any) {
        _ = self.engine.step()
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

