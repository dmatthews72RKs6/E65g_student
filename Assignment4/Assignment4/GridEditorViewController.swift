//
//  GridEditorViewController.swift
//  Lecture11
//
//  Created by Van Simmons on 4/17/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource {
    subscript(row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col]  }
        set { engine.grid[row,col] = newValue}
    }
    var grid: Grid?
    var engine: StandardEngine = StandardEngine.init(rows: 1, cols: 1)
    
    var saveClosure: ((String) -> Void)?
    var gridName: String?
    
    @IBOutlet weak var gridTitle: UITextField!
    @IBOutlet weak var gridView: GridView!

    public var size: Int {
        get {
            return engine.size
        }
        set {
            StandardEngine.engine.size = size
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        if let title = gridName {
            gridTitle.text = title
        }
        gridView.gridDataSource = self as GridViewDataSource        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Recordes the changed Grid and updates the Simulation Tab
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let newValue = gridTitle.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }

   

}
