//
//  Engine.swift
//  Assignment4
//
//  Created by Water on 4/19/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation


public protocol EngineProtocol {
    var delegate: EngineDelegate
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer { get set }
    var size: Int { get set}
    init (_ rows: Int, _cols: Int)
    func step () -> GridProtocol
}

@available(iOS 10.0, *)
class Engine {
    static var engine: Engine = Engine(rows: 10, cols: 10)
    
    var grid: Grid
    
    
    var updateClosure: ((Grid) -> Void)?
    var timer: Timer?
    var timerInterval: TimeInterval = 0.0 {
        didSet {
            if timerInterval > 0.0 {
                timer = Timer.scheduledTimer(
                    withTimeInterval: timerInterval,
                    repeats: true
                ) { (t: Timer) in
                    _ = self.step()
                }
            }
            else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    init(rows: Int, cols: Int) {
        self.grid = Grid(rows, cols)
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        //         updateClosure?(self.grid)
        delegate?.engineDidUpdate(withGrid: grid)
        //          let nc = NotificationCenter.default
        //          let name = Notification.Name(rawValue: "EngineUpdate")
        //          let n = Notification(name: name,
        //                               object: nil,
        //                               userInfo: ["engine" : self])
        //                               nc.post(n)
        return grid
    }
}
