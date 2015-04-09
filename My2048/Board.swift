//
//  Board.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

class Board: SKSpriteNode {
    
    var field = Matrix2D<Tile>(columns: Config.defaultConfig.GRID_SIZE,
                                  rows: Config.defaultConfig.GRID_SIZE)

    private let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    /** Constructor */
    init() {
        let nodeColor = UIColor(hex: config.BOARD_COLOR)
        let nodeSize = CGSize(width: config.BOARD_SIZE, height: config.BOARD_SIZE)
        super.init(texture: nil, color: nodeColor, size: nodeSize)
 
        for col in 0..<field.rows {
            for row in 0..<field.columns {
                let emptyTile = createTile(column: col, row: row)
                field[col, row] = emptyTile
                addChild(emptyTile)
            }
        }
        setRandomTile()
        setRandomTile()
    }
    
    func step() {
        setRandomTile()
    }
    
    /** Установка случайного свободного тайла в непустое значение */
    func setRandomTile() {
        if let pos = getRandomPosition() {
            field[pos.column, pos.row]?.state.next()
        }
    }
    
    
    /** Возвращает индекс (column, row) случайной свободной позиции */
    func getRandomPosition() -> (column: Int, row: Int)? {
        let emptyCells = field.getEmpties{ ($0! as Tile).state.getNumberValue().value == 0 }
        if emptyCells.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(emptyCells.count)))
            return emptyCells[randIndex]
        } else {
            return nil
        }
    }
    
    
    /** Fabric method - Создание тайла */
    func createTile(#column: Int, row: Int) -> Tile {
        let t = Tile()
        let offset = CGFloat(config.BOARD_SIZE / 2  - config.TILE_SIZE / 2 - config.TILE_GAP)
        let tileSpace = config.TILE_SIZE + config.TILE_GAP
        t.position = CGPoint(x: CGFloat(column) * tileSpace - offset,
                             y: offset - CGFloat(row) * tileSpace)
        return t
    }
    
}
