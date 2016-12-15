//
//  UITableView+WorkerBee.swift
//  WorkerBee
//
//  Created by NIX on 2016/12/15.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

public extension UITableView {

    public func workerbee_scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool) {
        guard numberOfSections > indexPath.section else { return }
        guard numberOfRows(inSection: indexPath.section) > indexPath.row else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
