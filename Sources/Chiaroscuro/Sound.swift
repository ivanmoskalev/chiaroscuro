import AudioToolbox
import Foundation
import UIKit

public enum Sound {
    public static func play(_ name: String) {
        guard let soundUrl = Bundle.main.url(forResource: name, withExtension: "m4a") else { return }
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }

    @MainActor public static func playClick() {
        let version = UIDevice.current.systemVersion
        if version.starts(with: "15.") || version.starts(with: "16.") {
            AudioServicesPlaySystemSound(1306)
        }
    }
}
