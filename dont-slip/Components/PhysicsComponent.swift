//
//  PhysicsComponent.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//


import Foundation
import SpriteKit
import GameplayKit


class PhysicsComponent: GKComponent {
    // MARK: Properties
    
    // MARK: Initializers
    init(node: SKSpriteNode, body: SKPhysicsBody) {
        node.physicsBody = body
        super.init()
    }
    
    
    init(node: SKNode, body: SKPhysicsBody) {
        node.physicsBody = body
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
