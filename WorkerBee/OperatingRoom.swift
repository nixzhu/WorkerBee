//
//  OperatingRoom.swift
//  WorkerBee
//
//  Created by nixzhu on 2017/1/19.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import Foundation

public class OperatingRoom {
    private let dispatchGroup: DispatchGroup

    public init() {
        self.dispatchGroup = DispatchGroup()
    }

    public typealias Finish = () -> Void
    public typealias Action = (@escaping Finish) -> Void

    public func prepare(in action: Action) {
        dispatchGroup.enter()
        action {
            self.dispatchGroup.leave()
        }
    }

    public func ready(in queue: DispatchQueue? = nil, for work: @escaping () -> Void) {
        dispatchGroup.notify(queue: queue ?? .main, execute: work)
    }
}
