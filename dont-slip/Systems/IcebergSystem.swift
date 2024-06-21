//
//  IceBergSystem.swift
//  dont-slip
//
//  Created by mac.bernanda on 20/06/24.
//

import Foundation
import GameplayKit


class IcebergSystem {
    var entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func update(deltaTime: TimeInterval) {
        for entity in entityManager.entities {
            if let stateComponent = entity.component(ofType: IcebergStateComponent.self),
               let spriteComponent = entity.component(ofType: SpriteComponent.self),
               //               let physicsComponent = entity.component(ofType: PhysicsComponent.self),
               //               let restoringTorqueComponent = entity.component(ofType: RestoringTorqueComponent.self),
                let shaderComponent = entity.component(ofType: ShaderComponent.self){
                stateComponent.timeSinceLastChange += deltaTime
                
                if stateComponent.timeSinceLastChange >= 5.0 {
                    stateComponent.timeSinceLastChange = 0
                    
                    if stateComponent.currentStateIndex < stateComponent.states.count - 1 {
                        stateComponent.currentStateIndex += 1
                        
                        shaderComponent.applyShader(node: spriteComponent.node, shader: SKShader(fileNamed: "IcebergTransitionShader"))
                        //                        
                        //                        let delayAction = SKAction.wait(forDuration: 1)
                        //                        let backToNormalAction = SKAction.run {
                        //                            shaderComponent.removeShader(node: spriteComponent.node)
                        //                        }
                        //                        
                        //                        spriteComponent.node.run(SKAction.sequence([delayAction, backToNormalAction]))
                        
                        //                        shaderComponent.applyShader(node: spriteComponent.node)
                        
                        // Create actions to wait and then change the Iceberg state
                        let delayAction = SKAction.wait(forDuration: 1.0)
                        let changeStateAction = SKAction.run {
                            // Remove the shader
                            shaderComponent.removeShader(node: spriteComponent.node)
                            
                            // Change the texture and update the physics body
                            let newTexture = SKTexture(imageNamed: stateComponent.currentImage)
                            spriteComponent.node.texture = newTexture
                            spriteComponent.node.size = newTexture.size()
                            spriteComponent.node.physicsBody = Iceberg.getPhysicsBody(size: newTexture.size())
                            
                            // Temporarily disable physics
                            spriteComponent.node.physicsBody?.isDynamic = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                spriteComponent.node.physicsBody?.isDynamic = true
                            }
                            
                            // Handle entity management
                            self.entityManager.remove(entity)
                            if stateComponent.currentImage != "done" {
                                self.entityManager.add(Iceberg(nodeName: stateComponent.currentImage, entityManager: self.entityManager, state: stateComponent))
                            }
                        }
                        
                        // Run the sequence of actions
                        spriteComponent.node.run(SKAction.sequence([delayAction, changeStateAction]))
                    }
                    
                    //
                    //                        
                    //                        entityManager.remove(entity)
                    //                        
                    //                        if stateComponent.currentImage == "done" {
                    //                            return
                    //                        }
                    //                        
                    //                        self.entityManager.add(Iceberg(nodeName: stateComponent.currentImage, entityManager: self.entityManager, state: stateComponent))
                    //                        spriteComponent.node.run(SKAction.sequence([delayAction, enableDynamicAction]))
                    
                    
                    //                        kasi shader blinking sblm transisi aset
                    
                    //
                    
                    //                        
                    //                        let newTexture = SKTexture(imageNamed: stateComponent.currentImage)
                    //                        spriteComponent.node.texture = newTexture
                    //                        spriteComponent.node.size = newTexture.size()
                    
                    //                        if let springComponent = entity.component(ofType: SpringComponent.self) {
                    //                            entityManager.scene.removeChildren(in: [springComponent.anchorNode])
                    //                            
                    //                            let delayAction = SKAction.wait(forDuration: 0)
                    //                            let enableDynamicAction = SKAction.run {
                    //                                self.entityManager.scene.addChild(Iceberg.getAnchorNode())
                    //                                let newBody = Iceberg.getPhysicsBody(size: newTexture.size())
                    //        
                    //                                // Set velocity if available
                    //                                if let currentVelocity = spriteComponent.node.physicsBody?.velocity {
                    //                                    print(currentVelocity)
                    //                                    newBody.velocity = currentVelocity
                    //                                }
                    //        
                    //                                spriteComponent.node.physicsBody = newBody
                    //                            }
                    //                            spriteComponent.node.run(SKAction.sequence([delayAction, enableDynamicAction]))
                    //                        }
                    
                    
                    // Update physics body size and properties
                    //                                                let newBody = Iceberg.getPhysicsBody(size: newTexture.size())
                    //                        
                    //                                                // Set velocity if available
                    //                                                if let currentVelocity = spriteComponent.node.physicsBody?.velocity {
                    //                                                    print(currentVelocity)
                    //                                                    newBody.velocity = currentVelocity
                    //                                                }
                    //                        
                    //                                                spriteComponent.node.physicsBody = newBody
                    
                    
                    //                        physicsComponent.node.physicsBody.node = Iceberg.getPhysicsBody(size: newTexture.size())
                    
                    //                        spriteComponent.node.physicsBody = Iceberg.getPhysicsBody(size: newTexture.size())
                    //                        spriteComponent.node.physicsBody?.affectedByGravity = false
                    
                    //                        // Delayed action to turn isDynamic back to true after 0.5 seconds
                    //                        let delayAction = SKAction.wait(forDuration: 0.5)
                    //                        let enableDynamicAction = SKAction.run {
                    //                            spriteComponent.node.physicsBody?.isDynamic = true
                    //                        }
                    //                        spriteComponent.node.run(SKAction.sequence([delayAction, enableDynamicAction]))
                    
                    //                        spriteComponent.node.physicsBody?.isDynamic = true
                    
                    //                        entity.removeComponent(ofType: RestoringTorqueComponent.self)
                    //                        entity.removeComponent(ofType: PhysicsComponent.self)
                    //                        entity.removeComponent(ofType: SpringComponent.self)
                    //
                    //                        entity.addComponent(SpringComponent(anchorNode: Iceberg.getAnchorNode(), objectNode: spriteComponent.node, entityManager: entityManager))
                    //                        entity.addComponent(RestoringTorqueComponent(
                    //                            node: spriteComponent.node,
                    //                            restoringMult: 10,
                    //                            dampingMult: 0.5,
                    //                            animationDuration: 0.1))
                    //                        entity.addComponent(PhysicsComponent(node: spriteComponent.node, body: Iceberg.getPhysicsBody(size: newTexture.size())))
                    
                    
                }
            }
        }
    }
}

