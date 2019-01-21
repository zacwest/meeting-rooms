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
    let timeLabel = with(UILabel()) { _ in
        
    }
    let eventLabel = with(UILabel()) { _ in
        
    }
    let roomLabel = with(UILabel()) { _ in
        
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
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(eventLabel)
        stackView.addArrangedSubview(roomLabel)
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
