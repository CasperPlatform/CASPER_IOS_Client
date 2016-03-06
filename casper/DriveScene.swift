//
//  GameScene.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

class DriveScene: SKScene {
    
    var appleNode: SKSpriteNode?
    let setJoystickStickImageBtn = SKLabelNode(), setJoystickSubstrateImageBtn = SKLabelNode()
    
    var joystickStickImageEnabled = true {
        
        didSet {
            
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        
        didSet {
            
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
        }
    }
    // diameter 80 = 40 max in each direction
    let moveAnalogStick =  🕹(diameter: 120)
    
    override func didMoveToView(view: SKView) {

        /* Setup your scene here */
        backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        moveAnalogStick.position = CGPointMake(moveAnalogStick.radius + 15, moveAnalogStick.radius + 15)
        
        
        addChild(moveAnalogStick)
        moveAnalogStick.trackingHandler = { jData in
            
            guard let aN = self.appleNode else { return }
            aN.position = CGPointMake(aN.position.x + (jData.velocity.x * 0.12), aN.position.y + (jData.velocity.y * 0.12))
//            print(aN.position.y)
        }
        
        
        
        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        let joystickSizeLabel = SKLabelNode(text: "Joysticks Size:")
        joystickSizeLabel.fontSize = 20
        joystickSizeLabel.fontColor = UIColor.blackColor()
        joystickSizeLabel.horizontalAlignmentMode = .Left
        joystickSizeLabel.verticalAlignmentMode = .Top
        joystickSizeLabel.position = CGPoint(x: btnsOffset, y: self.frame.size.height - btnsOffset)
        addChild(joystickSizeLabel)

        /*
        jSizeMinusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizeMinusSpriteNode.position = CGPoint(x: CGRectGetMaxX(joystickSizeLabel.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        addChild(jSizeMinusSpriteNode)
        
        jSizePlusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizePlusSpriteNode.position = CGPoint(x: CGRectGetMaxX(jSizeMinusSpriteNode.frame) + btnsOffset, y: CGRectGetMidY(joystickSizeLabel.frame))
        addChild(jSizePlusSpriteNode)*/
        
        setJoystickStickImageBtn.fontColor = UIColor.blackColor()
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .Bottom
        setJoystickStickImageBtn.position = CGPointMake(CGRectGetMidX(self.frame), moveAnalogStick.position.y - btnsOffsetHalf)
        addChild(setJoystickStickImageBtn)
        
        setJoystickSubstrateImageBtn.fontColor  = UIColor.blackColor()
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .Top
        setJoystickSubstrateImageBtn.position = CGPointMake(CGRectGetMidX(self.frame), moveAnalogStick.position.y + btnsOffsetHalf)
        addChild(setJoystickSubstrateImageBtn)
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        setStickColor()
        setSubstrateColor()
        addApple(CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)))
    }
    
    func addApple(position: CGPoint) {
        
        guard let appleImage = UIImage(named: "apple") else { return }
        
        let texture = SKTexture(image: appleImage)
        let apple = SKSpriteNode(texture: texture)
        if #available(iOS 8.0, *) {
            apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
            apple.physicsBody!.affectedByGravity = false
        } else {
            // Fallback on earlier versions
        }
        
        //insertChild(apple, atIndex: 0)
        //apple.position = position
        //appleNode = apple
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            
            let node = nodeAtPoint(touch.locationInNode(self))
            
            switch node {
                
            /*case jSizePlusSpriteNode:
                moveAnalogStick.diameter += 1
                rotateAnalogStick.diameter += 1
            case jSizeMinusSpriteNode:
                moveAnalogStick.diameter -= 1
                rotateAnalogStick.diameter -= 1*/
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled

            default:
                addApple(touch.locationInNode(self))
            }
        }
    }
    
    func setStickColor() {
        
        let Color = UIColorFromRGB(3010454)
        moveAnalogStick.stick.color = Color
    }
    
    func setSubstrateColor() {
        
        let Color = UIColorFromRGB(2110536)
        moveAnalogStick.substrate.color = Color
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
