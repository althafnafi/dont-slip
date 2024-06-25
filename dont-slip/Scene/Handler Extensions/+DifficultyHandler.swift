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
        let intervalSec = 15.0
        let maxDifficultyAtSec = 180.0
        
        let frictionMin = 0.0 // 0.5 - 0.0 // TODO: Masih ngasal
        let spawnIntervalMin = 0.5 // 2.0 - 0.5
        let massMultMax = 2.0 // 1.0 - 2.0
        let iceFuelIntervalMax = 5.0 // 2.0 - 4.0
        let icebergMeltIntervalMin = 4.0 // 8.0 - 4.0
        
        let frictionInc: Double = (frictionMin - self.defaultIcebergFrictionLevel) / (maxDifficultyAtSec / intervalSec)
        let spawnIntervalInc: Double = (spawnIntervalMin - self.defaultSpawnInterval) / (maxDifficultyAtSec / intervalSec)
        let massMultInc: Double = (massMultMax - self.defaultObstacleMassMultiplier) / (maxDifficultyAtSec / intervalSec)
        let iceFuelIntervalInc: Double = (iceFuelIntervalMax - self.defaultIceFuelInterval) / (maxDifficultyAtSec / intervalSec)
        let icebergMeltIntervalInc: Double = (icebergMeltIntervalMin - self.defaultIcebergMeltInterval) / (maxDifficultyAtSec /  intervalSec)
        
        let wait = SKAction.wait(forDuration: 20.0)
        let incrementScore = SKAction.run { [weak self] in
            
            guard let iceberg = self?.icebergEntity else {
                print("iceberg not found")
                return
            }
           
            // Update slipperiness of iceberg
            iceberg.setFriction(friction: self?.icebergFrictionLevel ?? 1)
            self?.icebergFrictionLevel = max(((self?.icebergFrictionLevel ?? frictionMin) + frictionInc), frictionMin)
            
            // Update obstacle spawning rate
            self?.obstacleSpawnInterval = max(((self?.obstacleSpawnInterval ?? spawnIntervalMin) + spawnIntervalInc), spawnIntervalMin)
            
            // Update obstacles to be heavier
            self?.obstacleMassMultiplier = Double(min(((self?.obstacleMassMultiplier ?? massMultMax) + massMultInc), massMultMax))
            
            // Increase fuel interval (need to wait a bit long for the next fuel)
            self?.iceFuelInterval = min(((self?.iceFuelInterval ?? iceFuelIntervalMax) + iceFuelIntervalInc), iceFuelIntervalMax)
            
            // Decrease melt intervals
            self?.icebergMeltInterval = max(((self?.icebergMeltInterval ?? icebergMeltIntervalMin) + icebergMeltIntervalInc), icebergMeltIntervalMin)
        }
        
        let sequence = SKAction.sequence([wait, incrementScore])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "difficultyUpdate")
    }
}
