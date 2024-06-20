//
//  HomeScreen.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 19/06/24.
//

import Foundation

import GameplayKit
import SpriteKit

extension GameScene {
    
    // Modality Game Over
        func showGameOverModal() {
            
            // Create background node to darken the screen
            modalBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: self.size)
            modalBackground.position = CGPoint(x: 0, y: 0)
            modalBackground.zPosition = 200
            addChild(modalBackground)
            
            // Biggest Container
            bigContainer = SKSpriteNode(color: UIColor.gray, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.65))
            bigContainer.position = CGPoint(x: 0, y: 0)
            bigContainer.zPosition = 200
            addChild(bigContainer)
            
            // Create modal main content container
            modalContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.5))
            modalContainer.position = CGPoint(x: 0, y: (bigContainer.size.height - self.size.height * 0.5) / 2)
            modalContainer.zPosition = 201
            bigContainer.addChild(modalContainer)
            
            // Create button Container
            buttonContainer = SKSpriteNode(color: UIColor.purple, size: CGSize(width: bigContainer.self.size.width, height: self.size.height * 0.1))
            buttonContainer.position = CGPoint(x: 0, y: -(bigContainer.size.height - self.size.height * 0.1) / 2)
            buttonContainer.zPosition = 201
            bigContainer.addChild(buttonContainer)
            
            // "Game Over" label
            gameOverLabel = SKLabelNode(text: "GAME OVER")
            gameOverLabel.fontSize = 70
            gameOverLabel.fontColor = .white
            gameOverLabel.fontName = "Madness Hyperactive"
            gameOverLabel.position = CGPoint(x: 0, y: modalContainer.size.height / 4)
            gameOverLabel.zPosition = 202
            modalContainer.addChild(gameOverLabel)
            
            scoreCoinContainer = SKSpriteNode(color: UIColor.red, size: CGSize(width: modalContainer.size.width * 0.7, height: modalContainer.size.height * 0.6))
            scoreCoinContainer.position = CGPoint(x: 0, y: -50)
            scoreCoinContainer.zPosition = 202
            modalContainer.addChild(scoreCoinContainer)
            
            scoreContainer = SKSpriteNode(color: UIColor.blue, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
            scoreContainer.position = CGPoint(x: -125, y: 0)
            scoreContainer.zPosition = 203
            scoreCoinContainer.addChild(scoreContainer)
            
            // Create and configure score label
            gameOverScoreLabel = SKLabelNode(text: "Score")
            gameOverScoreLabel.fontSize = 36
            gameOverScoreLabel.fontColor = .white
            gameOverScoreLabel.fontName = "AlegreyaSansSC-Medium"
            gameOverScoreLabel.position = CGPoint(x: 0, y: 60)
            gameOverScoreLabel.zPosition = 204
            scoreContainer.addChild(gameOverScoreLabel)
            
            scoreGameOverLabel = SKLabelNode(text: "\(score)")
            scoreGameOverLabel.fontSize = 50
            scoreGameOverLabel.fontColor = .white
            scoreGameOverLabel.fontName = "AlegreyaSansSC-Bold"
            scoreGameOverLabel.position = CGPoint(x: 0, y: -10)
            scoreGameOverLabel.zPosition = 204
            scoreContainer.addChild(scoreGameOverLabel)
            
            highScoreGameOverLabel = SKLabelNode(text: "HIGHSCORE")
            highScoreGameOverLabel.fontName = "AlegreyaSansSC-Medium"
            highScoreGameOverLabel.fontSize = 20
            highScoreGameOverLabel.fontColor = .white
            highScoreGameOverLabel.position = CGPoint(x: 0, y: -50)
            highScoreGameOverLabel.zPosition = 204
            scoreContainer.addChild(highScoreGameOverLabel)
            
            totalHighScoreLabel = SKLabelNode(text: "\(highScore)")
            totalHighScoreLabel.fontName = "AlegreyaSansSC-ExtraBold"
            totalHighScoreLabel.fontSize = 20
            totalHighScoreLabel.fontColor = .white
            totalHighScoreLabel.position = CGPoint(x: 0, y: -80)
            totalHighScoreLabel.zPosition = 204
            scoreContainer.addChild(totalHighScoreLabel)
            
            
            // ----------------------------asdfasfsasafsafsafsafsa------------------------------------
            
            coinContainer = SKSpriteNode(color: UIColor.blue, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
            coinContainer.position = CGPoint(x: 125, y: 0)
            coinContainer.zPosition = 203
            scoreCoinContainer.addChild(coinContainer)
            
            // Create and configure coins label
            gameOverCoinsLabel = SKLabelNode(text: "Coin")
            gameOverCoinsLabel.fontName = "AlegreyaSansSC-Medium"
            gameOverCoinsLabel.fontSize = 36
            gameOverCoinsLabel.fontColor = .white
            gameOverCoinsLabel.position = CGPoint(x: 0, y: 60)
            gameOverCoinsLabel.zPosition = 204
            coinContainer.addChild(gameOverCoinsLabel)
            
            coinGameOverLabel = SKLabelNode(text: "+ \(coinsCollected)")
            coinGameOverLabel.fontName = "AlegreyaSansSC-Bold"
            coinGameOverLabel.fontSize = 50
            coinGameOverLabel.fontColor = .white
            coinGameOverLabel.position = CGPoint(x: 0, y: -10)
            coinGameOverLabel.zPosition = 204
            coinContainer.addChild(coinGameOverLabel)
            
            totalLabel = SKLabelNode(text: "TOTAL")
            totalLabel.fontName = "AlegreyaSansSC-Medium"
            totalLabel.fontSize = 20
            totalLabel.fontColor = .white
            totalLabel.position = CGPoint(x: 0, y: -50)
            totalLabel.zPosition = 204
            coinContainer.addChild(totalLabel)
            
            totalCoinsGameOverLabel = SKLabelNode(text: "\(totalCoins)")
            totalCoinsGameOverLabel.fontName = "AlegreyaSansSC-ExtraBold"
            totalCoinsGameOverLabel.fontSize = 20
            totalCoinsGameOverLabel.fontColor = .white
            totalCoinsGameOverLabel.position = CGPoint(x: 0, y: -80)
            totalCoinsGameOverLabel.zPosition = 204
            coinContainer.addChild(totalCoinsGameOverLabel)
            
            // Create restart button
            restartButton = SKSpriteNode(color: .red, size: CGSize(width: 300, height: buttonContainer.size.height))
            restartButton.position = CGPoint(x: buttonContainer.size.width / 2 - restartButton.size.width / 2, y: 0)
            restartButton.zPosition = 201
            restartButton.name = "restartButton"
            buttonContainer.addChild(restartButton)
            
            // Add a restart label to the button
            let restartLabel = SKLabelNode(text: "Restart")
            restartLabel.fontSize = 24
            restartLabel.fontColor = .white
            restartLabel.position = CGPoint(x: 0, y: -restartLabel.frame.size.height / 2)
            restartLabel.zPosition = 202
            restartButton.addChild(restartLabel)
            
            // Create home button (belom bisa ke home page)
            homeButton = SKSpriteNode(color: .red, size: CGSize(width: 300, height: buttonContainer.size.height))
            homeButton.position = CGPoint(x: -buttonContainer.size.width / 2 + restartButton.size.width / 2, y: 0)
            homeButton.zPosition = 201
            homeButton.name = "homeButton"
            buttonContainer.addChild(homeButton)
            
            // Add a home label to the button
            let homeLabel = SKLabelNode(text: "Home")
            homeLabel.fontSize = 24
            homeLabel.fontColor = .white
            homeLabel.position = CGPoint(x: 0, y: -restartLabel.frame.size.height / 2)
            homeLabel.zPosition = 202
            homeButton.addChild(homeLabel)
        }
}
