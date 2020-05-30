# GenericRouter
🛣 Fast and generic approach for making transitions between the view controllers with injection of dependencies 

## Usage

Each view controller needs to conform to `Routable`. 
It must provide input and output arrays.
Router will check if VC from which you present next VC has output sufficient to provide for next VC's input. For each input you make, the view controller has to have output to match.

```swift
class ViewControllerA: Routable {

    var routes: [Route] {
        return [
            Output<String>("Pushed from ViewControllerA")
        ]
    }
    
}
class ViewControllerB: Routable {

    var routes: [Route] {
        return [
            Input<String> { self.nsvigationItem.title = $0 }
        ]
    }
    
}

// ViewControllerB will have nav bar title 'Pushed from ViewControllerA'
Router.push(ViewControllerB(), from:ViewControllerA(), animated:true)

```    
