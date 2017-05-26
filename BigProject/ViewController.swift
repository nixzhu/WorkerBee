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

        do {
            let text = "Do not go gentle into that good night."
            let font = UIFont.systemFont(ofSize: 36)
            let width: CGFloat = 200
            let height = TextSize.height(text: text, font: font, width: width)
            let label = UILabel(frame: CGRect(x: 20, y: 100, width: width, height: height))
            label.font = font
            label.numberOfLines = 0
            label.backgroundColor = .green
            label.text = text
            view.addSubview(label)
        }

        do {
            let text = "Do not go gentle into that good night."
            let font = UIFont.systemFont(ofSize: 17)
            let height: CGFloat = 30
            let width = TextSize.width(text: text, font: font, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            let label = UILabel(frame: CGRect(x: 20, y: 300, width: width, height: height))
            label.font = font
            label.textAlignment = .center
            label.backgroundColor = .blue
            label.text = text
            view.addSubview(label)
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
