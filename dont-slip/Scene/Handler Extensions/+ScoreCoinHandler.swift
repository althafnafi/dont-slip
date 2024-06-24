//
//  CoinHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }
    
    func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }
    
    func saveCoins(){
        UserDefaults.standard.set(totalCoins, forKey: "TotalCoins")
    }
    
    func loadCoins(){
        totalCoins = UserDefaults.standard.integer(forKey: "TotalCoins")
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func startScoreTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let incrementScore = SKAction.run { [weak self] in
            self?.incrementScore()
        }
        let sequence = SKAction.sequence([wait, incrementScore])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "scoreTimer")
    }
    
    func setupPointsLabel() {
        pointsLabel = SKLabelNode(text: "Coins: \(self.coinsCollected)")
        pointsLabel.fontSize = 58
        pointsLabel.fontColor = .white
        pointsLabel.fontName = "AlegreyaSansSC-Medium"
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .top
        pointsLabel.position = CGPoint(x: 400, y: self.size.height / 2 - 100)
        pointsLabel.zPosition = 100
        
        addChild(pointsLabel)
        
        // Setup Total Coin Label
//        totalCoinsLabel = SKLabelNode(text: "Total Coins: \(totalCoins)")
//        totalCoinsLabel.fontSize = 48
//        totalCoinsLabel.fontColor = .yellow
//        totalCoinsLabel.horizontalAlignmentMode = .center
//        totalCoinsLabel.verticalAlignmentMode = .top
//        totalCoinsLabel.position = CGPoint(x: 0, y: -150)
//        totalCoinsLabel.zPosition = 100
        
        //addChild(totalCoinsLabel)
    }
    
    func setupScoreLabels() {
        // Setup Score Label
        scoreLabel = SKLabelNode(text: "\(score)")
        scoreLabel.fontSize = 58
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "AlegreyaSansSC-Medium"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 100)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        // Setup High Score Label
//        highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
//        highScoreLabel.fontSize = 48
//        highScoreLabel.fontColor = .yellow
//        highScoreLabel.horizontalAlignmentMode = .center
//        highScoreLabel.verticalAlignmentMode = .top
//        highScoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 150)
//        highScoreLabel.zPosition = 100
       // addChild(highScoreLabel)
    }
    
    
    func updatePointsLabel() {
        pointsLabel.text = "Coins: \(self.coinsCollected)"
    
        
    }
    
}
