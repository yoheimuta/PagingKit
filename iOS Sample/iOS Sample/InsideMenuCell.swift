//
//  InsideMenuCell.swift
//  iOS Sample
//
//  Created by YOSHIMUTA YOHEI on 2018/10/04.
//  Copyright © 2018 Kazuhiro Hayashi. All rights reserved.
//

import PagingKit
import UIKit

final class InsideMenuCell: UITableViewCell {
    
    private var controller: PagingMenuViewController!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if #available(iOS 11.0, *) {
        contentView.addConstraints([
            contentView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: controller.view.topAnchor),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
            contentView.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: controller.view.leftAnchor),
            contentView.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: controller.view.rightAnchor)
            ])
        } else {
            fatalError("works only ios 11.0~")
        }
        
        controller.reloadData()
    }
    
    func setContent(controller: PagingMenuViewController) {
        self.controller = controller
    }
}
