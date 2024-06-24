//
//  IceFuel.swift
//  dont-slip
//
//  Created by mac.bernanda on 23/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    func showIceFuelPowerUp() {
            // Create a container node for the IceFuel power-up
            let powerUpContainer = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))
            powerUpContainer.position = CGPoint(x: -self.size.width / 2 + 50, y: -self.size.height / 2 + 50)
            powerUpContainer.zPosition = 300
            addChild(powerUpContainer)
            
            // Create the IceFuel power-up sprite
            let iceFuelNode = SKSpriteNode(imageNamed: PowerUpType.iceFuel.imageName)
            iceFuelNode.size = CGSize(width: 50, height: 50)
            iceFuelNode.position = CGPoint(x: 0, y: 0)
            iceFuelNode.zPosition = 301
            powerUpContainer.addChild(iceFuelNode)
            
            // Add a label to indicate the IceFuel power-up
            let powerUpLabel = SKLabelNode(text: "IceFuel Power-Up")
            powerUpLabel.fontSize = 20
            powerUpLabel.fontColor = .white
            powerUpLabel.fontName = "AlegreyaSansSC-Bold"
            powerUpLabel.position = CGPoint(x: 0, y: -60)
            powerUpLabel.zPosition = 302
            powerUpContainer.addChild(powerUpLabel)
            
            // Add physics to the IceFuel node to make it fall slower
            let physicsBody = SKPhysicsBody(circleOfRadius: 25)
            physicsBody.mass = 0.04
            physicsBody.linearDamping = 2.0
            physicsBody.isDynamic = true
            physicsBody.collisionBitMask = CollisionMask.ball.rawValue | CollisionMask.object.rawValue
            physicsBody.contactTestBitMask = CollisionMask.ball.rawValue
            physicsBody.categoryBitMask = CollisionMask.object.rawValue
            iceFuelNode.physicsBody = physicsBody
            
            // Animate the IceFuel power-up (optional)
            let moveAction = SKAction.moveBy(x: 0, y: -self.size.height, duration: 5.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            iceFuelNode.run(sequence)
        }
}
