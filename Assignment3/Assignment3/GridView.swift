//
//  GridView.swift
//  Assignment3
//
//  Created by Water on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var size = 20 {
        didSet{
            grid = Grid.init(size, size) { _,_ in .empty }
        }
    }
    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.lightGray
    @IBInspectable var bornColor = UIColor.cyan
    @IBInspectable var diedColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    var grid = Grid.init(0, 0)
    
    
    
    

    override func draw(_ rect: CGRect) {

    }

}
