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
        }

        task = CancelableTask(delay: 3) {
            print("CancelableTask")
        }

        delay(2) { [weak self] in
            self?.task?.cancel()
        }
    }
}
