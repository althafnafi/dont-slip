//
//  GameScene+TouchHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    // MARK: Touch handler
    func touchDown(atPoint pos : CGPoint) {
        jumpTouchHandler()
    }
    
    func jumpTouchHandler() {
        // Make the penguin jump
        
//        guard let canJump = penguinEntity?.canJump else { return }
        if isPenguinOnGround, penguinControls != nil {
            run(jumpSound)
            penguinControls?.jump()
        }
        
        isPenguinOnGround = false
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    // MARK: Overridden function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            for t in touches {
                let location = t.location(in: self)
                let nodes = self.nodes(at: location)
                if nodes.contains(where: { $0.name == "restartButton" }) {
                    resetTimers()
                    restartGame()
                    return
                }
                if nodes.contains(where: { $0.name == "homeButton" }) {
                    resetTimers()
            
                    if let view = self.view {
                        
                        let sceneNode = StartScene(size: view.bounds.size)
                        sceneNode.scaleMode = .aspectFill
                        
                        print("Masuk home 4")
                        view.presentScene(sceneNode)
                        
                        view.ignoresSiblingOrder = true
                        
                        view.showsFPS = true
                        view.showsNodeCount = true
                    }
                    
                    return
                }
            }
        } else {
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
   
}
