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
}
