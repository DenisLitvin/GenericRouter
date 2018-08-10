//
//  ViewController.swift
//  Router
//
//  Created by Denis Litvin on 08.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit


class ViewControllerViewModel: Routable {
    var someColor = UIColor.red
    
    var input: [Input] {
        return []
    }
    var output: [Output] {
        return [
            Route.backColor.output(someColor)
        ]
    }
}


class ViewController: UIViewController, MVVMView {
    
    let viewModel = ViewControllerViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .green
        navigationItem.title = "FromVC"
        tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        MVVMRouter.push(ToVC.self, from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ToVCViewModel: Routable {
    var viewColor: UIColor = .green {
        willSet {
            print(newValue.debugDescription)
        }
    }
    
    var input: [Input] {
        return [
            Route.backColor.input({ self.viewColor = $0 })
        ]
    }
    
    var output: [Output] {
        return [
            Route.backColor.output(UIColor.cyan)
        ]
    }
}

class ToVC: UIViewController, MVVMView {
    let viewModel = ToVCViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "ToVC"
        self.view.backgroundColor = .green
        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        MVVMRouter.push(ToVC.self, from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ViewController {
    @objc func injected() {
        print("INJECTED")
        let vc = UITabBarController()
        vc.addChildViewController(UINavigationController(rootViewController: ToVC()))
        vc.addChildViewController(UINavigationController(rootViewController: ViewController()))
        UIApplication.shared.keyWindow?.rootViewController = vc
//        vc.viewDidLoad()
    }
}
