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
    var entityManager: EntityManager

    init(imageName: String, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        
        // TODO: Remove this later
        let icebergNode = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.9, height: 35))
        let spriteComponent = SpriteComponent(node: icebergNode)

        // 1. Add sprite component
//        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.setPos(pos: CGPoint(x: 0, y: 0))
        addComponent(spriteComponent)
        
        // 2. Add physics
        let size = spriteComponent.node.size
        let physicsBody = getPhysicsBody(size: size)
        addComponent(PhysicsComponent(node: spriteComponent.node, body: physicsBody))
        
        // 3. Add restoring torque physics
        addComponent(RestoringTorqueComponent(
            node: spriteComponent.node,
            restoringMult: 10,
            dampingMult: 0.5,
            animationDuration: 0.1)
        )
        
        // 4. Attach SpringComponent (for physics)
        let anchorNode: SKNode = getAnchorNode()
        addComponent(SpringComponent(anchorNode: anchorNode, objectNode: spriteComponent.node, entityManager: entityManager))
        
    }
    
    func resetIceberg() -> Void {
        percentage = 100
    }
    
    
    private func getPhysicsBody(size: CGSize, restitution: CGFloat = 0.2, friction: CGFloat = 0) -> SKPhysicsBody {
        
        // MARK: For Iceberg
        let pBody = SKPhysicsBody(rectangleOf: size)
        
        pBody.isDynamic = true
        pBody.affectedByGravity = true
        pBody.allowsRotation = true
        
        pBody.restitution = 0.2
        pBody.friction = 0
        
        pBody.categoryBitMask = CollisionMask.ground.rawValue
        pBody.contactTestBitMask = CollisionMask.ball.rawValue
        
        return pBody
        
    }
    
    private func getAnchorNode() -> SKNode {
        let anchorNode = SKNode()
            
        anchorNode.position = CGPoint(x: 0, y: 0)
        anchorNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        anchorNode.physicsBody?.isDynamic = false
        
        return anchorNode
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

