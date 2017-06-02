//
//  TodayViewController.swift
//  GameExtension
//
//  Created by Matheus Felizola Freires on 01/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import NotificationCenter
import SpriteKit

class GameScene : SKScene {
    var imageNode: SKSpriteNode?
    override func didMove(to view: SKView) {
        imageNode = SKSpriteNode(imageNamed:"Grafo.png")
        addChild(imageNode!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { imageNode?.position = t.location(in: self)}
    }
}



public protocol WGViewDelegate {
    func changeExpandability(view: WGView, shouldBeExpandable value: Bool) -> Void
    func initializeGameView(view: WGView) -> Void
}



public class WGView: UIView {
    public var delegate: WGViewDelegate?

    @IBInspectable var isExpandable: Bool = false

    @IBInspectable var maxHeight: CGFloat = 110

    public var gameView: SKView!

    override public func willMove(toWindow newWindow: UIWindow?) {
        self.gameView.frame = self.frame
        delegate?.changeExpandability(view: self, shouldBeExpandable: isExpandable)
        delegate?.initializeGameView(view: self)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? WGView {
            if obj == self && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.gameView.frame = CGRect(origin: self.gameView.frame.origin, size: newSize)
                }
            }
        }
    }

    override public func awakeFromNib() {
        self.gameView = SKView()

        super.awakeFromNib()
    }
}




public class WGViewController: UIViewController, NCWidgetProviding, WGViewDelegate {
    public var contentView:WGView!
    public var gameView: SKView!

    public func initializeGameView(view: WGView) {
        let scene = GameScene(size: view.frame.size) //ESCOLHER SKSCENE
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill //Parâmetro Default
        // Present the scene
        gameView.presentScene(scene)
        view.addSubview(gameView)
    }


    public func changeExpandability(view: WGView, shouldBeExpandable value: Bool) {
        if contentView.isExpandable == true {
            if #available(iOSApplicationExtension 10.0, *) {
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                // Fallback on earlier versions
            }
        }
    }

    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: contentView.maxHeight)
            //contentView.gameView.frame = CGRect(origin: contentView.gameView.frame.origin, size: CGSize(width: maxSize.width, height: contentView.maxHeight))
        } else {
            preferredContentSize = maxSize
            //contentView.gameView.frame = CGRect(origin: contentView.gameView.frame.origin, size: maxSize)
            
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        contentView = view as! WGView
        gameView = contentView.gameView
        contentView.delegate = self

        contentView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //contentView = WGView(frame: view.frame)
        //view.addSubview(contentView)


    }
}
