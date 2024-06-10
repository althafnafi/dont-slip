//
//  GameScene.swift
//  nyoba-mini2
//
//  Created by Althaf Nafi Anwar on 10/06/24.
//

import SpriteKit
import GameplayKit

enum CollisionMask : UInt32 {
    case ground = 1
    case ball   = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spawnInterval: TimeInterval = 2.0
    var lastSpawnTime: TimeInterval = 0
    var lebarPlatform = UIScreen.main.bounds.width * 0.8
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    /* Constants */
    private var groundCategory : UInt32 = 0b1 << 0 // 1
    private var ballCategory : UInt32 = 0b1 << 1 // 2
    private let restoringTorqueMult : CGFloat = 10.0
    private let dampingTorqueMult : CGFloat = 0.5
    /* Constants */
    
    private var greenCube: SKSpriteNode? // the cube (penguin)
    private var isGreenCubeOnGround = false // Flag to track if the green cube is on the ground
        
    private var gameOver: Bool = false
    
    override func sceneDidLoad() {
        // Setup
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        spawnGround()
        startSpawning()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        print("touchDown")
        makeGreenCubeJump() // call function
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print("touchUp \(pos)")
        //spawnPhysicsObject(posClicked: pos)
    }
    
    
    func spawnGround() {
        // Define the anchor node
        let anchorNode = SKNode()
        
        anchorNode.position = CGPoint(x: 0, y: 0)
        anchorNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        anchorNode.physicsBody?.isDynamic = false // Anchor node is static
        
        // Define the ground node
        let ground = SKSpriteNode(color: .white, size: CGSize(width: UIScreen.main.bounds.width * 0.8, height: 35))
        ground.position = CGPoint(x: 0, y: 0) // Middle of the screen
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        // Set up the physics body properties
        ground.physicsBody?.isDynamic = true // Allows the ground to move
        ground.physicsBody?.affectedByGravity = true // Allow the ground to be affected by gravity
        ground.physicsBody?.allowsRotation = true // Allows the ground to rotate
        
        // Set up the category and contact bitmasks
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.contactTestBitMask = ballCategory
        
        // Set the restitution (bounciness)
        ground.physicsBody?.restitution = 0.2
        ground.physicsBody?.friction = 0
        
        // Create a spring joint to allow vertical movement and rotation
        let springJoint = SKPhysicsJointSpring.joint(withBodyA: anchorNode.physicsBody!, bodyB: ground.physicsBody!, anchorA: anchorNode.position, anchorB: ground.position)
        springJoint.frequency = 1.8 // Spring frequency
        springJoint.damping = 0.1 // Spring damping
        
        // Add the nodes to the scene
        self.addChild(anchorNode)
        self.addChild(ground)
        
        // Add the spring joint to the physics world
        self.physicsWorld.add(springJoint)
        
        // Add an action to the ground to apply restoring torque with damping
        let groundAction = SKAction.repeatForever(SKAction.customAction(withDuration: 0.1) { node, _ in
            if let physicsBody = node.physicsBody {
                let currentAngle = physicsBody.node?.zRotation ?? 0
                let angularVelocity = physicsBody.angularVelocity
                let restoringTorque = -currentAngle * self.restoringTorqueMult // Increased factor for faster restoration
                let dampingTorque = -angularVelocity * self.dampingTorqueMult // Damping factor to reduce oscillation
                physicsBody.applyTorque(restoringTorque + dampingTorque)
            }
        })
        
        ground.run(groundAction)
        spawnTestCube(ground: ground)
    }
    
    func spawnTestCube(ground: SKSpriteNode) {
        // Add a green cube on top of the middle of the ground
        let cubeSize = CGSize(width: 30, height: 30)
        let greenCube = SKSpriteNode(color: .green, size: cubeSize)
        greenCube.position = CGPoint(x: 0, y: ground.position.y + ground.size.height / 2 + cubeSize.height / 2)
        greenCube.physicsBody = SKPhysicsBody(rectangleOf: cubeSize)

        // Set up the cube's physics body properties
        greenCube.physicsBody?.isDynamic = true
        greenCube.physicsBody?.affectedByGravity = true
        greenCube.physicsBody?.allowsRotation = true
        
        greenCube.physicsBody?.collisionBitMask = groundCategory

        // Add the cube to the scene
        self.addChild(greenCube)
        
        // Store reference to the greenCube
        self.greenCube = greenCube
    }
    
    // function to make the cube jump
    func makeGreenCubeJump() {
        guard isGreenCubeOnGround, let greenCube = greenCube, let physicsBody = greenCube.physicsBody else {
            return
        }
        
        // Apply an upward impulse to the green cube
        let jumpImpulse = CGVector(dx: 0, dy: 25)
        physicsBody.applyImpulse(jumpImpulse)
        
        // Set the flag to false since the cube is now in the air
        isGreenCubeOnGround = false
    }
    
    func spawnPhysicsObject(posClicked: CGPoint) {
        // Define the objec
        let cubeSize = CGSize(width: 30, height: 30)
//        let ballRadius : CGFloat = 20
        let newObject = SKSpriteNode(color: .red, size: cubeSize)
//        newObject.fillColor = .red
        newObject.position = posClicked
        
        // Add physics properties to the object
        newObject.physicsBody = SKPhysicsBody(rectangleOf: cubeSize)
        newObject.physicsBody?.collisionBitMask = groundCategory
//        newObject.physicsBody?.categoryBitMask = ballCategory
        
        // Add object to scene
        self.addChild(newObject)
        
        print("Added a new object")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Will only be triggered if any of below returns a non-zero
        // bodyA.category AND bodyB.contact
        // bodyA.contact AND bodyB.category
        print("---")
        print("Collision")
        print("A: \(contact.bodyA.collisionBitMask), B: \(contact.bodyB.collisionBitMask)")
        print("Category")
        print("A: \(contact.bodyA.categoryBitMask), B: \(contact.bodyB.categoryBitMask)")
        print("Contact")
        print("A: \(contact.bodyA.contactTestBitMask), B: \(contact.bodyB.contactTestBitMask)")
        
        // Check if the green cube is in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == groundCategory) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == groundCategory) {
            isGreenCubeOnGround = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // Check if the green cube is no longer in contact with the ground
        if (contact.bodyA.node == greenCube && contact.bodyB.categoryBitMask == groundCategory) ||
           (contact.bodyB.node == greenCube && contact.bodyA.categoryBitMask == groundCategory) {
            isGreenCubeOnGround = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            for t in touches {
                let location = t.location(in: self)
                let nodes = self.nodes(at: location)
                if nodes.contains(where: { $0.name == "restartButton" }) {
                    restartGame()
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
    
    // start to spawn falling obstacles
    func startSpawning() {
        let wait = SKAction.wait(forDuration: spawnInterval)
        let spawn = SKAction.run { [weak self] in
            self?.spawnObject()
        }
        let sequence = SKAction.sequence([wait, spawn])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }

    // spawn falling obstacles on random position
    func spawnObject() {
        if gameOver {
            return  // Stop spawning new objects
        }
        
        let object = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        let xPosition = CGFloat.random(in: -320...lebarPlatform)
        object.position = CGPoint(x: xPosition, y: self.size.height)
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
        object.physicsBody?.isDynamic = true
        object.physicsBody?.categoryBitMask = 0x1 << 0
        object.physicsBody?.contactTestBitMask = 0x1 << 1
        addChild(object)

        // Reduce the spawn interval to increase difficulty over time
        spawnInterval = max(spawnInterval * 0.95, 0.5)
    }
    
    func checkGameOver() {
        guard let greenCube = greenCube else { return }
        if greenCube.position.y < -self.size.height / 2 { // Check if cube is below the visible screen
            gameOver = true
            showRestartButton()
        }
    }

    func showRestartButton() {
        if let symbolImage = UIImage(systemName: "arrow.counterclockwise.circle") {
                let texture = SKTexture(image: symbolImage)
                let restartButton = SKSpriteNode(texture: texture)
                restartButton.color = SKColor.label  // Optional: if you want to apply tint color
                restartButton.size = CGSize(width: 60, height: 60)  // Adjust size as needed
                restartButton.position = CGPoint(x: 0, y: 0)
                restartButton.name = "restartButton"
                self.addChild(restartButton)
            } else {
                print("Failed to create the SF Symbol image")
            }
    }

    
    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        sceneDidLoad() // Reinitialize the scene setup
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Check game over state before running update logic
        if gameOver {
            return
        }
        
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        if currentTime - lastSpawnTime > spawnInterval {
            lastSpawnTime = currentTime
            spawnObject()
        }
        
        checkGameOver()
    }
}
