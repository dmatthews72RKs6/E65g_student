//
//  GridView.swift
//  Assignment4
//
//  Created by David Matthwews on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
    var size: Int { get }
}



class GridView: UIView {

    
    var gridDataSource: GridViewDataSource?
    var emptyColor = UIColor.clear
    var livingColor = UIColor.green
    var bornColor = UIColor.green.withAlphaComponent(0.3)
    var diedColor = UIColor.black.withAlphaComponent(0.5)
    var gridColor = UIColor.black
    var gridWidth: CGFloat = 2.0
    var gridSize: Int = 10
    
    override func draw(_ rect: CGRect) {
        // Checking if gridDataSource is attached. If it is not, drawing can not occur.
        guard gridDataSource != nil else { return }
        
        /**
         Updating knowlege of size of grid so it can be drawn correctly.
         */
        gridSize = gridDataSource!.size
        
        
        //MARK: appearance of grid lines for small and large grids
        if (gridSize >= 30) {
            gridWidth = 0.5
            gridColor = gridColor.withAlphaComponent(0.2)
        }
        else {
            gridWidth = 2.0
            gridColor = gridColor.withAlphaComponent(1)
        }

        //MARK: calculating the size of each grid cell
        let cellSize = CGSize (
            width: rect.size.width / CGFloat(gridSize),
            height: rect.size.height / CGFloat(gridSize)
        )
       
        // draw the grid cell circles
        (0 ..< gridSize).forEach { i in
            (0 ..< gridSize).forEach { j in
                let color: UIColor
                
                switch gridDataSource![i, j] {
                    case .alive: color = livingColor
                    case .empty: color = emptyColor
                    case .born: color = bornColor
                    case .died: color = diedColor
                }
               
                drawCircle(
                    origin: CGPoint(x: cellSize.width * CGFloat(j), y: cellSize.height * CGFloat(i)),
                    size: cellSize,
                    color: color
                )
            }
        }
        
        // draws the grid
        (0...gridSize).forEach {
            // verticle lines
            drawLine(
                start:  CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: 0.0),
                end:    CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: rect.size.height)
            )
            // horizontal lines
            drawLine(
                start:  CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height),
                end:    CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height)
            )

        }
        
    }
    
    /**
        Draws a straight line between two points.
     */
    
    func drawLine (start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: start)
        path.addLine(to: end)
        gridColor.setStroke()
        path.stroke()
    }
    
    /**
        Draws a circle of a specified color and size at a specified location
     */
    func drawCircle (origin: CGPoint, size: CGSize, color: UIColor) {
        let rect = CGRect(
            origin: origin,
            size: size
        )
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }
    
    /**
        Processes the first touch on the grid and toggles the appropiate cell once
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }

    /**
        Processes the middle touches on the grid and toggles the appropiate cell once
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    /**
        Processes the last touch on the grid and enables the last touched cell to be toggled again.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    /**
        Records the last touched position to avoid toggling a cell multiple times as a user swipes their hand across it.
    */
    var lastTouchedPosition: GridPosition?

    /**
     Calculates the cell in which a touch occured and toggles the affected cell before requesting a redraw of the screen.
    */
    func process(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        
        guard let pos = getCell(touch: touches.first!) else {return nil}
        
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
       
        let newCellState = (gridDataSource?[pos.row, pos.col].toggle)!
        gridDataSource?[pos.row, pos.col] = newCellState
        
        setNeedsDisplay()
        return pos
    }
    
    /**
     Calculates and returns the cell in which a touch occured. In the event that a touch is started and moves off the grid, the period in which the touch is off the grid returns nil.
     */
    func getCell(touch: UITouch) -> GridPosition? {
        let height = frame.size.height
        let width = frame.size.width
        let touchYPos = touch.location(in: self).y
        let touchXPos = touch.location(in: self).x
        
        guard touchYPos <= height && touchYPos >= CGFloat(0) else {return nil}
        guard touchXPos <= width && touchXPos >= CGFloat(0) else {return nil}
        
        let row = Int (touchYPos / height * CGFloat(gridSize))
        
      
        let col = Int (touchXPos / width * CGFloat(gridSize))
        
       
        return GridPosition(row: row, col: col)
    }

}
