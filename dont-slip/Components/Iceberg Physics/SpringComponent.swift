//
//  SpringComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 14/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

class SpringComponent: GKComponent {
    var anchorNode: SKNode
    var objectNode: SKSpriteNode
    let entityManager: EntityManager
    
    init(anchorNode: SKNode, objectNode: SKSpriteNode, entityManager: EntityManager) {
        self.anchorNode = anchorNode
        self.objectNode = objectNode
        self.entityManager = entityManager
        
        super.init()
    }
    
    func getSpringJoint() -> SKPhysicsJointSpring {
       // MARK: Sprint joint -> Need both data
        // Create a spring joint to allow vertical movement and rotation
        let springJoint = SKPhysicsJointSpring.joint(withBodyA: anchorNode.physicsBody!, bodyB: objectNode.physicsBody!, anchorA: anchorNode.position, anchorB: objectNode.position)
        springJoint.frequency = 1.8 // Spring frequency
        springJoint.damping = 0.1 // Spring damping
        
        return springJoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

