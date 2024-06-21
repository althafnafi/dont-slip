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
    var node : SKSpriteNode!
    
    // MARK: Initializers
    init(node: SKSpriteNode, body: SKPhysicsBody) {
        self.node = node
        node.physicsBody = body
        super.init()
    }
    
    init(node: SKSpriteNode, body: SKPhysicsBody, mass: CGFloat) {
        self.node = node
        body.mass = mass
        node.physicsBody = body
        super.init()
    }
    
    init(node: SKNode, body: SKPhysicsBody) {
        node.physicsBody = body
        super.init()
    }
    
    func updatePhysics(newBody: SKPhysicsBody) {
        node.physicsBody = newBody
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
