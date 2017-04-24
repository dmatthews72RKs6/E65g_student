//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Water on 4/19/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

public protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

public protocol EngineProtocol {
    var delegate: EngineDelegate { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer { get set }
    var size: Int { get set}
    init (rows: Int, cols: Int)
    func step () -> GridProtocol
}

public class StandardEngine: EngineProtocol {
    public var size: Int = 10
    public var grid: GridProtocol
    
    public var refreshRate: Double = 0
    public var refreshTimer: Timer
    

    static var engine: StandardEngine = StandardEngine(rows: 10, cols: 10)
    
    
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
        
    public required init(rows: Int, cols: Int) {
            self.grid = Grid(rows, cols)
    }
        
    public func step() -> GridProtocol {
            let newGrid = grid.next()
            grid = newGrid
            //         updateClosure?(self.grid)
            delegate?.engineDidUpdate(withGrid: grid)
                      let nc = NotificationCenter.default
                      let name = Notification.Name(rawValue: "EngineUpdate")
                      let n = Notification(name: name,
                                           object: nil,
                                           userInfo: ["engine" : self])
                                           nc.post(n)
            return grid
        }
}
