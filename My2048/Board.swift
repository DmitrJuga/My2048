//
//  Board.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

class Board: SKSpriteNode {
    
    var field = Matrix<Tile>(columns: Config.defaultConfig.GRID_SIZE,
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
        /*
        // Вывести все варианты тайлов
        field[0, 0]?.setTileValue(2)
        field[0, 1]?.setTileValue(4)
        field[0, 2]?.setTileValue(8)
        field[0, 3]?.setTileValue(16)
        field[1, 0]?.setTileValue(32)
        field[1, 1]?.setTileValue(64)
        field[1, 2]?.setTileValue(128)
        field[1, 3]?.setTileValue(256)
        field[2, 0]?.setTileValue(512)
        field[2, 1]?.setTileValue(1024)
        field[2, 2]?.setTileValue(2048) 
        */
    }
    
    // Установка случайного свободного тайла в значения 2 или 4
    func setRandomTile() {
        let rnd = arc4random_uniform(10)
        let value = rnd < 6 ? 2 : 4 // задаём больше вероятность появления 2
        if let pos = getRandomPosition() {
            field[pos.column, pos.row]?.setTileValue(value)
        }
    }
    
    // Возвращает массив индексов (column, row) всех свободных позиций
    func getAvailableCells() -> [(Int, Int)] {
        var arr = [(Int, Int)]()
        for col in 0..<field.rows {
            for row in 0..<field.columns {
                if field[col, row]?.value == 0 {
                    arr.append((col, row))
                }
            }
        }
        return arr
    }
    
    // Возвращает индекс (column, row) случайной свободной позиции
    func getRandomPosition() -> (column: Int, row: Int)? {
        let cells = getAvailableCells()
        if cells.count > 0 {
            return cells[Int(arc4random_uniform(UInt32(cells.count)))]
        } else {
            return nil
        }
    }
    
    
    // Fabric method - Создание тайла
    func createTile(#column: Int, row: Int) -> Tile {
        let t = Tile()
        let offset = CGFloat(config.BOARD_SIZE / 2  - config.TILE_SIZE / 2 - config.TILE_GAP)
        let tileSpace = config.TILE_SIZE + config.TILE_GAP
        t.position = CGPoint(x: CGFloat(column) * tileSpace - offset,
                             y: offset - CGFloat(row) * tileSpace)
        return t
    }
    
}
