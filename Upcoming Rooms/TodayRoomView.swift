//
//  TodayRoomView.swift
//  Upcoming Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class TodayRoomView: UIView {
    let timeLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 1
    }
    let eventLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }
    let roomLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    let stackView = with(UIStackView()) {
        $0.axis = .vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        func wrappingVisualEffectView(effect: UIVibrancyEffect, containedView: UIView) -> UIView {
            let effectView = UIVisualEffectView(effect: effect)

            with(effectView.contentView) { contentView in
                containedView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(containedView)
                NSLayoutConstraint.activate([
                    containedView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    containedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    containedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    containedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            }
            
            return effectView
        }
        
        stackView.addArrangedSubview(timeLabel.wrapped(with: .widgetSecondary()))
        stackView.addArrangedSubview(roomLabel.wrapped(with: .widgetPrimary()))
        stackView.addArrangedSubview(eventLabel.wrapped(with: .widgetSecondary()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configure(with room: Room) {
        timeLabel.text = room.timeTitle
        eventLabel.text = room.eventTitle
        roomLabel.text = room.roomTitle
    }
}
