//
//  ThreadSafe.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/3/19.
//  Copyright © 2018年 nixWork. All rights reserved.
//

import Foundation

final public class ThreadSafe<A> {
    private var _value: A
    private let queue = DispatchQueue(label: "ThreadSafe")

    public init(_ value: A) {
        self._value = value
    }

    public var value: A {
        return queue.sync { _value }
    }

    public func atomically(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
