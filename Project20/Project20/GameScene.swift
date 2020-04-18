//
//  GameScene.swift
//  Project20
//
//  Created by Luis Eduardo Gonzalez on 2020-02-17.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var numberOfLaunches = 0

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var gameOverLabel: SKLabelNode!
    var playAgainLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    fileprivate func startGame() {
        score = 0
        numberOfLaunches = 0
        fireworks.removeAll()
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self,
                                         selector: #selector(launchFireworks),
                                         userInfo: nil, repeats: true)
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 512, y: 150)
        addChild(scoreLabel)

        startGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }

    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }

    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800

        numberOfLaunches += 1

        if numberOfLaunches > 5 {
            gameTimer?.invalidate()
            gameOver()
            return
        }

        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)

        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        default:
            break
        }
    }

    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // Create a SKNode that acts as the framework container,
        // place at the specified position
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        // Create a rocket sprite node. Adjust colorBlenderFamily so we can color it
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        firework.color = Colors.allCases.randomElement()?.uiColor ?? .red

        // Create a UIBezierPath that will represent the movement of the firework
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))

        // Tell the container node to follow that path, turning itself as needed.
        let move = SKAction.follow(path.cgPath, asOffset: true,
                                   orientToPath: true, speed: 200)
        node.run(move)

        // Create particles behind the rocket to make it
        // look like the fireworks are lit.
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }

        // Add the firework to our fireworks array and also to the scene.
        fireworks.append(node)
        addChild(node)
    }

    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        if nodesAtPoint.contains(where: { $0.name == "playAgain" }) {
            gameOverLabel.removeFromParent()
            playAgainLabel.removeFromParent()
            startGame()
        }

        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }

    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)

            let remove = SKAction.run {
                emitter.removeFromParent()
            }

            emitter.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), remove]))
        }

        firework.removeFromParent()
    }

    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }

    func gameOver() {

        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.xScale = 0.001
        gameOverLabel.yScale = 0.001
        addChild(gameOverLabel)

        let gameOverAppear = SKAction.scale(to: 1.0, duration: 0.5)
        gameOverLabel.run(gameOverAppear)

        playAgainLabel = SKLabelNode(text: "Play Again")
        playAgainLabel.fontSize = 50
        playAgainLabel.fontColor = .white
        playAgainLabel.position = CGPoint(x: 512, y: -50)
        playAgainLabel.name = "playAgain"
        addChild(playAgainLabel)

        let playAgainAppear = SKAction.move(to: CGPoint(x: 512, y: 70), duration: 0.5)

        playAgainLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), playAgainAppear]))
    }
}
