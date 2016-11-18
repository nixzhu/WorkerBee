//
//  ConcurrentOperation.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

open class ConcurrentOperation: Operation {

    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override open var isReady: Bool {
        return super.isReady && state == .ready
    }

    override open var isExecuting: Bool {
        return state == .executing
    }

    override open var isFinished: Bool {
        return state == .finished
    }

    override open var isAsynchronous: Bool {
        return true
    }

    override open func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        main()
        state = .executing
    }

    override open func cancel() {
        state = .finished
    }
}
