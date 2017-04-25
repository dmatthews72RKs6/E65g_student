//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource {
    subscript(row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col]  }
        set { engine.grid[row,col] = newValue }
    }

    

    @IBOutlet weak var gridView: GridView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    public var size: Int = 10
    public var name: String = "SimulationViewController"
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        print ("EngineSize: \(engine.size)")
        print ("EngineGridCell00: \(engine.grid[0,0].isAlive)")
        size = engine.size

       // engine.delegate = self as? EngineDelegate
        
        gridView.gridDataSource = self as GridViewDataSource
        print ("Simulation - GridView.gridDataSource\(gridView.gridDataSource!)")
        
        // sizeStepper.value = Double(engine.grid.size.rows)
        
        
        // for updating the grid on the scren
        let nc = NotificationCenter.default
        let ncname = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: ncname,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
        
        // do we run the timer?
        let rs = NotificationCenter.default
        let rsname = Notification.Name(rawValue: "RunSimulation")
        rs.addObserver (forName: rsname,
                        object: Bool.self,
                        queue: nil) { (n) in
                            if (object) {
                                
                            }
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

