//
//  Config.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

struct Config {
    
    // Singleton
    static let defaultConfig = Config()
    private init() {}
    
    let BACKGROUNG_COLOR = 0xFBF8EF
    let BOARD_COLOR = 0xBBADA0
    let GRID_SIZE = 4
    let TILE_SIZE: CGFloat = 64
    let TILE_GAP: CGFloat = 8
    let TILE_FONT_NAME = "Arial Bold"
    var BOARD_SIZE: CGFloat {
        return CGFloat((TILE_SIZE + TILE_GAP) * CGFloat(GRID_SIZE) + TILE_GAP)
    }
    let TILE_PARAMS =  [0: (tileColor: 0xCCC0B4, fontColor: 0x646464, fontSize: 36),
                        2: (tileColor: 0xEEE4DA, fontColor: 0x646464, fontSize: 36),
                        4: (tileColor: 0xEFE0C8, fontColor: 0x646464, fontSize: 36),
                        8: (tileColor: 0xF2B179, fontColor: 0xFDFDFD, fontSize: 36),
                        16: (tileColor: 0xEC8E53, fontColor: 0xFDFDFD, fontSize: 36),
                        32: (tileColor: 0xF57C5F, fontColor: 0xFDFDFD, fontSize: 36),
                        64: (tileColor: 0xE95937, fontColor: 0xFDFDFD, fontSize: 36),
                        128: (tileColor: 0xF3D96B, fontColor: 0xFDFDFD, fontSize: 32),
                        256: (tileColor: 0xF1D14B, fontColor: 0xFDFDFD, fontSize: 32),
                        512: (tileColor: 0xE4C129, fontColor: 0xFDFDFD, fontSize: 32),
                        1024: (tileColor: 0xE35611, fontColor: 0xFDFDFD, fontSize: 26),
                        2048: (tileColor: 0xECC500, fontColor: 0xFDFDFD, fontSize: 26)]
}