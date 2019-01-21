//
//  OfficeNameSelectViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit

class OfficeNameSelectViewController: UIViewController {
    private var officeNameSelectView: OfficeNameSelectView { return view as! OfficeNameSelectView }
    weak var delegate: RootDisplayableDelegate?
    
    override func loadView() {
        view = OfficeNameSelectView()
    }
}

extension OfficeNameSelectViewController: RootDisplayable {
    static var shouldDisplay: Bool {
        return true
    }
}
