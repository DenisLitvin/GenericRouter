# GenericRouter
🛣 Fast and generic approach for making transitions between the view controllers with injection of dependencies 

## Usage

Each view controller needs to conform to `Routable`. 
It must provide input and output arrays.
Router will check if VC from which you present next VC has sufficient output to provide for next VC's input. 

```swift
 var input: [Input] {
        return [
            Route.backColor.input({ self.view.backgroundColor = $0 })
        ]
    }
    
    var output: [Output] {
        return [
            Route.backColor.output(UIColor.cyan)
        ]
    }
```    
