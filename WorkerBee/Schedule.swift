//
//  Schedule.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/2/27.
//  Copyright © 2018年 nixWork. All rights reserved.
//

import Foundation

public class Schedule {

    private let work: () -> Void
    private var _timer: DispatchSourceTimer?

    public init(work: @escaping () -> Void) {
        self.work = work
    }

    public func start(immediately: Bool = false, timeInterval: DispatchTimeInterval, repeats: Bool, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main) {
        guard _timer == nil else { return }
        if immediately {
            work()
        }
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler { [weak self] in
            self?.work()
        }
        if repeats {
            timer.schedule(deadline: .now() + timeInterval, repeating: timeInterval, leeway: leeway)
        } else {
            timer.schedule(deadline: .now() + timeInterval, leeway: leeway)
        }
        timer.resume()
        _timer = timer
    }
}
