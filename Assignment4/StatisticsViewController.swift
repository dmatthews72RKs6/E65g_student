//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Water on 4/14/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var currentlyAlive: UILabel!
    @IBOutlet weak var currentlyDied: UILabel!
    @IBOutlet weak var currentlyBorn: UILabel!
    
    @IBOutlet weak var totalAlive: UILabel!
    @IBOutlet weak var totalBorn: UILabel!
    @IBOutlet weak var totalDied: UILabel!
    
    var nc = NotificationCenter.default
    var name = Notification.Name(rawValue: "EngineUpdate")
    
    // Stores the total number of .alive, .died, and .born since viewDidLoad()
    var ttlAlive: Int = 0
    var ttlDied: Int = 0
    var ttlBorn: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // updates the counts of various CellStates ever time the StandardEngine.grid changes.
        self.nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            if let grid = n.object as? Grid {
                // current states
                self.currentlyAlive.text = "Currently Alive: \( grid.numInState(state: CellState.alive))"
                self.currentlyBorn.text = "Currently Born: \(grid.numInState(state: CellState.born))"
                self.currentlyDied.text = "Currently Died: \(grid.numInState(state: CellState.died))"
                
                // total since launch
                self.ttlBorn += grid.numInState(state: CellState.born)
                self.totalBorn.text = "Total Born: \(self.ttlBorn)"
                self.ttlAlive += grid.numInState(state: CellState.alive)
                self.totalAlive.text = "Total Alive: \(self.ttlAlive)"
                self.ttlDied += grid.numInState(state: CellState.died)
                self.totalDied.text = "Total Died: \(self.ttlDied)"
            }
            
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

