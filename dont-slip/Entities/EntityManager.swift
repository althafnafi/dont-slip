//
//  EntityManager.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        if let springComponent = entity.component(ofType: SpringComponent.self) {
            scene.addChild(springComponent.anchorNode)
            scene.physicsWorld.add(springComponent.getSpringJoint())
        }
    }
    
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
    func update(deltaTime: TimeInterval) {
        // Update entities
        for e in entities {
            e.update(deltaTime: deltaTime)
        }
        
        
    }
}

