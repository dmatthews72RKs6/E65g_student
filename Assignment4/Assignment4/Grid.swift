//
//  Grid.swift
//
public typealias GridPosition = (row: Int, col: Int)
public typealias GridSize = (rows: Int, cols: Int)

fileprivate func norm(_ val: Int, to size: Int) -> Int { return ((val % size) + size) % size }

// Stores the states of the cells, and aids in toggling them on user presses.
public enum CellState {
    case alive, empty, born, died
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
    
    public var toggle: CellState {
        switch self {
        case .empty, .died: return .alive
        case .alive, .born: return .empty
        }
    }
}



public protocol GridProtocol {
    init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState)
    var description: String { get }
    var size: GridSize { get }
    subscript (row: Int, col: Int) -> CellState { get set }
    func next() -> Self
    func numInState (state: CellState) -> Int
    
}

//public protocol GridStats {
//    
//}
//
//
//extension GridStats {
//  }
public let lazyPositions = { (size: GridSize) in
    return (0 ..< size.rows)
        .lazy
        .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
        .flatMap { $0 }
        .map { GridPosition($0) }
}

// relative positions of the neighbors of a cell
let offsets: [GridPosition] = [
    (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
    (row:  0, col:  -1),                     (row:  0, col:  1),
    (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
]

extension GridProtocol {
    
    public func numInState (state: CellState) -> Int {
        let state: Array = lazyPositions(self.size).filter { return self[$0.row, $0.col] == (state) }
        return state.count
    }

    // returns ascii art of the grid.
    public var description: String {
        return lazyPositions(self.size)
            .map { (self[$0.row, $0.col].isAlive ? "*" : " ") + ($0.col == self.size.cols - 1 ? "\n" : "") }
            .joined()
    }
    
    // returns an array of the CellStates of the adjacent cells to a given cell.
    private func neighborStates(of pos: GridPosition) -> [CellState] {
        return offsets.map { self[pos.row + $0.row, pos.col + $0.col] }
    }
    
    // Determines the next CellState of a given cell
    private func nextState(of pos: GridPosition) -> CellState {
        let iAmAlive = self[pos.row, pos.col].isAlive
        let numLivingNeighbors = neighborStates(of: pos).filter({ $0.isAlive }).count
        switch numLivingNeighbors {
        case 2 where iAmAlive,
             3: return iAmAlive ? .alive : .born
        default: return iAmAlive ? .died  : .empty
        }
    }
    
    // Walks through each cell in the grid returning a Grid with each cell at it's next CellState
    public func next() -> Self { 
        var nextGrid = Self(size.rows, size.cols) { _, _ in .empty }
        lazyPositions(self.size).forEach { nextGrid[$0.row, $0.col] = self.nextState(of: $0) }
        return nextGrid
    }
}


public struct Grid: GridProtocol {
    private var _cells: [[CellState]]
    public let size: GridSize
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }
    
    // Initialises a grid of a certian size and sets their initial CellStates baised on cellInitializer
    public init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState = { _, _ in .empty }) {
        _cells = [[CellState]](repeatElement( [CellState](repeatElement(.empty, count: rows)), count: cols))
        size = GridSize(rows, cols)
        lazyPositions(self.size).forEach { self[$0.row, $0.col] = cellInitializer($0) }
    }
    
    // Initializes a grid out of a set of cells stated to be on.
    public init (cellsOn: [[Int]]) {
        var maxVal: Int = cellsOn.reduce(0){
            let prevMax = $0
            let subMax: Int = $1.reduce(0) {
                return ($1 > $0) ? $1: $0
            }
            return (subMax > prevMax) ? subMax: prevMax
        }
        
        maxVal *= 2
        size = GridSize (maxVal, maxVal)
        _cells = [[CellState]](repeatElement( [CellState](repeatElement(.empty, count: size.rows)), count: size.cols))
        cellsOn.forEach {
            self[$0[0], $0[1]] = CellState.alive
        }
    }
}
