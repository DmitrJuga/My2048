//
//  Tile.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {
    
    var value: Int = 0

    private let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    /** Constructor */
    init() {
        let nodeColor = UIColor(hex: config.TILE_PARAMS[0]!.tileColor)
        let nodeSize = CGSize(width: config.TILE_SIZE, height: config.TILE_SIZE)
        super.init(texture: nil, color: nodeColor, size: nodeSize)
    }
    
    // установка значения в ячейку
    func setTileValue(newValue: Int) {
        if newValue != 0 {
            self.value = newValue
            self.color = UIColor(hex: config.TILE_PARAMS[newValue]!.tileColor)
            let label = SKLabelNode()
            label.fontName = config.TILE_FONT_NAME
            label.fontSize = CGFloat(config.TILE_PARAMS[newValue]!.fontSize)
            label.fontColor = UIColor(hex: config.TILE_PARAMS[newValue]!.fontColor)
            label.text = String(newValue)
            label.position = CGPoint(x: CGRectGetMidX(label.frame) * -1,
                                     y: CGRectGetMidY(label.frame) * -1)
            self.addChild(label)
        } else {
            clearTileValue()
        }
    }
    
    // очистка ячейки
    func clearTileValue() {
        self.value = 0
        self.color = UIColor(hex: config.TILE_PARAMS[0]!.tileColor)
        self.removeAllChildren()
    }
    
}