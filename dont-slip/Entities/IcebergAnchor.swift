//
//  IcebergAnchor.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//
//

import Foundation

import Foundation
import SpriteKit
import GameplayKit

class IcebergAnchor: GKEntity {
    
    var percentage: Int = 100
    var entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        
        // Add physics
        let physicsBody = getPhysicsBody()
        addComponent(PhysicsComponent(node: SKNode(), body: physicsBody))
  }
    
    func getPhysicsBody() -> SKPhysicsBody {
//        
        let pBody = SKPhysicsBody()
//        
//        // Define the anchor node
//        let anchorNode = SKNode()
//        
//        anchorNode.position = CGPoint(x: 0, y: 0)
//        anchorNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
//        anchorNode.physicsBody?.isDynamic = false // Anchor node is static
//        
//        // Define the ground node
//        let ground = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.9, height: 35))
//        ground.position = CGPoint(x: 0, y: 0) // Middle of the screen
//        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//        
//        // Set up the physics body properties
//        ground.physicsBody?.isDynamic = true // Allows the ground to move
//        ground.physicsBody?.affectedByGravity = true // Allow the ground to be affected by gravity
//        ground.physicsBody?.allowsRotation = true // Allows the ground to rotate
//        
//        // Set up the category and contact bitmasks
//        ground.physicsBody?.categoryBitMask = groundCategory
//        ground.physicsBody?.contactTestBitMask = ballCategory
//        
//        // Set the restitution (bounciness)
//        ground.physicsBody?.restitution = 0.2
//        ground.physicsBody?.friction = 0
//        
//        // Create a spring joint to allow vertical movement and rotation
//        let springJoint = SKPhysicsJointSpring.joint(withBodyA: anchorNode.physicsBody!, bodyB: ground.physicsBody!, anchorA: anchorNode.position, anchorB: ground.position)
//        springJoint.frequency = 1.8 // Spring frequency
//        springJoint.damping = 0.1 // Spring damping
//        
//        // Add the nodes to the scene
//        self.addChild(anchorNode)
//        self.addChild(ground)
//        
//        // Add the spring joint to the physics world
//        entityManager.addJointToPhysicsWorld(springJoint)
//        
//        // Add an action to the ground to apply restoring torque with damping
//        let groundAction = SKAction.repeatForever(SKAction.customAction(withDuration: 0.1) { node, _ in
//            if let physicsBody = node.physicsBody {
//                let currentAngle = physicsBody.node?.zRotation ?? 0
//                let angularVelocity = physicsBody.angularVelocity
//                let restoringTorque = -currentAngle * self.restoringTorqueMult // Increased factor for faster restoration
//                let dampingTorque = -angularVelocity * self.dampingTorqueMult // Damping factor to reduce oscillation
//                physicsBody.applyTorque(restoringTorque + dampingTorque)
//            }
//        })
//        
//        ground.run(groundAction)
        
        return pBody
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

