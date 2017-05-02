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
    public var size: Int {
        get {
            print (engine.size)
            return engine.size
        }
        set {
            print ("Simulation changed Grid Size \(size)")
            StandardEngine.engine.size = size
        }
        
    }
    var grid: Grid?
    var engine: StandardEngine = StandardEngine.init(rows: 1, cols: 1)

    var saveClosure: ((String) -> Void)?
    var gridName: String?

    @IBOutlet weak var gridTitle: UITextField!
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("view is loading")
        
        navigationController?.isNavigationBarHidden = false
        print ("showing navigation bar.")
        if let title = gridName {
            gridTitle.text = title
        }
        print ("set title")
        gridView.gridDataSource = self as GridViewDataSource
        print ("set gridViewDataSource to self.")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let newValue = gridTitle.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }

   

}
