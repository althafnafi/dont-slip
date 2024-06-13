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

}

class Obstacle: GKEntity {
    
    // MARK: Properties
    
    var type: ObstacleType
    
    // MARK: Initializers
    
    init(type: ObstacleType, spawnPos: CGPoint, entityManager: EntityManager) {
        self.type = type
        super.init()
        
        // Add sprite/texture component
        // TODO: Ganti jadi make gambar
        let spriteComponent = SpriteComponent(node: SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30)))
//        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: type.imageName))
        spriteComponent.setPos(pos: spawnPos)
        addComponent(spriteComponent)
        
        // Add physics component
        // based on obstacle type
        addComponent(PhysicsComponent(node: spriteComponent.node, body: getObstaclePhysics(size: spriteComponent.node.size)))
    }

    func getObstaclePhysics(size: CGSize) -> SKPhysicsBody {
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
}
