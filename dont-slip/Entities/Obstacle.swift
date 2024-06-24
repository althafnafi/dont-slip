//
//  Obstacle.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

enum ObstacleType : UInt8, CaseIterable {
    case box = 0
    case barrel = 1
    
    var imageName: String {
        switch self {
        case .box: return "box"
        case .barrel: return "barrel"
        }
    }
    
    var obstacleMass: CGFloat {
        switch self {
        case .box: return 0.08
        case .barrel: return 0.08
        }
    }

}

class Obstacle: GKEntity {
    
    // MARK: Properties
    
    var type: ObstacleType
    
    // MARK: Initializers
    
    init(type: ObstacleType, spawnPos: CGPoint, entityManager: EntityManager, massMultiplier: Double = 1.0) {
        self.type = type
        super.init()
        
        // 1. Add sprite/texture component
        // TODO: Ganti jadi make gambar
        let spriteComponent = SpriteComponent(node: getBoxNode())
//        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: type.imageName))
        spriteComponent.setPos(pos: spawnPos)
        addComponent(spriteComponent)
        
        // 2. Add physics component
        // based on obstacle type
        addComponent(PhysicsComponent(node: spriteComponent.node, body: getObstaclePhysics(size: spriteComponent.node.size), mass: type.obstacleMass * massMultiplier))
    }

    private func getObstaclePhysics(size: CGSize) -> SKPhysicsBody {
        
        var pBody = SKPhysicsBody()
        
        switch self.type {
            
            case .barrel:
                pBody = SKPhysicsBody(rectangleOf: size)
                pBody.isDynamic = true
                pBody.collisionBitMask = CollisionMask.ground.rawValue | CollisionMask.ball.rawValue | CollisionMask.object.rawValue
                pBody.contactTestBitMask = CollisionMask.ball.rawValue
                pBody.categoryBitMask = CollisionMask.object.rawValue
            
            case .box:
                pBody = SKPhysicsBody(rectangleOf: size)
                pBody.isDynamic = true
                pBody.collisionBitMask = CollisionMask.ground.rawValue | CollisionMask.ball.rawValue | CollisionMask.object.rawValue
                pBody.contactTestBitMask = CollisionMask.ball.rawValue
                pBody.categoryBitMask = CollisionMask.object.rawValue
        }
        
        return pBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBoxNode() -> SKSpriteNode {
        let boxTexture = SKTexture(imageNamed: "box")
        let boxNode = SKSpriteNode(texture: boxTexture)
        
        // Optionally set the size if needed
        boxNode.size = CGSize(width: 50, height: 50)
        
        return boxNode
    }
}
