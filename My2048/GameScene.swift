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

    override func didMove(to view: SKView) {
        let config = Config.defaultConfig
        self.backgroundColor = UIColor(hex: config.BACKGROUNG_COLOR)
        
        board.position = CGPoint(x: frame.midX - board.frame.midX,
                                 y: frame.midY - board.frame.midY)
        addChild(board)

        addSwipeRecognizers(view)
    }
    
    // ** Add recognizing swipe * /
    func addSwipeRecognizers(_ view: SKView) {
        let dirs: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        for d in dirs {
            let r = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeHandler(_:)))
            r.direction = d
            view.addGestureRecognizer(r)
        }
    }

    // ** The swipe handler * /
    func swipeHandler(_ sender:UISwipeGestureRecognizer){
        board.step(sender.direction)
    }

}
