//
//  PowerUp.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

enum PowerUpType : UInt8 {
    case shield = 1
    case secondChance = 2
    case iceFuel = 3
    
    var imageName: String {
        switch self {
        case .shield:
            return "shield"
        case .secondChance:
            return "secondChance"
        case .iceFuel:
            return "iceFuel"
        }
    }
}

class PowerUp: GKEntity {
    var type: PowerUpType
    
    init(type: PowerUpType, spawnPos: CGPoint, entityManager: EntityManager) {
        self.type = type
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: type.imageName))
        spriteComponent.setPos(pos: spawnPos)
        spriteComponent.node.size = CGSize(width: 50, height: 50)
        addComponent(spriteComponent)
        
        addComponent(PhysicsComponent(node: spriteComponent.node, body: getPowerUpPhysic(size: spriteComponent.node.size)))
    }
    
    private func getPowerUpPhysic(size: CGSize) -> SKPhysicsBody {
        
        var pBody = SKPhysicsBody()
        
        switch self.type {
            
        case .shield:
            print("shield")
            
        case .secondChance:
            print("secondChance")
            
        case .iceFuel:
            pBody = SKPhysicsBody(circleOfRadius: 50)
            pBody.mass = 0.0004
            pBody.linearDamping = 10.0
            pBody.isDynamic = true
            pBody.collisionBitMask = CollisionMask.none.rawValue
            pBody.contactTestBitMask = CollisionMask.ball.rawValue
            pBody.categoryBitMask = CollisionMask.iceFuel.rawValue
            
        }
        
        return pBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
