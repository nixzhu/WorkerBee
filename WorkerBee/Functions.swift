//
//  Functions.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

public class Function {

    public class func delay(_ time: TimeInterval, work: @escaping () -> Void) {
        _ = CancelableTask(delay: time, work: work)
    }

    public class func doInNextRunLoop(_ work: @escaping () -> Void) {
        delay(0, work: work)
    }
}
