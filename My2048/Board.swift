//
//  Board.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

typealias M2DPosition = (col: Int, row: Int)

// MARK: - Board
class Board: SKShapeNode {
    
    var field = Matrix2D<Tile>(columns: Config.defaultConfig.GRID_SIZE,
                                  rows: Config.defaultConfig.GRID_SIZE)

    private let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    /** Constructor */
    override init() {
        super.init()
        
        // настройка формы, размера и цвета поля
        let nodeRect = CGRectMake(0, 0, config.BOARD_SIZE, config.BOARD_SIZE);
        self.path = CGPathCreateWithRoundedRect(nodeRect, config.CORNER_RADIUS, config.CORNER_RADIUS, nil)
        self.fillColor = UIColor(hex: config.BOARD_COLOR)
        self.strokeColor = self.fillColor
        
        // заполнение поля пустыми тайлами
        for col in 0..<field.rows {
            for row in 0..<field.columns {
                let emptyTile = createTile((col, row))
                field[col, row] = emptyTile
                addChild(emptyTile)
            }
        }
        
        // начальные тайлы
        setRandomTile()
        setRandomTile()
    }
    

    /** Создание нового тайла */
    func createTile(pos: M2DPosition) -> Tile {
        let t = Tile()
        let offsetX = config.TILE_GAP + config.TILE_SIZE / 2
        let offsetY = config.BOARD_SIZE - config.TILE_SIZE / 2 - config.TILE_GAP
        let tileSpace: CGFloat = config.TILE_SIZE + config.TILE_GAP
        t.position = CGPoint(x: offsetX + CGFloat(pos.col) * tileSpace,
                             y: offsetY - CGFloat(pos.row) * tileSpace)
        return t
    }

    
    /** Возвращает случайную свободную позицию */
    func getRandomPosition() -> M2DPosition? {
        let emptyCells = field.getEmpties{ ($0! as Tile).state.getNumberValue().value == 0 }
        if emptyCells.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(emptyCells.count)))
            return emptyCells[randIndex]
        } else {
            return nil
        }
    }
    
    
    /** Установка случайного свободного тайла в непустое значение */
    func setRandomTile() {
        if let pos = getRandomPosition() {
            let tile = field[pos.col, pos.row]!
            tile.state.next()
            // анимация
            tile.runAction(SKAction.sequence([SKAction.scaleTo(0, duration: 0), SKAction.scaleTo(1, duration: 0.15)]))
        }
    }
    
    
    /** Get Coords by Direction Order */
    func getCoordsByDirection(direction: UISwipeGestureRecognizerDirection, index: Int) -> [M2DPosition] {
        let gridSize = config.GRID_SIZE
        var result = [M2DPosition](count: gridSize, repeatedValue: (-1, -1))
        
        for i in 0..<gridSize {
            switch direction {
            case UISwipeGestureRecognizerDirection.Up:
                result[i] = (index, gridSize - i - 1)
            case UISwipeGestureRecognizerDirection.Down:
                result[i] = (index, i)
            case UISwipeGestureRecognizerDirection.Left:
                result[i] = (gridSize - i - 1, index)
            case UISwipeGestureRecognizerDirection.Right:
                result[i] = (i, index)
            default: break;
            }
        }
        
        return result
    }
    
    
    //** Сдвиг всех тайлов в линии */
    func moveTilesInLine(line: [M2DPosition], startAt index: Int = 0) -> Int {
        var resCnt = 0
        
        // если это не последняя ячейка, иначе - выход из рекурсии
        if index < line.count - 1 {
            // если текущая клетка пустая - идём рекурсивно на следующую клетку
            let curTile = field[line[index].col, line[index].row]!
            if curTile.state.getNumberValue().value == 0 {
                resCnt = moveTilesInLine(line, startAt: index + 1)
            } else {
                // если следующая клетка не пустая - попробуем сначала перемеcтить её (рекурсивно)
                var nextTile = field[line[index + 1].col, line[index + 1].row]!
                if nextTile.state.getNumberValue().value != 0 {
                    resCnt = moveTilesInLine(line, startAt: index + 1)
                }
                // если следующая клетка (уже) пустая - переместим текущую
                nextTile = field[line[index + 1].col, line[index + 1].row]!
                if nextTile.state.getNumberValue().value == 0 {
                    let nextPosition = nextTile.position
                    nextTile.position = curTile.position
                    curTile.position = nextPosition
                    field[line[index].col, line[index].row] = nextTile
                    field[line[index + 1].col, line[index + 1].row] = curTile
                    
                    resCnt++
                    // и идём двигать следующую клетку (реккурсивно)
                    resCnt += moveTilesInLine(line, startAt: index + 1)
                }
            }
        }
        return resCnt
    }

   
    //** Сложение одинаковых тайлов в линии */
    func mergeTilesInLine(line: [M2DPosition], startAt ind: Int = -1) -> Int {
        var resCnt = 0
        let index = ind == -1 ? line.count - 1 : ind // линию проходим в обратном порядке
        
        // если не последняя ячейка, иначе - выход из реккурсии
        if index > 0 {
            
            // если текущая клетка не пустая и значение равно следующей - объединяем их
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
                    
                    // анимация
                    curTile.runAction(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.2), SKAction.scaleTo(1, duration: 0.2)]))
                    
                    resCnt++
                    // и идём на следующую клетку (рекурсивно)
                    resCnt += mergeTilesInLine(line, startAt: index - 2)
                    
            } else {
                // иначе - идём рекурсивно на следующую клетку
                resCnt = mergeTilesInLine(line, startAt: index - 1)
            }
        }
        return resCnt
    }


    //** STEP - шаг игры
    func step(direction: UISwipeGestureRecognizerDirection) {
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
            setRandomTile()
        }
        
    }
    
    
}
