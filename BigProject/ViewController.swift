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

        delay(3) {
            print("Task")
            SafeDispatch.async { [weak self] in
                self?.view.backgroundColor = .red
            }
        }

        task = CancelableTask(delay: 3) {
            print("CancelableTask")
        }

        delay(2) { [weak self] in
            self?.task?.cancel()
        }

        let job = FreeTimeJob(target: self, selector: #selector(hardWork))
        job.commit()
    }

    func hardWork() {
        // TODO: hardWork
    }
}
