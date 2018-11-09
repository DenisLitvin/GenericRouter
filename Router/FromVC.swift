//
//  ViewController.swift
//  Router
//
//  Created by Denis Litvin on 08.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit


class FromVCViewModel: Routable {
    
    var string = "FromVC String" {
        willSet {
            print(newValue.debugDescription)
        }
    }
    
    var routes: [Route] {
        return [
            Input<String> { self.string = $0 },
            Output<String>("output of FromVC")
        ]
    }
}


class FromVC: UIViewController {
 
    let viewModel = FromVCViewModel()
    
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

extension FromVC: MVVMView {
    func didSetDependencies() {
    }
}

class ToVCViewModel: Routable {
    var routes: [Route] {
        return [
            Input<String> { self.string = $0 },
            Output<String>("output of ToVC")
        ]
    }
    var string: String = "ToVC string" {
        willSet {
            print(newValue.debugDescription)
        }
    }
}

class ToVC: UIViewController, MVVMView {
    func didSetDependencies() {
    }
    
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


extension FromVC {
    @objc func injected() {
        print("INJECTED")
        let vc = UITabBarController()
        vc.addChildViewController(UINavigationController(rootViewController: ToVC()))
        vc.addChildViewController(UINavigationController(rootViewController: FromVC()))
        UIApplication.shared.keyWindow?.rootViewController = vc
//        vc.viewDidLoad()
    }
}
