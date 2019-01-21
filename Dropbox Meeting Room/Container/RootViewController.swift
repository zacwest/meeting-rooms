//
//  RootViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    let container = UINavigationController()
    
    private var displayables: [(RootDisplayable & UIViewController).Type] {
        return [
            PermissionViewController.self,
            CalendarSelectViewController.self,
            OfficeNameSelectViewController.self,
        ]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        container.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.navigationBar.prefersLargeTitles = true
        
        addChild(container)
        view.addSubview(container.view)
        container.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if container.viewControllers.isEmpty {
            advance()
        }
    }
}

extension RootViewController: RootDisplayableDelegate {
    func advance() {
        if let controllerType = displayables.first(where: { $0.shouldDisplay }) {
            container.viewControllers = [ controllerType.init() ]
        }
    }
}

extension RootViewController: UINavigationControllerDelegate {
    
}
