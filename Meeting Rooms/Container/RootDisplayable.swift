//
//  RootDisplayable.swift
//  Meeting Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation

protocol RootDisplayableDelegate: class {
    func advance()
    func showSettings(sender: Any)
}

protocol RootDisplayable: class {
    static var shouldDisplay: Bool { get }
    static var canBeRedisplayed: Bool { get }
    static var redisplayTitle: String? { get }
    /* weak */ var delegate: RootDisplayableDelegate? { get set }
}
