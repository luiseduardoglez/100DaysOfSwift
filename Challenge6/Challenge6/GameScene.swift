//
//  GameScene.swift
//  Challenge6
//
//  Created by Luis Eduardo Gonzalez on 2019-12-04.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var targets: [SKSpriteNode] = []

    var newTargetTimer: Timer?
    var gameTimer: Timer?

    var timerLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var clip: SKSpriteNode!
    var newGameLabel: SKLabelNode!

    var ammo = 3 {
        didSet {
            clip.texture = SKTexture(imageNamed: "shots\(ammo)")
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var timeRemaining = 60 {
        didSet {
            timerLabel.text = "\(timeRemaining)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.blendMode = .replace
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.size = view.frame.size
        background.name = "background"
        addChild(background)

        let grassBackground = SKSpriteNode(imageNamed: "grass-trees")
        grassBackground.zPosition = 1
        grassBackground.position = CGPoint(x: 512, y: 450)
        grassBackground.size = CGSize(width: view.frame.width,
                                      height: grassBackground.frame.height)
        grassBackground.name = "background"
        addChild(grassBackground)

        let waterBack = SKSpriteNode(imageNamed: "water-bg")
        waterBack.zPosition = 2
        waterBack.position = CGPoint(x: 512, y: 250)
        waterBack.size = CGSize(width: view.frame.width, height: waterBack.frame.height)
        waterBack.name = "background"
        addChild(waterBack)

        let waterFront = SKSpriteNode(imageNamed: "water-fg")
        waterFront.zPosition = 4
        waterFront.position = CGPoint(x: 512, y: 250)
        waterFront.size = CGSize(width: view.frame.width, height: waterFront.frame.height)
        waterFront.name = "background"
        addChild(waterFront)

        let animateWaterLeft = SKAction.move(by: CGVector(dx: -80, dy: 0), duration: 1.0)
        let animateWaterRight = SKAction.move(by: CGVector(dx: 80, dy: 0), duration: 1.0)

        let animateWaterLeftToRight = SKAction.repeatForever(SKAction.sequence([animateWaterLeft, animateWaterRight]))
        let animateWaterRightToLeft = SKAction.repeatForever(SKAction.sequence([animateWaterRight, animateWaterLeft]))

        waterFront.run(animateWaterLeftToRight)
        waterBack.run(animateWaterRightToLeft)

        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.zPosition = 6
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.size = view.frame.size
        curtains.name = "background"
        addChild(curtains)

        clip = SKSpriteNode(imageNamed: "shots3")
        clip.zPosition = 7
        clip.position = CGPoint(x: 512, y: 740)
        clip.name = "clip"
        addChild(clip)

        timerLabel = SKLabelNode(text: "60")
        timerLabel.zPosition = 7
        timerLabel.position = CGPoint(x: 50, y: 725)
        timerLabel.fontSize = 40
        timerLabel.fontColor = .white
        timerLabel.name = "background"
        addChild(timerLabel)

        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.zPosition = 7
        scoreLabel.position = CGPoint(x: 920, y: 725)
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.name = "background"
        addChild(scoreLabel)

        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        if nodesAtPoint.contains(where: { $0.name == "newGame" }) {
            gameOverLabel.removeFromParent()
            newGameLabel.removeFromParent()
            startGame()
        }

        if nodesAtPoint.contains(where: { $0.name == "clip" }) {
            reload()
            return
        }

        guard shoot(at: location) else { return }

        for case let node as SKSpriteNode in nodesAtPoint {
            switch node.name {
            case "normal":
                score += 5
                spriteHit(node: node)
            case "easy":
                score += 12
                spriteHit(node: node)
            case "bad":
                score -= 20
                spriteHit(node: node)
            default:
                continue
            }
        }
    }

    fileprivate func showAndRemoveCursor(_ position: CGPoint) {
        let crosshair = SKSpriteNode(imageNamed: "cursor")
        crosshair.zPosition = 8
        crosshair.position = position
        addChild(crosshair)

        let removeCrosshair = SKAction.run {
            crosshair.removeFromParent()
        }

        crosshair.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),removeCrosshair]))
    }

    func shoot(at position: CGPoint) -> Bool {
        if ammo > 0 {
            run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
            showAndRemoveCursor(position)
            ammo -= 1
            return true
        } else {
            run(SKAction.playSoundFileNamed("empty", waitForCompletion: false))
            return false
        }
    }

    func spriteHit(node: SKSpriteNode) {
        node.removeAllActions()
        node.name = "shot"

        let reduceSize = SKAction.scale(by: 0.85, duration: 0.05)
        let applyGravity = SKAction.run {
            node.physicsBody?.isDynamic = true
        }

        let sequence = SKAction.sequence([
            reduceSize,
            SKAction.wait(forDuration: 0.2),
            applyGravity,
            SKAction.wait(forDuration: 2.0),
            SKAction.removeFromParent()
            ])

        node.run(sequence)
    }

    func startGame() {

        run(SKAction.playSoundFileNamed("reload", waitForCompletion: false))

        score = 0
        ammo = 3
        timeRemaining = 60

        newTargetTimer?.invalidate()
        newTargetTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                              selector: #selector(addTarget), userInfo: nil, repeats: true)

        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime),
                                         userInfo: nil, repeats: true)
    }

    @objc func addTarget() {
        let target = randomTarget()
        target.physicsBody = SKPhysicsBody()
        target.physicsBody?.isDynamic = false
        locateAndRun(target: target)
    }

    func randomTarget() -> SKSpriteNode {
        var sprite = SKSpriteNode()
        switch Int.random(in: 0...11) {
        case 0...3:
            sprite = SKSpriteNode(imageNamed: "target1")
            sprite.name = "normal"
        case 4...7:
            sprite = SKSpriteNode(imageNamed: "target2")
            sprite.name = "normal"
        case 8:
            sprite = SKSpriteNode(imageNamed: "target0")
            sprite.name = "easy"
        case 9...11:
            sprite = SKSpriteNode(imageNamed: "red-duck")
            sprite.name = "bad"
        default:
            break
        }
        return sprite
    }

    func locateAndRun(target: SKSpriteNode) {
        if let row = Row.allCases.randomElement() {
            target.zPosition = row.zPosition
            target.position = row == .middle ? CGPoint(x: 1150, y: row.yPosition) : CGPoint(x: 50, y: row.yPosition)
            if row == .middle {
                target.xScale = -1
            }
            addChild(target)
            target.run(SKAction.move(by: CGVector(dx: row == .middle ? -1200 : 1200, dy: 0), duration: 3.0))
            targets.append(target)
        }
    }

    @objc func updateTime() {
        timeRemaining -= 1
        if timeRemaining == 0 {
            gameIsOver()
        }
    }

    fileprivate func removeTargetsFromParent() {
        for target in targets {
            target.removeFromParent()
        }

        targets.removeAll()
    }

    func showGameOverSprite() {
        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 100
        gameOverLabel.fontColor = .white
        gameOverLabel.zPosition = 8
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.xScale = 0.001
        gameOverLabel.yScale = 0.001
        gameOverLabel.name = "background"
        addChild(gameOverLabel)

        let gameOverAppear = SKAction.scale(to: 1.0, duration: 0.5)
        gameOverLabel.run(gameOverAppear)

        newGameLabel = SKLabelNode(text: "New Game")
        newGameLabel.fontSize = 50
        newGameLabel.fontColor = .white
        newGameLabel.zPosition = 8
        newGameLabel.position = CGPoint(x: 512, y: -50)
        newGameLabel.name = "newGame"
        addChild(newGameLabel)

        let newGameAppear = SKAction.move(to: CGPoint(x: 512, y: 70), duration: 0.5)

        newGameLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), newGameAppear]))
    }

    func gameIsOver() {
        gameTimer?.invalidate()
        newTargetTimer?.invalidate()

        removeTargetsFromParent()
        showGameOverSprite()
    }

    func reload() {
        guard ammo == 0 else { return }
        ammo = 3
        run(SKAction.playSoundFileNamed("reload", waitForCompletion: false))
    }

    override func update(_ currentTime: TimeInterval) {
        for (index, target) in targets.enumerated().reversed() {
            if target.position.x < 0 || target.position.x > 1200 || target.position.y < 0 {
                targets.remove(at: index)
                target.removeFromParent()
            }
        }
    }
}
