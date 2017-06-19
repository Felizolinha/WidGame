# WidGame
WidGame is an easy way to use SpriteKit for devoloping your own iOS Widgets games.

# Features

* Easily use *SpriteKit* on your widget
 
* Easily change your widget view expandability status("Show More" and "Show Less") and height

* Easily detect widget events from your scene

# Usage

## Inherit your Scene from WGScene
```swift
public class YourScene: WGScene { }
```
## Inherit your Widget View Controller to WGViewController
```swift
public class YourWidgetViewController: WGViewController { }
```


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

### Download [this](https://github.com/Felizolinha/WidGame/tree/master/Example) project to see an example of the framework working

### See [WidGame.swift](https://github.com/Felizolinha/WidGame/blob/master/WidGame/WidGame/WidGame.swift) for more details about the implementation of this features
