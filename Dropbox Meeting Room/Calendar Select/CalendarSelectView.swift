//
//  CalendarSelectView.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class CalendarSelectView: UIView {
    let ctaView = with(CTAView()) {
        $0.descriptionLabel.text = NSLocalizedString("Choose which calendars you wish to be examined to find room information.", comment: "")
        $0.ctaButton.setTitle(NSLocalizedString("Choose Calendars", comment: ""), for: .normal)
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
