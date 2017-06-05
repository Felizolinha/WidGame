# WidGame
WidGame is an easy way to use SpriteKit for devoloping your own iOS Widgets games.

# Features

* Easily add a *SKScene* to your widget
 
* Easily change your widget view expandability status("Show More" and "Show Less") and heigth

* Easily change your scene according to your widget view size

# Usage

## Inherit your Scene from WGScene
```swift
public class YourScene: WGScene { }
```
## Inherit your TodayViewController to WGViewController
```swift
public class TodayViewController: WGViewController { }
```

## Changing the size and expandability attribute of your widget in attribute inspector

![image](https://github.com/Felizolinha/WidGame/blob/master/ReadmeImages/image.png)


## Presenting your initial scene
```swift
public func presentInitialScene() {
    //Override this method to show your first scene
}
```

## Adapt your scene to expandability of your widget view
```swift
func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    //Add code for when your view change it expandability status
    
    //Don't forget to call super.widgetActiveDisplayModeDidChange(activeDisplayMode, withMaximumSize: maxSize) on your code!
}
```

```swift
func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { 
     //Add code for when your view will change it expandability status
        
    //Don't forget to call super.viewWillTransition(to: size, with: coordinator) on your code!
}
```


### See [WidGame.swift](https://github.com/Felizolinha/WidGame/blob/master/WidGame/WidGame/WidGame.swift) for more details about the implementation of this features
