//
//  TodayViewController.swift
//  MyExtension
//
//  Created by Matheus Felizola Freires on 03/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import SpriteKit
import NotificationCenter

class MyScene: WGScene {
    var sprite: SKSpriteNode!
    var label: SKLabelNode!
    var menuLabel: SKLabelNode!
    var bottom: SKShapeNode!
    override init(size: CGSize) {
        super.init(size: size)
        sprite = SKSpriteNode(imageNamed: "")
        label = SKLabelNode()
        menuLabel = SKLabelNode()
        bottom = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: 110)))
        bottom.fillColor = .blue
        bottom.strokeColor = .clear
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.text = "Widget iniciou"
        menuLabel.text = "Menu"
        menuLabel.position = CGPoint(x: bottom.frame.width/2, y: bottom.frame.height/2)
        
        addChild(sprite)
        addChild(label)
        addChild(bottom)
        addChild(menuLabel)
    }
    
    override func didUpdateWidgetFrame(to frame: CGRect) {
        label.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
    }
    
    override func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        label.text = activeDisplayMode.rawValue == 1 ? "Expanded" : "Compact"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sprite.position = (touches.first?.location(in: self))!
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Implement your TodayViewController like this, it's advised not to change the name of your view controller, as it seems to cause some crashes.
class TodayViewController: WGViewController {
    override func viewDidLoad() {
    }
    override func presentInitialScene() {
        self.gameView?.presentScene(MyScene(size: (gameView?.bounds.size)!))
    }
}
