//
//  TouchableButton.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/5/22.
//  Copyright © 2018年 nixWork. All rights reserved.
//

import UIKit

open class TouchableButton: UIButton {

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let minWidth: CGFloat = 44
        let minHeight: CGFloat = 44
        let dx = bounds.width < minWidth ? (bounds.width - minWidth) / 2 : 0
        let dy = bounds.height < minHeight ? (bounds.height - minHeight) / 2 : 0
        let area = bounds.insetBy(dx: dx, dy: dy)
        return area.contains(point)
    }
}
