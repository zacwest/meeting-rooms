//
//  TodayView.swift
//  Upcoming Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class TodayView: UIView {
    let stackView = with(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = 24.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            with(stackView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor)) {
                $0.priority = .defaultHigh
            },
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            with(stackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)) {
                $0.priority = .defaultHigh
            },
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configureForRequiresOnboarding() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(with(UILabel()) {
            $0.textAlignment = .center
            $0.text = NSLocalizedString("Launch the App to get started", comment: "")
            $0.font = UIFont.preferredFont(forTextStyle: .body)
        }.wrapped(with: .widgetSecondary()))
    }
    
    func configure(with rooms: [Room], hiding: Range<Int>) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if rooms.isEmpty {
            stackView.addArrangedSubview(with(UILabel()) {
                $0.textAlignment = .center
                $0.text = NSLocalizedString("No Events", comment: "")
                $0.font = UIFont.preferredFont(forTextStyle: .body)
            }.wrapped(with: .widgetPrimary()))
        } else {
            // todo: reuse
            rooms.map { room in
                return with(TodayRoomView()) {
                    $0.configure(with: room)
                }
            }.enumerated().forEach { idx, view in
                stackView.addArrangedSubview(view)
                view.isHidden = hiding.contains(idx)
            }
        }
    }
}

