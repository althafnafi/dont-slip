//
//  +DifficultyHandler.swift
//  dont-slip
//
//  Created by Althaf Nafi Anwar on 21/06/24.
//

import Foundation
import GameplayKit
import SpriteKit

extension GameScene {
    /*
     
     - [ ]  Tambah licin
     - [ ]  Obstacle tambah cepat spawnya
     - [ ]  Obstacle Tambah tambah berat
     
     Berubah tiap 20 detik
     Mencapai kesulitan maksimal di detik ke 30 detik * 10 menit atau setelah 300 sec
     
     */
    func difficultyUpdater() {
        let intervalSec = 30.0
        let maxDifficultyAtSec = 300.0
        
        let frictionMin = 0.0
        let spawnIntervalMin = 0.5
        let massMultMax = 2.0
        
        let frictionInc: Double = (frictionMin - self.icebergFrictionLevel) / (maxDifficultyAtSec / intervalSec)
        let spawnIntervalInc: Double = (spawnIntervalMin - self.obstacleSpawnInterval) / (maxDifficultyAtSec / intervalSec)
        let massMultInc: Double = (massMultMax - self.obstacleMassMultiplier) / (maxDifficultyAtSec / intervalSec)
        
        let wait = SKAction.wait(forDuration: 20.0)
        let incrementScore = SKAction.run { [weak self] in
            
            guard let iceberg = self?.icebergEntity else {
                print("iceberg not found")
                return
            }
            
            // TODO: Rapihin
            // Update slipperiness of iceberg
            iceberg.setFriction(friction: self?.icebergFrictionLevel ?? 1)
            self?.icebergFrictionLevel = max(((self?.icebergFrictionLevel ?? 1) + frictionInc), frictionMin)
            
            // Update obstacle spawning rate
            self?.obstacleSpawnInterval = max(((self?.obstacleSpawnInterval ?? 0.5) + spawnIntervalInc), spawnIntervalMin)
            
            // Update obstacles to be heavier
            self?.obstacleMassMultiplier = Double(min(((self?.obstacleMassMultiplier ?? 2.0) + massMultInc), massMultMax))
            
//            print("frictionLevel: \(String(describing: self?.icebergFrictionLevel))")
//            print("spawnInterval: \(String(describing: self?.spawnInterval))")
//            print("massMultiplier: \(String(describing: self?.obstacleMassMultiplier))")
            
        }
        let sequence = SKAction.sequence([wait, incrementScore])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "difficultyUpdate")
    }
}
