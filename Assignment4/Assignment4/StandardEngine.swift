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


    
    // public var delegate: EngineDelegate?

    public var size: Int = 10 {
        didSet {
            self.grid = Grid.init (size,size)
            delegate?.engineDidUpdate(withGrid: self.grid)
            
        }
    }

    public var grid: GridProtocol
    
    public var refreshRate: Double = 0 {
        didSet {
            print ("StandardEngineTimerInterval: \(timerInterval)")
            if (refreshRate != 0 ){
                timerInterval = 1/refreshRate
            }
            print ("StandardEngineRefreshRate: \(refreshRate)")
        }
    }

    
    public var refreshTimer: Timer?
    

    static var engine: StandardEngine = StandardEngine.init(rows: 10, cols: 10)
    
    var updateClosure: ((Grid) -> Void)?
    
    var timerInterval: TimeInterval = 1.0 {
        didSet {
            if (refreshTimer != nil && timerInterval > 0.0) {
                refreshTimer = Timer.scheduledTimer(withTimeInterval: timerInterval,
                                                    repeats: true) { (t: Timer) in
                                                        _ = self.step()
                }
            }
        }
    }

    
    public func stopTimer () {
        print ("StandardEngine: StopTimer")
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    public func startTimer() {
        print ("StandardEngine: StartTimer")
        if (timerInterval > 0.0) {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: timerInterval,
                                                repeats: true) { (t: Timer) in
                                                    _ = self.step()
            }
        }
    }

    
    public required init(rows: Int, cols: Int) {
        self.grid = Grid.init(rows, cols)
        self.size = rows
        self.refreshTimer = nil
        
        // publish new grid
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
        
        self.delegate = {} as? EngineDelegate
        
    }
    
    public func step() -> GridProtocol {
            let newGrid = grid.next()
            grid = newGrid
            updateClosure?(self.grid as! Grid)
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
