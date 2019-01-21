//
//  PermissionView.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class PermissionView: UIView {
    let ctaView = with(CTALabelView()) {
        $0.centerView.text = NSLocalizedString("Locations and meeting rooms are read from the Calendars on your device. You gotta do this.", comment: "")
        $0.ctaButton.setTitle(NSLocalizedString("Grant Access", comment: ""), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        ctaView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ctaView)
        NSLayoutConstraint.activate([
            ctaView.topAnchor.constraint(equalTo: topAnchor),
            ctaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ctaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ctaView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
