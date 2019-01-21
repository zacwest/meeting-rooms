//
//  OfficeNameSelectViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

class OfficeNameSelectViewController: UIViewController {
    private var officeNameSelectView: OfficeNameSelectView { return view as! OfficeNameSelectView }
    weak var delegate: RootDisplayableDelegate?
    
    private let settings = Settings()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        title = OfficeNameSelectViewController.redisplayTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = OfficeNameSelectView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        with(officeNameSelectView.ctaView.centerView) {
            $0.delegate = self
            $0.dataSource = self
            
            if let officeName = settings.officeName, let index = Settings.OfficeName.allCases.firstIndex(of: officeName) {
                $0.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        officeNameSelectView.ctaView.ctaButton.addTarget(self, action: #selector(choose(_:)), for: .touchUpInside)
    }
    
    @objc private func choose(_ sender: UIButton) {
        settings.officeName = Settings.OfficeName.allCases[officeNameSelectView.ctaView.centerView.selectedRow(inComponent: 0)]
        delegate?.advance()
    }
}

extension OfficeNameSelectViewController: RootDisplayable {
    static var shouldDisplay: Bool {
        return Settings().officeName == nil
    }
    
    static var canBeRedisplayed: Bool {
        return true
    }
    
    static var redisplayTitle: String? {
        return NSLocalizedString("Select Office", comment: "")
    }
}

extension OfficeNameSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Settings.OfficeName.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Settings.OfficeName.allCases[row].rawValue
    }
}
