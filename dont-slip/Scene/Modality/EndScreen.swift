//
//  HomeScreen.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 19/06/24.
//

import Foundation

import GameplayKit
import SpriteKit

extension UIImage { // buat kasi warna ke SF Font
    func withTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(origin: .zero, size: self.size)
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage ?? self
    }
}

extension GameScene {
    
    // Modality Game Over
        func showGameOverModal() {
            
            // Create background node to darken the screen
            modalBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: self.size)
            modalBackground.position = CGPoint(x: 0, y: 0)
            modalBackground.zPosition = 200
            addChild(modalBackground)
            
            // Biggest Container
            bigContainer = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.65))
            bigContainer.position = CGPoint(x: 0, y: 0)
            bigContainer.zPosition = 200
            addChild(bigContainer)
            
            // Create modal main content container
            modalContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: self.size.width * 0.5, height: self.size.height * 0.5))
            modalContainer.position = CGPoint(x: 0, y: (bigContainer.size.height - self.size.height * 0.5) / 2)
            modalContainer.zPosition = 201
            bigContainer.addChild(modalContainer)
            
            blueModalBackground = SKSpriteNode(color: UIColor.biruButton, size: CGSize(width: modalContainer.size.width * 1.05, height: modalContainer.size.height * 1.08))
            blueModalBackground.position = CGPoint(x: 0, y: (bigContainer.size.height - self.size.height * 0.5) / 2)
            blueModalBackground.zPosition = 200
            addChild(blueModalBackground)
            
            // Create button Container
            buttonContainer = SKSpriteNode(color: .clear, size: CGSize(width: bigContainer.self.size.width, height: self.size.height * 0.13))
            buttonContainer.position = CGPoint(x: 0, y: -(bigContainer.size.height - self.size.height * 0.1) / 2)
            buttonContainer.zPosition = 201
            bigContainer.addChild(buttonContainer)
            
            // "Game Over" label
//            gameOverLabel = SKLabelNode(text: "GAME OVER")
//            gameOverLabel.fontSize = 126
//            gameOverLabel.fontColor = .white
//            gameOverLabel.fontName = "Madness Hyperactive"
//            gameOverLabel.position = CGPoint(x: 0, y: modalContainer.size.height / 7)
//            gameOverLabel.zPosition = 202
//            modalContainer.addChild(gameOverLabel)
            gameOverLabel = SKSpriteNode(imageNamed: "Game Over 1")
            gameOverLabel.size = CGSize(width: 400, height: 110)
            gameOverLabel.position = CGPoint(x: 0, y: modalContainer.size.height / 4)
            gameOverLabel.zPosition = 202
            modalContainer.addChild(gameOverLabel)
            
            scoreCoinContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: modalContainer.size.width * 0.7, height: modalContainer.size.height * 0.5))
            scoreCoinContainer.position = CGPoint(x: 0, y: -75)
            scoreCoinContainer.zPosition = 202
            modalContainer.addChild(scoreCoinContainer)
            
            scoreContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
            scoreContainer.position = CGPoint(x: -125, y: 0)
            scoreContainer.zPosition = 203
            scoreCoinContainer.addChild(scoreContainer)
            
            // Create and configure score label
            gameOverScoreLabel = SKLabelNode(text: "Score")
            gameOverScoreLabel.fontSize = 46
            gameOverScoreLabel.fontColor = .black
            gameOverScoreLabel.fontName = "AlegreyaSansSC-Medium"
            gameOverScoreLabel.position = CGPoint(x: 0, y: 60)
            gameOverScoreLabel.zPosition = 204
            scoreContainer.addChild(gameOverScoreLabel)
            
//            let strokeLabel = SKLabelNode(text: "\(score)")
//            strokeLabel.fontSize = 60
//            strokeLabel.fontColor = .white // Stroke color
//            strokeLabel.fontName = "AlegreyaSansSC-Bold"
//            strokeLabel.position = CGPoint(x: 0, y: -10)
//            strokeLabel.zPosition = 203 // One layer below the main label
//
//            // Set a larger font size to simulate the stroke
//            strokeLabel.run(SKAction.sequence([
//                SKAction.scale(to: 1.1, duration: 0),
//                SKAction.colorize(with: .black, colorBlendFactor: 0, duration: 0) // Fixing the color bleeding
//            ]))
            
            scoreGameOverLabel = SKLabelNode(text: "\(score)")
            scoreGameOverLabel.fontSize = 60
            scoreGameOverLabel.fontColor = .black
            scoreGameOverLabel.fontName = "AlegreyaSansSC-Bold"
            scoreGameOverLabel.position = CGPoint(x: 0, y: -10)
            scoreGameOverLabel.zPosition = 204
            scoreContainer.addChild(scoreGameOverLabel)
            //scoreContainer.addChild(strokeLabel)
            
            highScoreGameOverLabel = SKLabelNode(text: "HIGHSCORE")
            highScoreGameOverLabel.fontName = "AlegreyaSansSC-Medium"
            highScoreGameOverLabel.fontSize = 30
            highScoreGameOverLabel.fontColor = .black
            highScoreGameOverLabel.position = CGPoint(x: 0, y: -60)
            highScoreGameOverLabel.zPosition = 204
            scoreContainer.addChild(highScoreGameOverLabel)
            
            totalHighScoreLabel = SKLabelNode(text: "\(highScore)")
            totalHighScoreLabel.fontName = "AlegreyaSansSC-ExtraBold"
            totalHighScoreLabel.fontSize = 30
            totalHighScoreLabel.fontColor = .black
            totalHighScoreLabel.position = CGPoint(x: 0, y: -90)
            totalHighScoreLabel.zPosition = 204
            scoreContainer.addChild(totalHighScoreLabel)
            
            
            // ----------------------------asdfasfsasafsafsafsafsa------------------------------------
            
            coinContainer = SKSpriteNode(color: UIColor.brownn, size: CGSize(width: scoreCoinContainer.size.width * 0.4, height: scoreCoinContainer.size.height * 0.9))
            coinContainer.position = CGPoint(x: 125, y: 0)
            coinContainer.zPosition = 203
            scoreCoinContainer.addChild(coinContainer)
            
            // Create and configure coins label
            gameOverCoinsLabel = SKLabelNode(text: "Coin")
            gameOverCoinsLabel.fontName = "AlegreyaSansSC-Medium"
            gameOverCoinsLabel.fontSize = 46
            gameOverCoinsLabel.fontColor = .black
            gameOverCoinsLabel.position = CGPoint(x: 0, y: 60)
            gameOverCoinsLabel.zPosition = 204
            coinContainer.addChild(gameOverCoinsLabel)
            
            coinGameOverLabel = SKLabelNode(text: "+ \(coinsCollected)")
            coinGameOverLabel.fontName = "AlegreyaSansSC-Bold"
            coinGameOverLabel.fontSize = 60
            coinGameOverLabel.fontColor = .black
            coinGameOverLabel.position = CGPoint(x: 0, y: -10)
            coinGameOverLabel.zPosition = 204
            coinContainer.addChild(coinGameOverLabel)
            
            let labelwidth = coinGameOverLabel.frame.width
            
            coinImgOver = SKSpriteNode(imageNamed: "Coin")
            coinImgOver.size = CGSize(width: 40, height: 40)
            coinImgOver.position = CGPoint(x: labelwidth / 2 + 30, y: 7)
            coinImgOver.zPosition = 204
            coinContainer.addChild(coinImgOver)
            
            totalLabel = SKLabelNode(text: "TOTAL")
            totalLabel.fontName = "AlegreyaSansSC-Medium"
            totalLabel.fontSize = 30
            totalLabel.fontColor = .black
            totalLabel.position = CGPoint(x: 0, y: -60)
            totalLabel.zPosition = 204
            coinContainer.addChild(totalLabel)
            
            totalCoinsGameOverLabel = SKLabelNode(text: "\(totalCoins)")
            totalCoinsGameOverLabel.fontName = "AlegreyaSansSC-ExtraBold"
            totalCoinsGameOverLabel.fontSize = 30
            totalCoinsGameOverLabel.fontColor = .black
            totalCoinsGameOverLabel.position = CGPoint(x: 0, y: -90)
            totalCoinsGameOverLabel.zPosition = 204
            coinContainer.addChild(totalCoinsGameOverLabel)
            
            let label2width = totalCoinsGameOverLabel.frame.width
            coinImgOver2 = SKSpriteNode(imageNamed: "Coin")
            coinImgOver2.size = CGSize(width: 20, height: 20)
            coinImgOver2.position = CGPoint(x: label2width / 2 + 15, y: -80)
            coinImgOver2.zPosition = 204
            coinContainer.addChild(coinImgOver2)
            
            // Create restart button
            restartButton = SKSpriteNode(color: .brownn, size: CGSize(width: 315, height: buttonContainer.size.height))
            restartButton.position = CGPoint(x: buttonContainer.size.width / 2 - restartButton.size.width / 2, y: 0)
            restartButton.zPosition = 201
            restartButton.name = "restartButton"
            buttonContainer.addChild(restartButton)

            // Create a rectangle border
            let borderSize2 = CGSize(width: restartButton.size.width - 20, height: restartButton.size.height - 20) // Adjust the size for the border thickness
            let borderRect2 = CGRect(origin: CGPoint(x: -borderSize2.width / 2, y: -borderSize2.height / 2), size: borderSize2)
            let borderPath2 = CGPath(rect: borderRect2, transform: nil)

            let borderNode2 = SKShapeNode(path: borderPath2)
            borderNode2.strokeColor = .biruButton // Set the border color
            borderNode2.lineWidth = 4 // Set the border thickness

            // Add the borderNode as a child to the homeButton
            restartButton.addChild(borderNode2)
            
            let boldConfig = UIImage.SymbolConfiguration(weight: .heavy)
            
            // Add a restart label to the button
            let symbolName = "arrow.counterclockwise" // Replace with your desired SF Symbol name
            if var symbolImage = UIImage(systemName: symbolName, withConfiguration: boldConfig) {
                symbolImage = symbolImage.withTintColor(.biruButton)
                // Convert the image to a texture
                let texture = SKTexture(image: symbolImage)
                
                // Create an SKSpriteNode with the texture
                let symbolNode = SKSpriteNode(texture: texture)
                symbolNode.size = CGSize(width: 35, height: 40) // Set the desired size
                symbolNode.position = CGPoint(x: 0, y: 0)
                symbolNode.zPosition = 202

                // Add the symbol node to the restart button
                restartButton.addChild(symbolNode)
            } else {
                print("Failed to create SF Symbol image.")
            }
            
            // Create home button (belom bisa ke home page)
            homeButton = SKSpriteNode(color: .brownn, size: CGSize(width: 315, height: buttonContainer.size.height))
            homeButton.position = CGPoint(x: -buttonContainer.size.width / 2 + restartButton.size.width / 2, y: 0)
            homeButton.zPosition = 201
            homeButton.name = "homeButton"
            buttonContainer.addChild(homeButton)
            
            // Create a rectangle border
            let borderSize = CGSize(width: homeButton.size.width - 20, height: homeButton.size.height - 20) // Adjust the size for the border thickness
            let borderRect = CGRect(origin: CGPoint(x: -borderSize.width / 2, y: -borderSize.height / 2), size: borderSize)
            let borderPath = CGPath(rect: borderRect, transform: nil)

            let borderNode = SKShapeNode(path: borderPath)
            borderNode.strokeColor = .biruButton // Set the border color
            borderNode.lineWidth = 4 // Set the border thickness

            // Add the borderNode as a child to the homeButton
            homeButton.addChild(borderNode)
            
            // Add a home label to the button
            
            let symbolName2 = "house.fill" // Replace with your desired SF Symbol name
            if var symbolImage2 = UIImage(systemName: symbolName2, withConfiguration: boldConfig) {
                symbolImage2 = symbolImage2.withTintColor(.biruButton)
                // Convert the image to a texture
                let texture2 = SKTexture(image: symbolImage2)
                
                // Create an SKSpriteNode with the texture
                let symbolNode2 = SKSpriteNode(texture: texture2)
                symbolNode2.size = CGSize(width: 50, height: 40) // Set the desired size
                symbolNode2.position = CGPoint(x: 0, y: 0)
                symbolNode2.zPosition = 202
             
                // Add the symbol node to the restart button
                homeButton.addChild(symbolNode2)
            } else {
                print("Failed to create SF Symbol image.")
            }
        }
}
