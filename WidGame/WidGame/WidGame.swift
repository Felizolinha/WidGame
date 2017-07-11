//
//  WidGame.swift
//  NewGame
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 19/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation
import SpriteKit
import NotificationCenter

/**
 Defines which widget properties can be changed from the game scene.
 - author: Matheus Felizola Freires
 */
public protocol WGDelegate {
    ///A bool that defines if the widget should be expandable or not.
    var isExpandable:Bool {get set}
    ///A CGFloat that defines the widget's maximum height.
    var maxHeight:CGFloat {get set}
}

/**
 All your widget game scenes should inherit from this class, instead of SKScene.
 - author: Matheus Felizola Freires
 */
open class WGScene:SKScene {
    /**
     Called when the active display mode changes.

     You should override this method if you need to update your scene when the widget changes it's display mode.

     The default implementation of this method is blank.
     - parameters:
     - activeDisplayMode: The new active display mode. See NCWidgetDisplayMode for possible values.
     - maxSize: A CGSize object that represents the new maximum size this widget can have.
     */
    open func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {}

    /**
     Called when the widget's frame changes.

     You should override this method if you need to update your scene when the widget updates it's frame. This usually happens when the widget is transitioning to a different display mode, or to a new preferred content size.

     The default implementation for this method is blank.
     - parameters:
     - frame: A CGRect with the new frame size of the widget.

     - author: Matheus Felizola Freires
     */
    open func didUpdateWidgetFrame(to frame: CGRect) {}

    /**
     Allows your game scene to change the widget's expandability or maximum height.

     Example of how to change the maximum height of your widget:

     widgetDelegate.maxHeight = 200
     */
    open var widgetDelegate: WGDelegate?

    /**
     Creates your scene object.
     - parameters:
     - size: The size of the scene in points.
     - controller: The WGDelegate compliant view controller that is creating the scene.
     - returns: A newly initialized WGScene object.
     */
    public init(size: CGSize, controller: WGDelegate) {
        super.init(size: size)

        widgetDelegate = controller
        scaleMode = SKSceneScaleMode.resizeFill
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 Your TodayViewController should inherit from WGViewController to implement WidGame's functionalities.
 - author: Matheus Felizola Freires
 */
open class WGViewController: UIViewController, NCWidgetProviding, WGDelegate {
    ///The SKView that will present your WidGame scenes.
    open var gameView: SKView?

    /**
     An enum that provides the reasons which your widget might close.
     - author: Matheus Felizola Freires
     */
    public enum ExitReason {
        case leftTheScreen
        case memoryWarning
    }


    @IBInspectable
    open var isExpandable: Bool = true {
        didSet {
            changeExpandability(to: isExpandable)
        }
    }
    open var maxHeight:CGFloat = 359 {
        didSet {
            if extensionContext?.widgetActiveDisplayMode == .expanded {
                preferredContentSize = CGSize(width: preferredContentSize.width, height: maxHeight)
            }
        }
    }

    /**
     Sets the widget expandability.
     - parameter value: A Bool value that tells the method if it should make the widget expandable or not.
     - requires: iOS 10.0
     - TODO: Create a fallback to versions earlier than iOS 10.0
     - author: Matheus Felizola Freires
     */
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


    /**
     Notifies the view controller that its view was removed from a view hierarchy.
     You can override this method to perform additional tasks associated with dismissing or hiding the view. If you override this method, you must call super at some point in your implementation.
     - parameter animated: If true, the disappearance of the view was animated.
     */
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.widgetMightClose(reason: .leftTheScreen)
    }

    /**
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. If you do, your implementation of this method must call the super implementation at some point.
     */
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.widgetMightClose(reason: .memoryWarning)
    }

    /**
     Called when the widget is in a situation that it might be closed. An exit reason is provided to the method, so your logic can react accordingly.

     This method should be used for your save logic.

     The default implementation of this method is blank.
     - TODO: Find out if there are more things that might cause the widget to close.
     - author: Matheus Felizola Freires
     */
    open func widgetMightClose(reason: WGViewController.ExitReason) {}

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if gameView == nil {
            DispatchQueue.main.async { //Use a different thread to lower the chance of crash when leaving the widget screen and going back.
                [unowned self] in
                self.preferredContentSize = CGSize(width: 0, height: self.maxHeight)
                self.changeExpandability(to: self.isExpandable)
                self.gameView = SKView(frame: self.view.frame)

                self.presentInitialScene()
                self.view.addSubview(self.gameView!)
            }
        }
    }

    /**
     Override this method to show your first scene and load any saved info.

     The default implementation of this method is blank.
     - author: Matheus Felizola Freires
     */
    open func presentInitialScene() {}

    /**
     If you override the method below inside your TodayViewController, always call super at some point in your implementation so that WidGame can still update your gameView's frame and tell your game scene about these updates.
     */
    open override func viewDidLayoutSubviews() {
        gameView?.frame = view.frame //Update game view frame to reflect any changes in widget's size
        if let scene = gameView?.scene as? WGScene {
            scene.didUpdateWidgetFrame(to: view.frame)
        }

        super.viewDidLayoutSubviews()
    }

    /**
     If you override the method below inside your TodayViewController, always call super at some point in your implementation so that WidGame can still delegate displayMode changes to your WGScene, and set the correct preferredContentSize to your widget.
     */
    open func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: maxHeight)
        } else {
            preferredContentSize = maxSize
        }
        if let scene = gameView?.scene as? WGScene {
            scene.widgetActiveDisplayModeDidChange(activeDisplayMode, withMaximumSize: preferredContentSize)
        }
        //Don't forget to call super.widgetActiveDisplayModeDidChange(activeDisplayMode, withMaximumSize: maxSize) on your code!
    }
}
