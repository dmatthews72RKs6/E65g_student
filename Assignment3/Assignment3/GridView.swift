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
        let cellSize = CGSize (
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )

        
        // draw the grid
        
        (0...size).forEach {
            // horizontal
            drawLine(
                start:  CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size) * rect.size.height),
                end:    CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size) * rect.size.height)
            )
            
            // verticle
            drawLine(
                start:  CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: 0.0),
                end:    CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: rect.size.height)
            )
        }

        // draw the circles
        
        drawCircle(origin: CGPoint(x: 0, y: 0), size: cellSize, color: UIColor.brown)
        
    }
    
    /**
    Draws a line of a desired color from start to end.
     
     - Parameter start: The point to start drawing the line at.
     - Parameter end: The point to end the line at.
     - Parameter color: The color of the line.
    */
    func drawLine (start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: start)
        path.addLine(to: end)
        UIColor.black.setStroke()
        path.stroke()
    }
    
    //TODO: make the circles slightly smaller to not overlap with the grid lines
    
    func drawCircle (origin: CGPoint, size: CGSize, color: UIColor) {
        let rect = CGRect(
            origin: origin,
            size: size
        )
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }

}
