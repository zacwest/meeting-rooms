//
//  UIView+Additions.swift
//  Upcoming Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

extension UIView {
    func wrapped(with visualEffect: UIVibrancyEffect) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: visualEffect)
        
        with(effectView.contentView) { contentView in
            self.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(self)
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: contentView.topAnchor),
                bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        }
        
        return effectView
    }
}
