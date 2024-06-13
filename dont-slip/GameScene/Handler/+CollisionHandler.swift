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
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Will only be triggered if any of below returns a non-zero
        // bodyA.category AND bodyB.contact
        // bodyA.contact AND bodyB.category
        
//        logCollision(contact)
        
        // Check if the green cube is in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == CollisionMask.ground.rawValue) ||
            (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == CollisionMask.ground.rawValue) {
            
//            print("[Penguin] on ground (2)")
            isPenguinOnGround = true
        }
        
        // Check if the green cube is in contact with a coin
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == CollisionMask.coin.rawValue) ||
            (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == CollisionMask.coin.rawValue) {
            if let coin = contact.bodyA.node == greenCube ? contact.bodyB.node : contact.bodyA.node {
                coin.removeFromParent() // Remove the coin from the scene
                currentActiveCoins -= 1
                coinsCollected += 1
//                print("Coin collected!")
                updatePointsLabel()
            }
        }
    }

    
    func didEnd(_ contact: SKPhysicsContact) {
        // Check if the green cube is no longer in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == CollisionMask.ground.rawValue) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == CollisionMask.ground.rawValue) {
            
//            print("[Penguin] FLYING!")
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
