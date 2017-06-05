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

protocol WGDelegate {
    var isExpandable:Bool {get set}
    var maxHeight:CGFloat {get set}
}

public class WGScene:SKScene { //Remember to inherit from WGScene instead of SKScene when creating your WidGame
    var widgetDelegate: WGDelegate?
}

public class WGViewController: UIViewController, NCWidgetProviding, WGDelegate { //Inherit from WGViewController on your TodayViewController
    public var gameView: SKView?

    public var isExpandable: Bool = true { //Change this variable to change the expandability of your widget.
        didSet {
            changeExpandability(to: isExpandable)
        }
    }
    public var maxHeight:CGFloat = 359 { //Change this variable to change the maximum height of your widget.
        didSet {
            if extensionContext?.widgetActiveDisplayMode == .expanded {
                preferredContentSize = CGSize(width: preferredContentSize.width, height: 359)
            }
        }
    }

    private func changeExpandability(to value: Bool) {
        if value {
            if #available(iOSApplicationExtension 10.0, *) {
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOSApplicationExtension 10.0, *) {
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if gameView == nil {
            DispatchQueue.main.async { //Use a different thread to lower the chance of crash when leaving the widget screen and going back
                [unowned self] in
                self.changeExpandability(to: self.isExpandable)
                self.gameView = SKView(frame: self.view.frame)

                self.presentInitialScene()

                self.view.addSubview(self.gameView!)
            }

            print("\nCreated game view.")
        }
        //Don't forget to call super.viewWillTransition(to: size, with: coordinator) on your code!
    }

    public func presentInitialScene() {
        //Override this method to show your first scene
    }

    override public func viewDidLayoutSubviews() {
        gameView?.frame = view.frame //Update game view frame to reflect any changes in widget's size
        super.viewDidLayoutSubviews()
        //Don't forget to call super.viewDidLayoutSubviews() on your code!
    }

    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: maxHeight)
        } else {
            preferredContentSize = maxSize
        }
        //Don't forget to call super.widgetActiveDisplayModeDidChange(activeDisplayMode, withMaximumSize: maxSize) on your code!
    }
}

//Implement your TodayViewController like this, it's advised not to change the name of your view controller, as it seems to cause some crashes.
class TodayViewController: WGViewController {}
