//
//  SoundEffect.swift
//  WorkerBee
//
//  Created by NIX on 2016/12/15.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation
import AudioToolbox.AudioServices

final public class SoundEffect {

    private static let shared = SoundEffect()

    var soundIDs = [URL: SystemSoundID]()

    private init() {}

    public class func play(fileURL: URL?) {
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

    public class func play(resource name: String?, withExtension ext: String?, subdirectory subpath: String? = nil, localization localizationName: String? = nil) {
        let fileURL = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: subpath, localization: localizationName)
        play(fileURL: fileURL)
    }

    public class func play(fileName: String) {
        let parts = fileName.components(separatedBy: ".")
        let name = parts.first
        let ext = parts.count > 1 ? parts[1] : nil
        play(resource: name, withExtension: ext)
    }

    public class func play(soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }

    public enum SystemSound: SystemSoundID {
        case receivedMessage    = 1003
        case sentMessage        = 1004
    }

    public class func play(systemSound: SystemSound) {
        play(soundID: systemSound.rawValue)
    }

    public class func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
