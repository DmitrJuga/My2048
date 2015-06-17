//
//  Tile.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

// MARK: - TileState
// Model / State Machine
enum TileState {
    
    case Number(TileRelationship)
    
    mutating func next() {
        let oldTR = getNumberValue()
        let newValue = oldTR.value != 0 ? oldTR.value * 2 : (arc4random_uniform(10) < 9 ? 2 : 4)
        let newTR = TileRelationship(tile: oldTR.tile, value: newValue)
        self = .Number(newTR)
        newTR.notify()
    }
    
    mutating func clear() {
        let newTR = TileRelationship(tile: getNumberValue().tile, value: 0)
        self = .Number(newTR)
        newTR.notify()
    }
    
    func getNumberValue() -> TileRelationship {
        switch self {
        case let .Number(value):
            return value
        }
    }
}


// MARK: - TileRelationship
// Helper
struct TileRelationship {
    let tile: TileDelegate // View

    let value: Int
    
    func notify() {
        tile.updateLabel(value)
    }
}


// MARK: - TileDelegate
protocol TileDelegate {
    func updateLabel(value: Int)
}


// MARK: - TILE
class Tile: SKShapeNode, TileDelegate {
    
    var state: TileState!
    let label = SKLabelNode(fontNamed: Config.defaultConfig.TILE_FONT_NAME)

    private let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    /** Constructor */
    override init() {
        super.init()
        
        // настройка формы и размера
        let halfSize = config.TILE_SIZE / 2
        let nodeRect = CGRectMake(-halfSize, -halfSize, config.TILE_SIZE, config.TILE_SIZE);
        self.path = CGPathCreateWithRoundedRect(nodeRect, config.CORNER_RADIUS, config.CORNER_RADIUS, nil)
        self.addChild(label)
        
        // init Model
        state = TileState.Number(TileRelationship(tile: self, value: 0))
        state.getNumberValue().notify()
    }
    
    /** апдейт значения ячейки */
    func updateLabel(value: Int) {
        self.fillColor = UIColor(hex: config.TILE_PARAMS[value]!.tileColor)
        self.strokeColor = self.fillColor

        if value != 0 {
            label.fontName = config.TILE_FONT_NAME
            label.fontSize = CGFloat(config.TILE_PARAMS[value]!.fontSize)
            label.fontColor = UIColor(hex: config.TILE_PARAMS[value]!.fontColor)
            label.text = String(value)
            label.position = CGPoint(x: 0, y: -label.frame.height / 2)
        } else {
            label.text = ""
        }
    }

}