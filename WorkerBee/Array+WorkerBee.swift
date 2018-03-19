//
//  Array+WorkerBee.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/3/19.
//  Copyright © 2018年 nixWork. All rights reserved.
//

import Foundation

extension Array {
    public func workerbee_concurrentMap<B>(_ transform: @escaping (Element) -> B) -> [B] {
        let result = ThreadSafe(Array<B?>(repeating: nil, count: count))
        DispatchQueue.concurrentPerform(iterations: count) { idx in
            let element = self[idx]
            let transformed = transform(element)
            result.atomically {
                $0[idx] = transformed
            }
        }
        return result.value.map { $0! }
    }
}
