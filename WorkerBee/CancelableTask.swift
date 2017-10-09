//
//  CancelableTask.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

final public class CancelableTask {

    private var workItem: DispatchWorkItem?

    public init(delay time: TimeInterval, work: @escaping () -> Void) {
        let workItem = DispatchWorkItem(block: work)
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: workItem)
    }

    public func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
