//
//  Observable.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/6/26.
//  Copyright © 2018 nixWork. All rights reserved.
//

import Foundation

// ref: https://www.swiftbysundell.com/posts/handling-mutable-models-in-swift
public class Observable<Value> {
    private var value: Value
    private var observations = [UUID: (Value) -> Void]()

    public init(value: Value) {
        self.value = value
    }

    public func update(with value: Value) {
        self.value = value

        for observation in observations.values {
            observation(value)
        }
    }

    public func addObserver<O: AnyObject>(_ observer: O,
                                          using closure: @escaping (O, Value) -> Void) {
        let id = UUID()

        observations[id] = { [weak self, weak observer] value in
            // If the observer has been deallocated, we can safely remove
            // the observation.
            guard let observer = observer else {
                self?.observations[id] = nil
                return
            }

            closure(observer, value)
        }

        // Directly call the observation closure with the
        // current value.
        closure(observer, value)
    }
}
