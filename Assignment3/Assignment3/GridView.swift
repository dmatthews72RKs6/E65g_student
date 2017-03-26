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
            grid = Grid(size, size) {_,_ in .empty}
        }
    }
    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.lightGray
    @IBInspectable var bornColor = UIColor.cyan
    @IBInspectable var diedColor = UIColor.black
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    var grid = Grid.init(0, 0)
    
    public func nextGrid() {
        grid = grid.next()
        setNeedsDisplay()
        
    }
    
    

    override func draw(_ rect: CGRect) {
        let cellSize = CGSize (
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        
        // draw the circles
        grid.positions.forEach{ p in
            let color: UIColor
            
            switch grid[p].description {
                case "alive": color = livingColor
                case "empty": color = emptyColor
                case "born": color = bornColor
                case "died": color = diedColor
            default: color = UIColor.black
            }
            
            drawCircle(
                origin: CGPoint(x: cellSize.width * CGFloat(p.col), y: cellSize.height * CGFloat(p.row)),
                size: cellSize,
                color: color
            )
        }
        
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
        gridColor.setStroke()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    var lastTouchedPosition: Position?

    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        
        let pos = convert(touch: touches.first!)
        
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        grid[pos] = grid[pos].toggle(value: grid[pos])
        
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = Int (touchY / gridHeight * CGFloat(size))
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = Int (touchX / gridWidth * CGFloat(size))
        let position = (row: row, col: col)
        return position
    }


}
