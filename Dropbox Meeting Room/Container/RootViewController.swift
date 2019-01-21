//
//  RootViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class RootViewController: UIViewController {
    let container = UINavigationController()
    
    private var displayables: [(RootDisplayable & UIViewController).Type] {
        return [
            PermissionViewController.self,
            CalendarSelectViewController.self,
            OfficeNameSelectViewController.self,
            RoomListViewController.self,
        ]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        container.delegate = self
    }
    
    convenience init(controller: RootDisplayable & UIViewController) {
        self.init(nibName: nil, bundle: nil)
        container.viewControllers = [ controller ]
        controller.delegate = self
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
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if let controllerType = displayables.first(where: { $0.shouldDisplay }) {
            let controller = with(controllerType.init()) {
                $0.delegate = self
            }
            container.setViewControllers([ controller ], animated: !container.viewControllers.isEmpty)
        }
    }
    
    func showSettings(sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        with(alertController.popoverPresentationController) {
            if let sender = sender as? UIBarButtonItem {
                $0?.barButtonItem = sender
            } else if let sender = sender as? UIView {
                $0?.sourceView = sender
                $0?.sourceRect = sender.bounds
            }
        }
        
        for controllerType in displayables where controllerType.canBeRedisplayed {
            alertController.addAction(UIAlertAction(title: controllerType.redisplayTitle, style: .default, handler: { [weak self] _ in
                let another = RootViewController(controller: controllerType.init())
                self?.present(another, animated: true, completion: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension RootViewController: UINavigationControllerDelegate {
    @objc private func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if presentingViewController != nil {
            viewController.navigationItem.leftBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
            ]
        }
    }
}
