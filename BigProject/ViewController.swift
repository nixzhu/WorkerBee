//
//  ViewController.swift
//  BigProject
//
//  Created by NIX on 2016/11/18.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit
import WorkerBee

class ViewController: UIViewController {

    var task: CancelableTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        Function.delay(3) {
            print("Task")
            SafeDispatch.async { [weak self] in
                self?.view.backgroundColor = .red
            }
        }

        task = CancelableTask(delay: 3) {
            print("CancelableTask")
        }

        Function.delay(2) { [weak self] in
            self?.task?.cancel()
        }

        let job = FreeTimeJob(target: self, selector: #selector(hardWork))
        job.commit()

        operate { value in
            print("or: value: \(value)")
        }
    }

    func hardWork() {
        // TODO: hardWork
    }

    func operate(work: @escaping (Int) -> Void) {
        let or = OperatingRoom()
        var value = 0
        or.prepare { finish in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("or: delay 2")
                value = 2
                finish()
            }
        }
        or.prepare { finish in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("or: delay 5")
                value = 5
                finish()
            }
        }
        or.ready {
            print("or: go go go")
            work(value)
        }
    }
}
