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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configure(with rooms: [Room]) {
        var roomViews = stackView.arrangedSubviews.compactMap { $0 as? TodayRoomView }
        
        if roomViews.count == rooms.count {
            
        } else if roomViews.count > rooms.count {
            roomViews[rooms.count...].forEach { $0.removeFromSuperview() }
            roomViews.removeSubrange(rooms.count...)
        } else {
            for _ in 0 ..< (rooms.count - roomViews.count) {
                let view = TodayRoomView()
                roomViews.append(view)
                stackView.addArrangedSubview(view)
            }
        }
        
        roomViews.enumerated().forEach { idx, roomView in
            roomView.configure(with: rooms[idx])
        }
    }
}

