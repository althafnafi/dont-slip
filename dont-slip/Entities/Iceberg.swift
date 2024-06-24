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

    init(nodeName: String, entityManager: EntityManager, state : IcebergStateComponent) {
        self.entityManager = entityManager
        super.init()
        
        // TODO: Remove this later
        //        let icebergNode = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.9, height: 35))
        //        let spriteComponent = SpriteComponent(node: icebergNode)

        let icebergNode = SKSpriteNode(imageNamed: nodeName)
        let spriteComponent = SpriteComponent(node: icebergNode)

        // 1. Add sprite component
//        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.setPos(pos: CGPoint(x: 0, y: 0))
        addComponent(spriteComponent)
        
        // 2. Add physics
        let size = spriteComponent.node.size
        
        print("Ukuran pas init : \(size)")
        let physicsBody = Iceberg.getPhysicsBody(size: size)
        addComponent(PhysicsComponent(node: spriteComponent.node, body: physicsBody))
        
        // 3. Add restoring torque physics
        addComponent(RestoringTorqueComponent(
            node: spriteComponent.node,
            restoringMult: 10,
            dampingMult: 0.5,
            animationDuration: 0.1)
        )
        
        // 4. Attach SpringComponent (for physics)
        let anchorNode: SKNode = Iceberg.getAnchorNode()
        addComponent(SpringComponent(anchorNode: anchorNode, objectNode: spriteComponent.node, entityManager: entityManager))
        
        // 5. Add IcebergStateComponent
        addComponent(state)
        addComponent(ShaderComponent(node: icebergNode))
        
    }
    
    func resetIceberg() -> Void {
        percentage = 100
    }
    
    func setFriction(friction: CGFloat) {
        if friction < 0, friction >= 1 {
            print("Error setting friction: outside of range")
            return
        }
        
        guard let spriteComponent = self.component(ofType: SpriteComponent.self) else {
            print("setFriction: can't get spriteComponent")
            return
        }
        
        spriteComponent.node.physicsBody?.friction = friction
        
    }
    
    
    static func getPhysicsBody(size: CGSize, restitution: CGFloat = 0.2, friction: CGFloat = 0) -> SKPhysicsBody {
        
        // MARK: For Iceberg
        
        let physicsBodySize = CGSize(width: size.width, height: 35)
        let center = CGPoint(x: 0, y: size.height / 2)

        let pBody = SKPhysicsBody(rectangleOf: physicsBodySize, center: center)

            // Calculate the offset to position the physics body at the top of the node
//        let offset = CGPoint(x: 0, y: (size.height - physicsBodySize.height) / 2)
//        pBody.centerOfMassOffset = offset
        
        pBody.isDynamic = true
        pBody.affectedByGravity = true
        pBody.allowsRotation = true
        
        pBody.restitution = 0.2
        pBody.friction = 1
        
        pBody.categoryBitMask = CollisionMask.ground.rawValue
        pBody.contactTestBitMask = CollisionMask.ball.rawValue
        pBody.collisionBitMask = CollisionMask.ball.rawValue | CollisionMask.object.rawValue
        
        return pBody
        
    }
    
    static func getAnchorNode() -> SKNode {
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

