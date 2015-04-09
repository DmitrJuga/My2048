//
//  Tile.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

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
    
    mutating func empty() {
        let newTR = TileRelationship(tile: getNumberValue().tile, value: 0)
        self = .Number(newTR)
        //newTR.notify()
    }
    
    func getNumberValue() -> TileRelationship {
        switch self {
        case let .Number(value):
            return value
        }
    }
}

// Helper
struct TileRelationship {
    
    let tile: TileDelegate // View
    let value: Int
    
    func notify() {
        tile.updateLabel(value)
    }
}

protocol TileDelegate {
    func updateLabel(value: Int)
}



class Tile: SKSpriteNode, TileDelegate {
    
    var state: TileState!

    private let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    /** Constructor */
    init() {
        let nodeColor = UIColor(hex: config.TILE_PARAMS[0]!.tileColor)
        let nodeSize = CGSize(width: config.TILE_SIZE, height: config.TILE_SIZE)
        super.init(texture: nil, color: nodeColor, size: nodeSize)

        // init Model
        state = TileState.Number(TileRelationship(tile: self, value: 0))
        state.getNumberValue().notify()
    }
    
    /** апдейт значения ячейки */
    func updateLabel(value: Int) {
        self.color = UIColor(hex: config.TILE_PARAMS[value]!.tileColor)
        if value != 0 {
            let label = SKLabelNode()
            label.fontName = config.TILE_FONT_NAME
            label.fontSize = CGFloat(config.TILE_PARAMS[value]!.fontSize)
            label.fontColor = UIColor(hex: config.TILE_PARAMS[value]!.fontColor)
            label.text = String(value)
            label.position = CGPoint(x: CGRectGetMidX(label.frame) * -1,
                                     y: CGRectGetMidY(label.frame) * -1)
            self.addChild(label)
        } else {
            //self.removeAllChildren()
        }
    }

}