//
//  MVVMRouter.swift
//  Router
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

public protocol MVVMView {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
}

public class MVVMRouter {
    public typealias RouteCompletion = () -> Void
    
    ///Selects a view controller in UITabBarController navigation stack
    ///
    ///
    ///**equivalent to UITabBarController selectedViewController,
    ///but searches for specific view controller even if it's embedded into navigation controller**
    public static func open
        <From: UIViewController & MVVMView, To: UIViewController & MVVMView>
        (_ to: To.Type, from: From, animated: Bool = true)
        where
        From.ViewModel: Routable,
        To.ViewModel: Routable {
            guard let tabBarController = from.tabBarController
                else { fatalError("Not found tabBarController on \(from) navigation stack") }
            
            guard let vc = tabBarController.viewControllers?.first(where: { (vc: UIViewController) in
                if let navCon = vc as? UINavigationController,
                    let to = navCon.visibleViewController as? To {
                    guard match(input: to.viewModel.input, output: from.viewModel.output)
                        else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
                    return true
                }
                if let to = vc as? To {
                    guard match(input: to.viewModel.input, output: from.viewModel.output)
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
        <From: UIViewController & MVVMView, To: UIViewController & MVVMView>
        (_ to: To.Type, from: From, animated: Bool = true)
        where
        From.ViewModel: Routable,
        To.ViewModel: Routable {
            let to = to.init()
            guard match(input: to.viewModel.input, output: from.viewModel.output)
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
        <From: UIViewController & MVVMView, To: UIViewController & MVVMView>
        (_ to: To.Type, from: From, animated: Bool = true, completion: RouteCompletion? = nil)
        where
        From.ViewModel: Routable,
        To.ViewModel: Routable {
            let to = to.init()
            guard match(input: to.viewModel.input, output: from.viewModel.output)
                else { fatalError("Input of \(To.self) doesn't match Output of \(From.self)") }
            from.present(to, animated: animated, completion: completion)
    }
    
    private static func match(input: [Input], output: [Output]) -> Bool {
        var outputDict = [Int: Output]()
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

