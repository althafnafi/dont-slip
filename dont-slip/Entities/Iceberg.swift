//
//  Ground.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation

import Foundation
import SpriteKit
import GameplayKit

class Iceberg: GKEntity {
    
    // MARK: Properties
    var percentage: Int = 100
    var anchorNode: SKNode
    var entityManager: EntityManager

    init(imageName: String, anchorNode: SKNode, entityManager: EntityManager) {
        self.anchorNode = anchorNode
        self.entityManager = entityManager
        super.init()

        // Add sprite component
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
        
        // Add physics
        let physicsBody = getPhysicsBody()
        addComponent(PhysicsComponent(node: spriteComponent.node, body: physicsBody))
        
        // Add restoring torque physics
        addComponent(RestoringTorqueComponent(
            node: spriteComponent.node,
            restoringMult: 10,
            dampingMult: 0.5,
            animationDuration: 0.1)
        )
  }
    
    func getPhysicsBody() -> SKPhysicsBody {
        
        // MARK: For Iceberg
        let pBody = SKPhysicsBody()
        
        // Define the ground node
        let ground = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.9, height: 35))
        ground.position = CGPoint(x: 0, y: 0) // Middle of the screen
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        // Set up the physics body properties
        ground.physicsBody?.isDynamic = true // Allows the ground to move
        ground.physicsBody?.affectedByGravity = true // Allow the ground to be affected by gravity
        ground.physicsBody?.allowsRotation = true // Allows the ground to rotate
        
        // Set the restitution (bounciness) and friction
        ground.physicsBody?.restitution = 0.2
        ground.physicsBody?.friction = 0
        
        // Set up the category and contact bitmasks
        ground.physicsBody?.categoryBitMask = CollisionMask.ground.rawValue
        ground.physicsBody?.contactTestBitMask = CollisionMask.ball.rawValue
        
        
        
        
        
        
        
        
        // MARK: For anchorNode
        
        // Define the anchor node
        let anchorNode = SKNode()
        
        anchorNode.position = CGPoint(x: 0, y: 0)
        anchorNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        anchorNode.physicsBody?.isDynamic = false // Anchor node is static
        
        
        
        
        
        
        
       // MARK: Sprint joint -> Need both data
        // Create a spring joint to allow vertical movement and rotation
        let springJoint = SKPhysicsJointSpring.joint(withBodyA: anchorNode.physicsBody!, bodyB: ground.physicsBody!, anchorA: anchorNode.position, anchorB: ground.position)
        springJoint.frequency = 1.8 // Spring frequency
        springJoint.damping = 0.1 // Spring damping
        
        
        
        
        
        // MARK: Add with entity manager
        // Add the nodes to the scene
//        self.addChild(anchorNode)
//        self.addChild(ground)
        
        // Add the spring joint to the physics world
        entityManager.addJointToPhysicsWorld(springJoint)
        
        
        return pBody
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

