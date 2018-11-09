//
//  Router.swift
//  Router
//
//  Created by Denis Litvin on 08.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

public protocol Route {}

public protocol AnyInput: Route {
    var closure: (Any) -> () {get}
    var type: String {get}
}

public protocol AnyOutput: Route {
    var value: Any {get}
    var type: String {get}
}

public struct Input<Item>: AnyInput {
    public typealias ItemSetter = (Item) -> Void

    public let closure: (Any) -> ()
    public let type: String
    
    init(_ closure: @escaping ItemSetter) {
        self.closure = { (value) in
            guard let item = value as? Item
                else { fatalError("Could not cast \(value) as \(Item.self)") }
            closure(item)
        }
        self.type = String(describing: Item.self)
    }
}

public struct Output<Item>: AnyOutput {
    public let value: Any
    public let type: String
    
    init(_ value: Item) {
        self.value = value
        self.type = String(describing: Item.self)
    }

}
//public struct Route<Item> {
//
//    public typealias ItemSetter = (Item) -> Void
//
//    func input(_ closure: @escaping ItemSetter) -> Input {
//        return Input(
//            closure: { (value) in
//                guard let item = value as? Item
//                    else { fatalError("Could not cast \(value) as \(Item.self)") }
//                closure(item) },
//            type: String(describing: Item.self)
//        )
//    }
//
//    func output(_ value: Item) -> Output {
//        return Output(value: value as Any, type: String(describing: Item.self))
//    }
//}

public protocol Routable {
//    var input: [Input] { get }
//    var output: [Output] { get }
    var routes: [Route] { get }
    func didSetDependencies()
}

extension Routable {
    func didSetDependencies() {}
    
    var input: [AnyInput] {
        return routes.filter { $0 is AnyInput } as! [AnyInput]
    }
    
    var output: [AnyOutput] {
        return routes.filter { $0 is AnyOutput } as! [AnyOutput]
    }
}

public struct Router {
    public typealias RouteCompletion = () -> Void
    
    ///Selects a view controller in UITabBarController navigation stack
    ///
    ///
    ///**equivalent to UITabBarController selectedViewController,
    ///but searches for specific view controller even if it's embedded into navigation controller**
    public static func open
        <From: UIViewController, To: UIViewController>
        (_ to: To.Type, from: From, animated: Bool = true)
        where
        From: Routable,
        To: Routable {
            guard let tabBarController = from.tabBarController
                else { fatalError("Not found tabBarController on \(from) navigation stack") }
            
            guard let vc = tabBarController.viewControllers?.first(where: { (vc: UIViewController) in
                if let navCon = vc as? UINavigationController,
                    let to = navCon.visibleViewController as? To {
                    guard match(input: to.input, output: from.output)
                        else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
                    return true
                }
                if let to = vc as? To {
                    guard match(input: to.input, output: from.output)
                        else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
                    return true
                }
                return false
            }) else { fatalError("Not found ViewController of type \(To.self) as a child of \(tabBarController)") }
            
            tabBarController.selectedViewController = vc
    }
    
    ///Pushes a view controller onto UINavigationController navigation stack
    ///
    ///
    ///**equivalent to UINavigationController pushViewController(_:)**
    public static func push
        <From: UIViewController, To: UIViewController>
        (_ to: To.Type, from: From, animated: Bool = true)
        where
        From: Routable,
        To: Routable {
            let to = to.init()
            guard match(input: to.input, output: from.output)
                else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
            guard let navController = from.navigationController
                else { fatalError("Not found navigationController on \(from)") }
            navController.pushViewController(to, animated: animated)
    }
    
    ///Presents a view controller modally
    ///
    ///
    ///**equivalent to UIViewController present(_:)**
    public static func present
        <From: UIViewController, To: UIViewController>
        (_ to: To.Type, from: From, animated: Bool = true, completion: RouteCompletion? = nil)
        where
        From: Routable,
        To: Routable {
            let to = to.init()
            guard match(input: to.input, output: from.output)
                else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
            from.present(to, animated: animated, completion: completion)
    }
    
    private static func match(input: [AnyInput], output: [AnyOutput]) -> Bool {
        var outputDict = [String: AnyOutput]()
        for item in output {
            outputDict[item.type] = item
        }
        for item in input {
            guard let output = outputDict[item.type]
                else { return false }
            item.closure(output.value)
        }
        return true
    }
}


