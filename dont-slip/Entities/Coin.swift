//
//  Coin.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

enum CoinType: UInt8{
    case normal = 1
    
    var imageType: String {
        switch self {
            case .normal:
                return "normalCoin"
        }
    }
}

class Coin: GKEntity {
    
    // MARK: Properties
    let type: CoinType
    
    // MARK: Initializers
    
    init(type: CoinType, spawnPos: CGPoint, entityManager: EntityManager) {
        self.type = type
        super.init()
        
        // Add sprite/texture component
        
        // TODO: Ganti jadi make gambar
       // let coin = SKSpriteNode(color: .yellow, size: CGSize(width: 20, height: 20))
        let spriteComponent = SpriteComponent(node: getCoinNode())
//        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: type.imageName))
        spriteComponent.setPos(pos: spawnPos)
        addComponent(spriteComponent)
        
        // Add physics component
        // based on obstacle type
        addComponent(PhysicsComponent(node: spriteComponent.node, body: getCoinPhysics(size: spriteComponent.node.size)))
    }

    private func getCoinPhysics(size: CGSize) -> SKPhysicsBody {
        var pBody = SKPhysicsBody()
        
        switch self.type {
        case .normal:
            pBody = SKPhysicsBody(rectangleOf: size)
            
            pBody.isDynamic = false
            pBody.affectedByGravity = false // Coin will float
            
            pBody.categoryBitMask = CollisionMask.coin.rawValue
            pBody.contactTestBitMask = CollisionMask.ball.rawValue
            pBody.collisionBitMask = CollisionMask.none.rawValue
        }
        
        return pBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCoinNode() -> SKSpriteNode {
        let coinTexture = SKTexture(imageNamed: "Coin")
        let coinNode = SKSpriteNode(texture: coinTexture)
        
        // Optionally set the size if needed
         coinNode.size = CGSize(width: 50, height: 50)
        
        return coinNode
    }
}
