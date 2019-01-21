//
//  OfficeNameSelectView.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class OfficeNameSelectView: UIView {
    let ctaView = with(CTAPickerView()) {
        $0.ctaButton.setTitle(NSLocalizedString("Select Office", comment: ""), for: .normal)
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
