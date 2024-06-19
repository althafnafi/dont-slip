import SpriteKit
import GameplayKit

class StartScene: SKScene {
    override func didMove(to view: SKView) {
        // Set up background image
        let background = SKSpriteNode(imageNamed: "bg.png")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Set up penguin image
        let penguin = SKSpriteNode(imageNamed: "penguin.png")
        penguin.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        penguin.zPosition = 1
        addChild(penguin)
        startTilting(node: penguin)
        
        // Set up iceberg image
        let iceberg = SKSpriteNode(imageNamed: "iceberg.png")
        iceberg.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        iceberg.zPosition = 0 // Behind waveNode1
        addChild(iceberg)
        startTilting(node: iceberg)
        
        // Set up wave animation
        createEndlessWaves()
        
        // Set up start button
        let startButton = SKSpriteNode(imageNamed: "StartButton.png")
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        startButton.name = "startButton"
        startButton.zPosition = 3
        addChild(startButton)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "startButton" {
                if let scene = GKScene(fileNamed: "GameScene") {
                    
                    // Get the SKScene from the loaded GKScene
                    if let sceneNode = scene.rootNode as! GameScene? {
                        
                        // Copy gameplay related content over to the scene
                        //  sceneNode.entities = scene.entities
                        //  sceneNode.graphs = scene.graphs
                        
                        // Set the scale mode to scale to fit the window
                        sceneNode.scaleMode = .aspectFill
                        
                        // Present the scene
                        if let view = self.view {
                            view.presentScene(sceneNode)
                            
                            view.ignoresSiblingOrder = true
                            
                            view.showsFPS = true
                            view.showsNodeCount = true
                        }
                        
                    }
                }
            }
        }
    }
            
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
                let wavePath = createWavePath(amplitude: 10, wavelength: 250, width: waveWidth)
                
                waveNode1.path = wavePath
                waveNode2.path = wavePath
                waveNode3.path = wavePath
                
                // Position the waves slightly below each other
                waveNode1.position = CGPoint(x: 0, y: -50)
                waveNode2.position = CGPoint(x: 0, y: -60)
                waveNode3.position = CGPoint(x: 0, y: -70)
                
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
            
            func startTilting(node: SKNode) {
                let tiltRight = SKAction.rotate(byAngle: CGFloat.pi / 20, duration: 1)
                let tiltLeft = SKAction.rotate(byAngle: -CGFloat.pi / 20, duration: 1)
                let tiltBackToCenter = SKAction.rotate(toAngle: 0, duration: 1)
                let tiltSequence = SKAction.sequence([tiltLeft, tiltBackToCenter, tiltRight, tiltBackToCenter])
                let tiltForever = SKAction.repeatForever(tiltSequence)
                node.run(tiltForever)
            }
        }


