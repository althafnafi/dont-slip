//
//  +Waves.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 21/06/24.
//

import Foundation
import GameplayKit
import SpriteKit


extension GameScene {
    // MARK: Wave Animation
    func createEndlessWaves() {
        let waveNode1 = SKShapeNode()
        waveNode1.strokeColor = .clear
        waveNode1.fillColor = .topwave
        waveNode1.lineWidth = 2
        waveNode1.zPosition = 1 // In front of iceberg
        self.addChild(waveNode1)
        
        // Create the second wave node with light blue color
        let waveNode2 = SKShapeNode()
        waveNode2.strokeColor = .clear
        waveNode2.fillColor = .midwave
        waveNode2.lineWidth = 2
        waveNode2.zPosition = 2 // In front of waveNode1
        self.addChild(waveNode2)
        
        // Create the third wave node with magenta color
        let waveNode3 = SKShapeNode()
        waveNode3.strokeColor = .clear
        waveNode3.fillColor = .basewave
        waveNode3.lineWidth = 2
        waveNode3.zPosition = 3 // In front of waveNode2
        self.addChild(waveNode3)
        
        let waveWidth = self.size.width * 2
        let wavePath = createWavePath(amplitude: 15, wavelength: 250, width: waveWidth)
        
        waveNode1.path = wavePath
        waveNode2.path = wavePath
        waveNode3.path = wavePath
        
        // Position the waves slightly below each other
        waveNode1.position = CGPoint(x: -670, y: -600)
        waveNode2.position = CGPoint(x: -670, y: -610)
        waveNode3.position = CGPoint(x: -670, y: -620)
        
        let moveDuration1: TimeInterval = 5
        let moveDuration2: TimeInterval = 10
        let moveDuration3: TimeInterval = 15
        
        let moveLeft1 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration1)
        let moveReset1 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence1 = SKAction.sequence([moveLeft1, moveReset1])
        let moveForever1 = SKAction.repeatForever(moveSequence1)
        
        let moveLeft2 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration2)
        let moveReset2 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence2 = SKAction.sequence([moveLeft2, moveReset2])
        let moveForever2 = SKAction.repeatForever(moveSequence2)
        
        let moveLeft3 = SKAction.moveBy(x: -self.size.width, y: 0, duration: moveDuration3)
        let moveReset3 = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveSequence3 = SKAction.sequence([moveLeft3, moveReset3])
        let moveForever3 = SKAction.repeatForever(moveSequence3)
        
        waveNode1.run(moveForever1)
        waveNode2.run(moveForever2)
        waveNode3.run(moveForever3)
    }
    
    func createWavePath(amplitude: CGFloat, wavelength: CGFloat, width: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let waveHeight: CGFloat = self.size.height / 2
        
        // Start at the bottom left corner
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Move up to the starting point of the wave
        path.addLine(to: CGPoint(x: 0, y: waveHeight))
        
        // Draw the wave
        for x in stride(from: 0, to: width, by: 5) { // Increased step size for better performance
            let y = amplitude * sin(x / wavelength * 2 * .pi) + waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Move down to the bottom right corner
        path.addLine(to: CGPoint(x: width, y: 0))
        
        // Close the path to form a complete shape
        path.closeSubpath()
        
        return path
    }
}
