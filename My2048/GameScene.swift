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
        
        board.position = CGPoint(x: CGRectGetMidX(frame) - CGRectGetMidX(board.frame),
                                 y: CGRectGetMidY(frame) - CGRectGetMidY(board.frame))
        addChild(board)

        addSwipeRecognizers(view)
    }
    
    //** Добавляем распознование свайпов */
    func addSwipeRecognizers(view: SKView) {
        let dirs: [UISwipeGestureRecognizerDirection] = [.Up, .Down, .Right, .Left]
        for d in dirs {
            let r = UISwipeGestureRecognizer(target: self, action: "swipeHandler:")
            r.direction = d
            view.addGestureRecognizer(r)
        }
    }

    //** Обработчик свайпов */
    func swipeHandler(sender:UISwipeGestureRecognizer){
        board.step(sender.direction)
    }

}
