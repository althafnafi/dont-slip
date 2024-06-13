//
//  Labels.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    
    func setupPointsLabel() {
        pointsLabel = SKLabelNode(text: "Coins: \(self.coinsCollected)")
        pointsLabel.fontSize = 48
        pointsLabel.fontColor = .white
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .top
        pointsLabel.position = CGPoint(x: 0, y: -100)
        pointsLabel.zPosition = 100
        
        addChild(pointsLabel)
        
        // Setup Total Coin Label
        totalCoinsLabel = SKLabelNode(text: "Total Coins: \(totalCoins)")
        totalCoinsLabel.fontSize = 48
        totalCoinsLabel.fontColor = .yellow
        totalCoinsLabel.horizontalAlignmentMode = .center
        totalCoinsLabel.verticalAlignmentMode = .top
        totalCoinsLabel.position = CGPoint(x: 0, y: -150)
        totalCoinsLabel.zPosition = 100
        
        addChild(totalCoinsLabel)
    }
    
    func setupScoreLabels() {
        // Setup Score Label
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 100)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)

        // Setup High Score Label
        highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
        highScoreLabel.fontSize = 48
        highScoreLabel.fontColor = .yellow
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .top
        highScoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 150)
        highScoreLabel.zPosition = 100
        addChild(highScoreLabel)
    }

    
    func updatePointsLabel() {
        pointsLabel.text = "Coins: \(self.coinsCollected)"
    }
}
