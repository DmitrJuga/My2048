//
//  Board.swift
//  My2048
//
//  Created by DmitrJuga + James Jackson on 6/18/17.
//  Copyright (c) 2017 Dmitriy Dolotenko + James Jackson. All rights reserved.
//

import SpriteKit

typealias M2DPosition = (col: Int, row: Int)

// MARK: - Board
class Board: SKShapeNode {
    
    var field = Matrix2D<Tile>(columns: Config.defaultConfig.GRID_SIZE,
                                  rows: Config.defaultConfig.GRID_SIZE)

    fileprivate let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    /** Constructor */
    override init() {
        super.init()
        
        // customize the form, size and color of the field
        let nodeRect = CGRect(x: 0, y: 0, width: config.BOARD_SIZE, height: config.BOARD_SIZE);
        self.path = CGPath(roundedRect: nodeRect, cornerWidth: config.CORNER_RADIUS, cornerHeight: config.CORNER_RADIUS, transform: nil)
        self.fillColor = UIColor(hex: config.BOARD_COLOR)
        self.strokeColor = self.fillColor
        
        // filling the field with empty tiles
        for col in 0..<field.rows {
            for row in 0..<field.columns {
                let emptyTile = createTile((col, row))
                field[col, row] = emptyTile
                addChild(emptyTile)
            }
        }
        
        // initial tiles
        setRandomTile()
        setRandomTile()
    }
    

    /** Creating a new tile */
    func createTile(_ pos: M2DPosition) -> Tile {
        let t = Tile()
        let offsetX = config.TILE_GAP + config.TILE_SIZE / 2
        let offsetY = config.BOARD_SIZE - config.TILE_SIZE / 2 - config.TILE_GAP
        let tileSpace: CGFloat = config.TILE_SIZE + config.TILE_GAP
        t.position = CGPoint(x: offsetX + CGFloat(pos.col) * tileSpace,
                             y: offsetY - CGFloat(pos.row) * tileSpace)
        return t
    }

    
    /** Returns a random free position */
    func getRandomPosition() -> M2DPosition? {
        let emptyCells = field.getEmpties{ ($0! as Tile).state.getNumberValue().value == 0 }
        if emptyCells.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(emptyCells.count)))
            return emptyCells[randIndex]
        } else {
            return nil
        }
    }
    
    
    /** Setting a random free tile to a non-empty value */
    func setRandomTile() {
        if let pos = getRandomPosition() {
            let tile = field[pos.col, pos.row]!
            tile.state.next()
            // animation
            tile.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0), SKAction.scale(to: 1, duration: 0.15)]))
        }
    }
    
    
    /** Get Coords by Direction Order */
    func getCoordsByDirection(_ direction: UISwipeGestureRecognizerDirection, index: Int) -> [M2DPosition] {
        let gridSize = config.GRID_SIZE
        var result = [M2DPosition](repeating: (-1, -1), count: gridSize)
        
        for i in 0..<gridSize {
            switch direction {
            case UISwipeGestureRecognizerDirection.up:
                result[i] = (index, gridSize - i - 1)
            case UISwipeGestureRecognizerDirection.down:
                result[i] = (index, i)
            case UISwipeGestureRecognizerDirection.left:
                result[i] = (gridSize - i - 1, index)
            case UISwipeGestureRecognizerDirection.right:
                result[i] = (i, index)
            default: break;
            }
        }
        
        return result
    }
    
    
    /** Shift all files in the line */
    func moveTilesInLine(_ line: [M2DPosition], startAt index: Int = 0) -> Int {
        var resCnt = 0
        
        // if this is not the last cell, otherwise - exit from the recursion
        if index < line.count - 1 {
            // if the current cell is empty - go recursively to the next cell
            let curTile = field[line[index].col, line[index].row]!
            if curTile.state.getNumberValue().value == 0 {
                resCnt = moveTilesInLine(line, startAt: index + 1)
            } else {
                // if the next cell is not empty - let's try to move it first (recursively)
                var nextTile = field[line[index + 1].col, line[index + 1].row]!
                if nextTile.state.getNumberValue().value != 0 {
                    resCnt = moveTilesInLine(line, startAt: index + 1)
                }
                // if the next cell (already) is empty - move the current one
                nextTile = field[line[index + 1].col, line[index + 1].row]!
                if nextTile.state.getNumberValue().value == 0 {
                    let nextPosition = nextTile.position
                    nextTile.position = curTile.position
                    curTile.position = nextPosition
                    field[line[index].col, line[index].row] = nextTile
                    field[line[index + 1].col, line[index + 1].row] = curTile
                    
                    resCnt += 1
                    // and go move the next cell (recursively)
                    resCnt += moveTilesInLine(line, startAt: index + 1)
                }
            }
        }
        return resCnt
    }

   
    // ** Adding the same tiles to the line * /
    func mergeTilesInLine(_ line: [M2DPosition], startAt ind: Int = -1) -> Int {
        var resCnt = 0
        let index = ind == -1 ? line.count - 1 : ind // the line is passed in reverse order
        
        // if not the last cell, otherwise - exit from the recursion
        if index > 0 {
            
            // if the current cell is not empty and the value is equal to the next - we combine them
            let curTile = field[line[index].col, line[index].row]!
            let nextTile = field[line[index - 1].col, line[index - 1].row]!
            if curTile.state.getNumberValue().value != 0 &&
                curTile.state.getNumberValue().value == nextTile.state.getNumberValue().value {
                    let nextPosition = nextTile.position
                    nextTile.position = curTile.position
                    curTile.position = nextPosition
                    field[line[index].col, line[index].row] = nextTile
                    field[line[index - 1].col, line[index - 1].row] = curTile
                    
                    nextTile.state.clear()
                    curTile.state.next()
                    
                    // animation + sound
                    curTile.run(SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.2), SKAction.scale(to: 1, duration: 0.2)]))
                    run(SKAction.playSoundFileNamed("merge.wav", waitForCompletion: false))
                
                    resCnt += 1
                    // and go to the next cell (recursively)
                    resCnt += mergeTilesInLine(line, startAt: index - 2)
                    
            } else {
                // otherwise - we go recursively to the next cell
                resCnt = mergeTilesInLine(line, startAt: index - 1)
            }
        }
        return resCnt
    }


    // ** STEP - Move the game
    func step(_ direction: UISwipeGestureRecognizerDirection) {
        var actCnt = 0
        for i in 0 ..< config.GRID_SIZE {
            let line = getCoordsByDirection(direction, index: i)
            
            // 1. TRIM - Remove empty tiles on direction
            actCnt += moveTilesInLine(line)
            
            // 2. COLLAPSE - Add equal tiles
            actCnt += mergeTilesInLine(line)
            
            // 3. TRIM - Remove other empty tiles
            actCnt += moveTilesInLine(line)
        }
        
        if actCnt != 0 {
            run(SKAction.playSoundFileNamed("move.wav", waitForCompletion: false))
            setRandomTile()
        }
    }
}
