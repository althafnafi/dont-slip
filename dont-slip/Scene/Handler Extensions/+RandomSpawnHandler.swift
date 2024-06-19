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
        let randomXPos = CGFloat.random(in: -320...icebergWidth)
        let yPos = CGFloat(self.size.height)
        let spawnPos = CGPoint(x: randomXPos, y: yPos)
        
        // Make the Obstacle entity
        let obstacle = Obstacle(type: obstacleType, spawnPos: spawnPos, entityManager: entityManager)
        // Add obstacle to entity manager
        entityManager.add(obstacle)
        // Reduce the spawn interval to increase difficulty over time
        obstacleSpawnInterval = max(spawnInterval * 0.70, 0.5)
    }
    
    
    // MARK: Coins
    
    // Function to spawn a coin (gold box)
    func spawnCoin() {
        if gameOver || currentActiveCoins >= 2 {
            return // Stop spawning new objects
        }
        
        // Define coin parameters
        let coinType = CoinType.normal
        
        let randomXPos = CGFloat.random(in: -icebergWidth / 2.5...icebergWidth/2.5)
        let randomYPos = CGFloat.random(in: self.size.height / 2 * 0.3...self.size.height / 2 * 0.4)
        let spawnPos = CGPoint(x: randomXPos, y: randomYPos)
        
        // Make the Coin entity
        let coin = Coin(type: coinType, spawnPos: spawnPos, entityManager: entityManager)
        
        // Add obstacle to entity manager
        entityManager.add(coin)
        
        currentActiveCoins += 1
        
        // TODO: Add breathing animation
        // Add "breathing" animation
        //        let scaleUp = SKAction.scale(to: 1.5, duration: 1)
        //        let scaleDown = SKAction.scale(to: 1.0, duration: 1.5)
        //        let breathingAnimation = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        //        coin.run(breathingAnimation)
    }
}
