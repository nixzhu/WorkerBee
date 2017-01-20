//
//  Functions.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

public func delay(_ time: TimeInterval, work: @escaping () -> Void) {
    guard time >= 0 else { fatalError("Only delay to the future!") }
    let deadline = DispatchTime.now()
        + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
        work()
    }
}

public func doInNextRunLoop(_ work: @escaping () -> Void) {
    delay(0, work: work)
}

public func mutate<A>(_ value: A, change: (inout A) -> Void) -> A {
    var copy = value
    change(&copy)
    return copy
}
