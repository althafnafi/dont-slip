//
//  CoinHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 13/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }

    func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }

    func saveCoins(){
        UserDefaults.standard.set(totalCoins, forKey: "TotalCoins")
    }

    func loadCoins(){
        totalCoins = UserDefaults.standard.integer(forKey: "TotalCoins")
    }
    
    func incrementScore() {
           score += 1
           scoreLabel.text = "Score: \(score)"
       }
    
    func startScoreTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let incrementScore = SKAction.run { [weak self] in
            self?.incrementScore()
        }
        let sequence = SKAction.sequence([wait, incrementScore])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "scoreTimer")
    }

}

