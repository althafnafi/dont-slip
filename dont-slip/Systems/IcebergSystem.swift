//
//  IceBergSystem.swift
//  dont-slip
//
//  Created by mac.bernanda on 20/06/24.
//

import Foundation
import GameplayKit

class IcebergSystem {
    // sementara setelah dapet fuel lsg nambah es
    // TODO : satu fuel setara 10 detik (dibuat dinamis tergantung difficulty)
    var isGotFuel: Bool = false
    var entityManager: EntityManager
    var currentIcebergWdith: CGFloat = 0
    var timeLimit: Double = 5
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func getGotFuel() -> Bool {
        return isGotFuel
    }
    
    func setGotFuel(isGotFuel: Bool) {
        self.isGotFuel = isGotFuel
    }
    
    func setTimeLimit(timeLimit: Double) {
        self.timeLimit = timeLimit
    }
    
    func update(deltaTime: TimeInterval) {
        for entity in entityManager.entities {
            if let stateComponent = entity.component(ofType: IcebergStateComponent.self),
               let spriteComponent = entity.component(ofType: SpriteComponent.self),
               let shaderComponent = entity.component(ofType: ShaderComponent.self) {
                stateComponent.timeSinceLastChange += deltaTime
                
                currentIcebergWdith = spriteComponent.node.size.width
                
                if isGotFuel {
                    if stateComponent.currentStateIndex > 0 {
                        stateComponent.currentStateIndex -= 1
                        stateComponent.timeSinceLastChange = 0
                        changeIcebergState(entity: entity, stateComponent: stateComponent, spriteComponent: spriteComponent, shaderComponent: shaderComponent)
                        isGotFuel = false
                    }
                }
//                print("lastChange: \(stateComponent.timeSinceLastChange), \(timeLimit)")
                if stateComponent.timeSinceLastChange >= timeLimit {
                    stateComponent.timeSinceLastChange = 0
                    
                    print("mau cair")
                    if stateComponent.currentStateIndex < stateComponent.states.count - 1 {
                        print("Cair esnya")
                        stateComponent.currentStateIndex += 1
                        changeIcebergState(entity: entity, stateComponent: stateComponent, spriteComponent: spriteComponent, shaderComponent: shaderComponent)
                    }
                }
            }
        }
    }
    
    private func changeIcebergState(entity: GKEntity, stateComponent: IcebergStateComponent, spriteComponent: SpriteComponent, shaderComponent: ShaderComponent) {
        shaderComponent.applyShader(shader: SKShader(fileNamed: "IcebergTransitionShader"))
        
        let delayAction = SKAction.wait(forDuration: 1.0)
        let changeStateAction = SKAction.run {
            // Remove the shader
            shaderComponent.removeShader()
            
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
                self.entityManager.add(Iceberg(nodeName: stateComponent.currentImage, entityManager: self.entityManager, state: stateComponent, rotation: spriteComponent.node.zRotation))
            }
        }
        spriteComponent.node.run(SKAction.sequence([delayAction, changeStateAction]))
    }
}
