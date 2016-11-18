//
//  FreeTimeJob.swift
//  WorkerBee
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

final public class FreeTimeJob {

    private static var set = NSMutableSet()
    private static var onceToken: Int = 0
    private static var once: Void = {
        let runLoop = CFRunLoopGetMain()
        let observer: CFRunLoopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue, true, 0xFFFFFF) { (observer, activity) in
            guard set.count != 0 else {
                return
            }
            let currentSet = set
            set = NSMutableSet()
            currentSet.enumerateObjects({ (object, stop) in
                if let job = object as? FreeTimeJob {
                    _ = job.target?.perform(job.selector)
                }
            })
        }
        CFRunLoopAddObserver(runLoop, observer, CFRunLoopMode.commonModes)
    }()

    private class func setup() {
        _ = FreeTimeJob.once
    }

    private weak var target: NSObject?
    private let selector: Selector

    public init(target: NSObject, selector: Selector) {
        self.target = target
        self.selector = selector
    }

    public func commit() {
        FreeTimeJob.setup()
        FreeTimeJob.set.add(self)
    }
}
