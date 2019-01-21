//
//  RootDisplayable.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation

protocol RootDisplayableDelegate: class {
    func advance()
}

protocol RootDisplayable: class {
    static var shouldDisplay: Bool { get }
    /* weak */ var delegate: RootDisplayableDelegate? { get set }
}
