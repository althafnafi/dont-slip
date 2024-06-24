//
//  SpawnHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

extension GameScene {
    
    // Generic spawner functions
    func randomlySpawnObjects(spawnerFunction: @escaping () -> Void, interval: TimeInterval) {
        let wait = SKAction.wait(forDuration: interval)
        let spawn = SKAction.run {
            spawnerFunction()
        }
        let sequence = SKAction.sequence([wait, spawn])
        run(SKAction.repeatForever(sequence))
    }
    
    // MARK: Obstacles
    
    func spawnObstacle() {
        if gameOver {
            return  // Stop spawning new objects
        }
        // Define obstacle parameters
        let obstacleType = ObstacleType.allCases[Int.random(in: 0 ..< ObstacleType.allCases.count)]
        
        let icebergWidth = icebergStateSystem.currentIcebergWdith
        
        let randomXPos = CGFloat.random(in: -icebergWidth / 2...icebergWidth/2)
        
        let yPos = CGFloat(self.size.height)
        let spawnPos = CGPoint(x: randomXPos, y: yPos)
        // Make the Obstacle entity
        let obstacle = Obstacle(type: obstacleType, spawnPos: spawnPos, entityManager: entityManager, massMultiplier: obstacleMassMultiplier)
        entityManager.add(obstacle)
        // Add obstacle to entity manager
    }
    
    func spawnIceFuel() {
        if gameOver {
            return  // Stop spawning new objects
        }
        
        let icebergWidth = icebergStateSystem.currentIcebergWdith
        
        let randomXPos = CGFloat.random(in: -icebergWidth / 2...icebergWidth/2)
        
        let yPos = CGFloat(self.size.height)
        let spawnPos = CGPoint(x: randomXPos, y: yPos)
        
        let iceFuel = PowerUp(type: .iceFuel, spawnPos: spawnPos, entityManager: entityManager)
        entityManager.add(iceFuel)
    }
    
    
    // MARK: Coins
    // Function to spawn a coin (gold box)
    func spawnCoin() {
        //        if gameOver || currentActiveCoins >= 2 {
        //            return // Stop spawning new objects
        //        }
                
        if gameOver || (isLeftCoinActive && isRightCoinActive) {
            return
        }
        
        if !isLeftCoinActive {
            // Define coin parameters
            let coinType = CoinType.normal
            
            let randomXPos = CGFloat.random(in: -icebergWidth * 0.4...(-icebergWidth * 0.05))
            let randomYPos = CGFloat.random(in: self.size.height / 2 * 0.3...self.size.height / 2 * 0.4)
            let spawnPos = CGPoint(x: randomXPos, y: randomYPos)
                    
            // Make the Coin entity
            let coin = Coin(type: coinType, spawnPos: spawnPos, entityManager: entityManager)
                    
            // Add obstacle to entity manager
            entityManager.add(coin)
                    
            isLeftCoinActive = true
        }
                
        if !isRightCoinActive {
            // Define coin parameters
            let coinType = CoinType.normal
                    
            let randomXPos = CGFloat.random(in: icebergWidth * 0.05...icebergWidth*0.4)
            let randomYPos = CGFloat.random(in: self.size.height / 2 * 0.3...self.size.height / 2 * 0.4)
            let spawnPos = CGPoint(x: randomXPos, y: randomYPos)
                    
            // Make the Coin entity
            let coin = Coin(type: coinType, spawnPos: spawnPos, entityManager: entityManager)
                    
            // Add obstacle to entity manager
            entityManager.add(coin)
                    
            isRightCoinActive = true
        }
                
        // Define coin parameters
        //        let coinType = CoinType.normal
        //
        //        let randomXPos = CGFloat.random(in: -icebergWidth / 2.5...icebergWidth/2.5)
        //        let randomYPos = CGFloat.random(in: self.size.height / 2 * 0.3...self.size.height / 2 * 0.4)
        //        let spawnPos = CGPoint(x: randomXPos, y: randomYPos)
        //
        //        // Make the Coin entity
        //        let coin = Coin(type: coinType, spawnPos: spawnPos, entityManager: entityManager)
        //
        //        // Add obstacle to entity manager
        //        entityManager.add(coin)
        //
        //        currentActiveCoins += 1
        
        // TODO: Add breathing animation
        // Add "breathing" animation
        //        let scaleUp = SKAction.scale(to: 1.5, duration: 1)
        //        let scaleDown = SKAction.scale(to: 1.0, duration: 1.5)
        //        let breathingAnimation = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        //        coin.run(breathingAnimation)
    }
}
