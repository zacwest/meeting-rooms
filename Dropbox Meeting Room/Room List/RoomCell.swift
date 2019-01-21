//
//  RoomCell.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class RoomCell: UITableViewCell {
    static let reuseIdentifier = "RoomCell"
    
    let timeLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 1
    }
    let zoomButton = with(UIButton(type: .system)) {
        with($0.titleLabel) {
            $0?.font = UIFont.preferredFont(forTextStyle: .headline)
            $0?.adjustsFontForContentSizeCategory = true
        }
        $0.contentHorizontalAlignment = .leading
        $0.setTitle(NSLocalizedString("Join Zoom Meeting", comment: ""), for: .normal)
    }
    let eventLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }
    let roomLabel = with(UILabel()) {
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    let stackView = with(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = 4.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(roomLabel)
        stackView.addArrangedSubview(eventLabel)
        stackView.addArrangedSubview(zoomButton)
        
        selectedBackgroundView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        with(selectedBackgroundView) {
            $0?.backgroundColor = tintColor
        }
        
        with(zoomButton) {
            $0.tintColor = tintColor
        }
    }
    
    func configure(room: Room) {
        timeLabel.text = room.timeTitle
        
        if let eventTitle = room.eventTitle {
            eventLabel.text = eventTitle
            eventLabel.isHidden = false
        } else {
            eventLabel.isHidden = true
        }
        
        roomLabel.text = room.roomTitle
        zoomButton.isHidden = room.isPastEvent || room.zoomURL == nil
        
        let textColor: UIColor = room.isPastEvent ? .gray : .black
        timeLabel.textColor = textColor
        eventLabel.textColor = textColor
        roomLabel.textColor = textColor
    }
}
