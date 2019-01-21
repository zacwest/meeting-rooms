//
//  CTAView.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class CTAView<CenterView: UIView>: UIView {
    let centerView = CenterView()
    
    let ctaButton = with(UIButton(type: .custom)) {
        with($0.layer) {
            $0.cornerRadius = 14.0
            $0.masksToBounds = true
        }
        
        $0.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.setTitleColor(.white, for: .normal)
        
        with($0.titleLabel) {
            $0?.font = UIFont.preferredFont(forTextStyle: .headline)
            $0?.adjustsFontForContentSizeCategory = true
        }
        
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    let stackView = with(UIStackView()) {
        $0.axis = .vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        
        stackView.addArrangedSubview(centerView)
        stackView.addArrangedSubview(ctaButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func tintColorDidChange() {
        ctaButton.setBackgroundImage(UIImage(patternColor: tintColor), for: .normal)
    }
}
