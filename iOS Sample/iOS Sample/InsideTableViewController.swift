//
//  InsideTableViewController.swift
//  iOS Sample
//
//  Created by YOSHIMUTA YOHEI on 2018/10/03.
//  Copyright © 2018 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import PagingKit

class InsideTableViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    enum Row: Int, CaseIterable {
        case collapse
        case menu
        case content
        
        static var numberOfRows: Int {
            return Row.allCases.count
        }
        
        func height(tableView: UITableView) -> CGFloat {
            switch self {
            case .collapse:
                return UITableView.automaticDimension
            case .menu:
                return 44
            case .content:
                return tableView.bounds.height - 44
            }
        }
    }
    
    var isCollapsed = true
    
    // initializes on code
    let contentViewController = PagingContentViewController()
    let menuViewController = PagingMenuViewController()
    
    
    let dataSource: [(menu: String, content: UIViewController)] = ["Martinez", "Alfred", "Louis", "Justin"].map {
        let title = $0
        let vc = UIStoryboard(name: "ContentTableViewController", bundle: nil).instantiateInitialViewController() as! ContentTableViewController
        return (menu: title, content: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // needs to set this because it initialize menu vc on code.
            menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // add menu vc on this vc.
            addChild(menuViewController)
            menuViewController.didMove(toParent: self)
            
            menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: "identifier")
            menuViewController.registerFocusView(view: UnderlineFocusView())
            
            // set delegate and datasource
            menuViewController.delegate = self
            menuViewController.dataSource = self
        }
        
        do {
            // needs to set this because it initialize content vc on code.
            contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // add content vc on this vc.
            addChild(contentViewController)
            contentViewController.didMove(toParent: self)
            
            // set delegate and datasource
            contentViewController.delegate = self
            contentViewController.dataSource = self
        }
        
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InsideTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Row.init(rawValue: indexPath.row)!.height(tableView: tableView)
    }
}

extension InsideTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row.init(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch row {
        case Row.collapse:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsideCollapseCell", for: indexPath)
                as! InsideCollapseCell
            cell.setContent(isCollapsed: isCollapsed) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.isCollapsed = !weakSelf.isCollapsed
                weakSelf.tableView.beginUpdates()
                weakSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
                weakSelf.tableView.endUpdates()
            }
            return cell
        case Row.menu:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsideMenuCell", for: indexPath)
                as! InsideMenuCell
            cell.setContent(controller: menuViewController)
            cell.contentView.addSubview(menuViewController.view)
            return cell
        case Row.content:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsideContentCell", for: indexPath)
                as! InsideContentCell
            cell.setContent(controller: contentViewController)
            cell.contentView.addSubview(contentViewController.view)
            return cell
        }
    }
}

extension InsideTableViewController: PagingMenuViewControllerDataSource {
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! TitleLabelMenuViewCell
        cell.titleLabel.text = dataSource[index].menu
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return viewController.view.bounds.width / CGFloat(dataSource.count)
    }
    
    var insets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
}

extension InsideTableViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
}

extension InsideTableViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension InsideTableViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
