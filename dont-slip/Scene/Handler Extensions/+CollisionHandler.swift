//
//  CollisionHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    
    func isLeftCoin(coin: SKNode) -> Bool {
        // icebergWidth * 0.05...icebergWidth*0.4
        let coinPos = coin.position
        if coinPos.x > icebergWidth * 0.05, coinPos.x < icebergWidth * 0.4 {
            return false
        }
    
        
        return true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Will only be triggered if any of below returns a non-zero
        // bodyA.category AND bodyB.contact
        // bodyA.contact AND bodyB.category
        
        // logCollision(contact)
        
        // Check if the green cube (penguin) is in contact with the ground or an obstacle
        let groundOrObstacleMask = CollisionMask.ground.rawValue | CollisionMask.object.rawValue
        if (contact.bodyA.node == greenCube && (contact.bodyB.categoryBitMask & groundOrObstacleMask != 0)) ||
            (contact.bodyB.node == greenCube && (contact.bodyA.categoryBitMask & groundOrObstacleMask != 0)) {
            
//            print("[Penguin] on ground or obstacle")
            isPenguinOnGround = true  // Assuming you will use this flag to control jump capability
        }
        
        // Check if the green cube (penguin) is in contact with a coin
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == CollisionMask.coin.rawValue) ||
            (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == CollisionMask.coin.rawValue) {
            if let coin = contact.bodyA.node == greenCube ? contact.bodyB.node : contact.bodyA.node {
                run(coinSound)
                coin.removeFromParent() // Remove the coin from the scene
                if isLeftCoin(coin: coin) {
                    isLeftCoinActive = false
                }
                
                if isLeftCoin(coin: coin) {
                    isRightCoinActive = false
                }
                coinsCollected += 1
                updatePointsLabel()
            }
        }
        
        // check if pining contact with the fuel
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == CollisionMask.iceFuel.rawValue) ||
            (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == CollisionMask.iceFuel.rawValue) {
            
            if icebergStateSystem.getGotFuel() {
                print("Dah dpt fuel kok")
                return
            }
            
            if let fuel = contact.bodyA.node == greenCube ? contact.bodyB.node : contact.bodyA.node {
                run(iceSound)
                icebergStateSystem.setGotFuel(isGotFuel: true)
                fuel.removeFromParent() // Remove the coin from the scene
            } 
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        // Check if the green cube (penguin) is no longer in contact with the ground or an obstacle
        let groundOrObstacleMask = CollisionMask.ground.rawValue | CollisionMask.object.rawValue
        if (contact.bodyA.node == greenCube && (contact.bodyB.categoryBitMask & groundOrObstacleMask != 0)) ||
           (contact.bodyB.node == greenCube && (contact.bodyA.categoryBitMask & groundOrObstacleMask != 0)) {
            
//            print("[Penguin] not on ground or obstacle")
            isPenguinOnGround = false
        }
    }
    
    func logCollision(_ contact: SKPhysicsContact) {
        print("---")
        print("Collision")
        print("A: \(contact.bodyA.collisionBitMask), B: \(contact.bodyB.collisionBitMask)")
        print("Category")
        print("A: \(contact.bodyA.categoryBitMask), B: \(contact.bodyB.categoryBitMask)")
        print("Contact")
        print("A: \(contact.bodyA.contactTestBitMask), B: \(contact.bodyB.contactTestBitMask)")
    }
}
