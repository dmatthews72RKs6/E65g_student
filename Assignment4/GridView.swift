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
}



class GridView: UIView {


     var livingColor = UIColor.green
     var emptyColor = UIColor.lightGray
     var bornColor = UIColor.cyan
     var diedColor = UIColor.black
     var gridColor = UIColor.black
     var gridWidth: CGFloat = 2.0
     var gridSize  = 20
    
    var gridDataSource: GridViewDataSource?
    
    override func draw(_ rect: CGRect) {
        let cellSize = CGSize (
            width: rect.size.width / CGFloat(gridSize),
            height: rect.size.height / CGFloat(gridSize)
        )

        // draw the circles
        (0 ..< gridSize).forEach { i in
            (0 ..< gridSize).forEach { j in
                let color: UIColor
                
                if let grid = gridDataSource {
                    switch grid[i, j] {
                    case .alive: color = livingColor
                    case .empty: color = emptyColor
                    case .born: color = bornColor
                    case .died: color = diedColor
                    }
                }
                else {
                    color = emptyColor
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
    
    func drawLine (start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: start)
        path.addLine(to: end)
        gridColor.setStroke()
        path.stroke()
    }
    
    func drawCircle (origin: CGPoint, size: CGSize, color: UIColor) {
        let rect = CGRect(
            origin: origin,
            size: size
        )
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
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
        
        print (gridDataSource)
        print ("oldCellState \(String(describing: gridDataSource?[pos.row, pos.col].isAlive))")
        let newCellState = (gridDataSource?[pos.row, pos.col].toggle)!
        print ("newCellState \(newCellState.isAlive)")
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
        
        print ("row: \(row), col: \(col)")
        return GridPosition(row: row, col: col)
    }

}
