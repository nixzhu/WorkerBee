//
//  SafeDispatch.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

final public class SafeDispatch {

    private static let shared = SafeDispatch()

    private let mainQueueKey = DispatchSpecificKey<Int>()
    private let mainQueueValue = Int(1)

    private init() {
        DispatchQueue.main.setSpecific(key: mainQueueKey, value: mainQueueValue)
    }

    public class func async(on queue: DispatchQueue = DispatchQueue.main, for work: @escaping () -> Void) {
        if queue === DispatchQueue.main {
            if DispatchQueue.getSpecific(key: shared.mainQueueKey) == shared.mainQueueValue {
                work()
            } else {
                DispatchQueue.main.async {
                    work()
                }
            }
        } else {
            queue.async {
                work()
            }
        }
    }
}
