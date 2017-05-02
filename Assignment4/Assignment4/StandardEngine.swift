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
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get set }
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var size: Int { get set}
    var runSim: Bool { get set }
    init (rows: Int, cols: Int)
    func step () -> GridProtocol
}

public class StandardEngine: EngineProtocol {
    public var delegate: EngineDelegate?
    public var grid: GridProtocol
    public var refreshTimer: Timer?
    static var engine: EngineProtocol = StandardEngine.init(rows: 10, cols: 10)
    var updateClosure: ((GridProtocol) -> Void)?


    // true if the grid is automatically simulating via a timer
    public var runSim: Bool  = false {
        didSet{
            if (runSim) {
                startTimer()
            }
            else {
                stopTimer()
            }
        }
    }
    
    // creates a new grid and requests a redraw.
    public var size: Int = 10 {
        didSet {
            self.grid = Grid.init (size,size)
            delegate?.engineDidUpdate(withGrid: self.grid)
            
        }
    }
    
    // converts the rate of simulation into a time delay between steps
    public var refreshRate: Double = 0 {
        didSet {
            if (refreshRate != 0 ){
                timerInterval = 1/refreshRate
            }
        }
    }
    
    // Updates the rate to simulate the grid at with the Timer. If the timer is running, it is canceled and a new one is made.
    var timerInterval: TimeInterval = 1.0 {
        didSet {
            if (refreshTimer != nil && timerInterval > 0.0) {
                refreshTimer?.invalidate()
                refreshTimer = Timer.scheduledTimer(withTimeInterval: timerInterval,
                                                    repeats: true) { (t: Timer) in
                                                        _ = self.step()
                }
            }
        }
    }

    // Stops automatically simulating the grid.
    public func stopTimer () {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    // Starts a timer for simulating the Grid automatically.
    public func startTimer() {
        if (timerInterval > 0.0) {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: timerInterval,
                                                repeats: true) { (t: Timer) in
                                                    _ = self.step()
            }
        }
    }

    
    // Creates a StandardEngine with an empty grid of the specified size.
    public required init(rows: Int, cols: Int) {
        self.grid = Grid.init(rows, cols)
        self.size = rows
        self.refreshTimer = nil

        // publish new grid
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: self.grid,
                             userInfo: ["engine" : self])
        nc.post(n)

        self.delegate = {} as? EngineDelegate
    }
    
    // Creates a StandardEngine out of an existing Grid. Used for storing Grids in the Instrumentation Tab.
    public init (grid: Grid) {
        self.grid = grid
        self.size = grid.size.cols
        self.refreshTimer = nil
        
        self.delegate = {} as? EngineDelegate
    }
    
    // Steps the grid model one state forward, publishes the new grid, and requests a re-draw.
    public func step() -> GridProtocol {
            let newGrid = grid.next()
                grid = newGrid
            delegate?.engineDidUpdate(withGrid: self.grid)
        
        
            let nc = NotificationCenter.default
            let name = Notification.Name(rawValue: "EngineUpdate")
            let n = Notification(name: name,
                                 object: self.grid,
                                 userInfo: ["engine" : self])
                                 nc.post(n)
            return grid
        }
}
