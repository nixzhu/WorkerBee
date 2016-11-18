//
//  CancelableTask.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

public class CancelableTask {
    public typealias Work = () -> Void
    var work: Work?
    public init(delay time: TimeInterval, work: Work?) {
        self.work = work
        let deadline = DispatchTime.now()
            + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            self?.work?()
        }
    }
    public func cancel() {
        work = nil
    }
}
