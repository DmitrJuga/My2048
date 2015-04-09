//
//  GameScene.swift
//  My2048
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
        let board = Board()
    
        override func didMoveToView(view: SKView) {
            let config = Config.defaultConfig
            self.backgroundColor = UIColor(hex: config.BACKGROUNG_COLOR)
            board.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            addChild(board)
        }
        
        override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
            /* Called when a touch begins */
            
            for touch in (touches as! Set<UITouch>) {
                let location = touch.locationInNode(self)
                board.step()
                //println("touchesBegan")
            }
            
        }
        
        override func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
        }
}
