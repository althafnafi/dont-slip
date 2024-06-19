//
//  Penguin.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class Penguin: GKEntity {
    // MARK: Properties
    var ground : SKSpriteNode?
    
    // MARK: Initializers
    init(imageName: String, accelerometerManager: AccelerometerManager?, groundNode: SKSpriteNode?) {
        self.ground = nil
        
        guard let groundGuarded = groundNode else {
            print("init Penguin: component error (defining ground)")
            super.init()
            return
        }
        
        self.ground = groundGuarded
        super.init()
        
        // 1. Add sprite
        let spriteComponent = SpriteComponent(node: getGreenBox())
        // Set position of penguin
        if let groundY = ground?.position.y,
            let groundH = ground?.size.height {
            
            let nodeSize = spriteComponent.node.size
            let yPos = groundY + groundH / 2 + nodeSize.height / 2
            
            spriteComponent.setPos(pos: CGPoint(x: groundH, y: yPos))
        }
        addComponent(spriteComponent)
        
        // 2. Add physics
        let physicsBody = getGreenBoxPhysicsBody()
        addComponent(PhysicsComponent(node: spriteComponent.node, body: physicsBody))
        
        if let accelManager = accelerometerManager {
            // 3. Add control for players
            addComponent(PlayerControlComponent(accelManager: accelManager, spriteComponent: spriteComponent))
        }
    }
    
    init(imageName: String, accelerometerManager: AccelerometerManager?, groundNode: SKSpriteNode?, mass: CGFloat) {
        self.ground = nil
        
        guard let groundGuarded = groundNode else {
            print("init Penguin: component error (defining ground)")
            super.init()
            return
        }
        
        self.ground = groundGuarded
        super.init()
        
        // 1. Add sprite
        let spriteComponent = SpriteComponent(node: getGreenBox())
        // Set position of penguin
        if let groundY = ground?.position.y,
           let groundH = ground?.size.height {
            
            let nodeSize = spriteComponent.node.size
            let yPos = groundY + groundH / 2 + nodeSize.height / 2
            
            spriteComponent.setPos(pos: CGPoint(x: groundH, y: yPos))
        }
        addComponent(spriteComponent)
        
        // 2. Add physics
        let physicsBody = getGreenBoxPhysicsBody()
        addComponent(PhysicsComponent(node: spriteComponent.node, body: physicsBody, mass: mass))
        
        if let accelManager = accelerometerManager {
            // 3. Add control for players
            addComponent(PlayerControlComponent(accelManager: accelManager, spriteComponent: spriteComponent))
        }
        
    }
    
       
    // Update functions (called every frame)
    override func update(deltaTime seconds: TimeInterval) {
        for component in components {
            component.update(deltaTime: seconds)
        }
    }
    
    // MARK: Penguin functions
    private func getPhysicsBody() -> SKPhysicsBody {
        
        let pBody = SKPhysicsBody()
        
        return pBody
    }
    
    // MARK: Green box functions
    private func getGreenBoxPhysicsBody() -> SKPhysicsBody {
        // Size, shape
        let cubeSize = CGSize(width: 30, height: 30)
        let pBody = SKPhysicsBody(rectangleOf: cubeSize)
        
        // Interactivity
        pBody.isDynamic = true
        pBody.affectedByGravity = true
        pBody.allowsRotation = true
        
        // BitMask
        pBody.collisionBitMask = CollisionMask.ground.rawValue
        pBody.categoryBitMask = CollisionMask.ball.rawValue
        pBody.contactTestBitMask = CollisionMask.ground.rawValue
        
        return pBody
    }
    
    private func getGreenBox() -> SKSpriteNode {
        let cubeSize = CGSize(width: 30, height: 30)
        let greenCube = SKSpriteNode(color: .green, size: cubeSize)
        
        return greenCube
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
