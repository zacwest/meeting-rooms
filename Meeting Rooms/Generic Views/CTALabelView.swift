//
//  CTALabelView.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class CTALabelView: CTAView<UILabel> {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        with(centerView) {
            $0.font = UIFont.systemFont(ofSize: 24.0, weight: .regular)
            $0.adjustsFontForContentSizeCategory = true
            $0.numberOfLines = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
