//
//  ViewController.swift
//  Router
//
//  Created by Denis Litvin on 08.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var someColor = UIColor.red

    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .green
        navigationItem.title = "FromVC"
        tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        Router.push(ToVC.self, from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ViewController: Routable {
    
    var input: [Input] {
        return []
    }
    var output: [Output] {
        return [
            Route.backColor.output(someColor)
        ]
    }
}


class ToVC: UIViewController, Routable {
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "ToVC"
        self.view.backgroundColor = .green
        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        Router.open(ToVC.self, from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
