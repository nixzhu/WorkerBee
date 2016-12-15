//
//  Feedback.swift
//  WorkerBee
//
//  Created by NIX on 2016/12/15.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

final public class Feedback {

    private static let shared = Feedback()

    var soundIDs = [URL: SystemSoundID]()

    private init() {}

    public class func playSound(at fileURL: URL?) {
        guard let url = fileURL else { return }
        if let soundID = shared.soundIDs[url] {
            AudioServicesPlaySystemSound(soundID)
        } else {
            var soundID: SystemSoundID = 0
            let status = AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            if status == kAudioServicesNoError {
                AudioServicesPlaySystemSound(soundID)
                shared.soundIDs[url] = soundID
            }
        }
    }

    public class func playSound(name: String?, extension ext: String?) {
        let fileURL = Bundle.main.url(forResource: name, withExtension: ext)
        playSound(at: fileURL)
    }

    public class func playSound(fileName: String) {
        let parts = fileName.components(separatedBy: ".")
        let name = parts.first
        let ext = parts.count > 1 ? parts[1] : nil
        playSound(name: name, extension: ext)
    }

    public class func playSound(systemSoundID: SystemSoundID) {
        AudioServicesPlaySystemSound(systemSoundID)
    }

    public enum SystemSound: SystemSoundID {
        case receivedMessage    = 1003
        case sentMessage        = 1004
    }

    public class func playSound(systemSound: SystemSound) {
        playSound(systemSoundID: systemSound.rawValue)
    }

    public class func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    // MARK: Taptic Notification

    private var notificationFeedbackGenerator: Any?

    public class func prepareNotification() {
        if #available(iOS 10.0, *) {
            if let generator = shared.notificationFeedbackGenerator as? UINotificationFeedbackGenerator {
                generator.prepare()
            } else {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                shared.notificationFeedbackGenerator = generator
            }
        }
    }

    public class func fireNotification(type: UINotificationFeedbackType) {
        if #available(iOS 10.0, *) {
            if let generator = shared.notificationFeedbackGenerator as? UINotificationFeedbackGenerator {
                generator.notificationOccurred(type)
            } else {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(type)
                shared.notificationFeedbackGenerator = generator
            }
        }
    }
}
