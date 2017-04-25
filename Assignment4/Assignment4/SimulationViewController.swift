//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {
    

    @IBOutlet weak var gridView: GridView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    public var size: Int = 10
   
    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.engine = StandardEngine(rows: size, cols: size)
        engine = StandardEngine.engine
        print (engine.grid.description)
        size = engine.size

        engine.delegate = self as? EngineDelegate
        
        gridView.gridDataSource = self as? GridViewDataSource
        // sizeStepper.value = Double(engine.grid.size.rows)
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
        
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

