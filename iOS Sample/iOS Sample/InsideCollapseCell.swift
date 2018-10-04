//
//  InsideCollapseCell.swift
//  iOS Sample
//
//  Created by YOSHIMUTA YOHEI on 2018/10/04.
//  Copyright © 2018 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

final class InsideCollapseCell: UITableViewCell {
    
    @IBOutlet private var collapsableLabelOutlet: UILabel!
    @IBOutlet private var toggleOutlet: UIButton!
    
    typealias ToggleClosureFunc = () -> ()
    private var toggleClosure: ToggleClosureFunc!
    
    func setContent(isCollapsed: Bool, toggleClosure: @escaping ToggleClosureFunc) {
        if isCollapsed {
            collapsableLabelOutlet.numberOfLines = 1
            toggleOutlet.titleLabel?.text = "expand"
        } else {
            collapsableLabelOutlet.numberOfLines = 0
            toggleOutlet.titleLabel?.text = "collapse"
        }
        
        self.toggleClosure = toggleClosure
    }
    
    @IBAction func toggle(_ sender: AnyObject) {
        toggleClosure()
    }
}
