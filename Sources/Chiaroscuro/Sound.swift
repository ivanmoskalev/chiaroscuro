import AudioToolbox
import Foundation
import UIKit

/// Utility for playing system sounds and audio assets.
public enum Sound {
    /// Plays an audio asset from the app bundle.
    /// - Parameter name: The name of the audio file (without extension)
    public static func play(_ name: String) {
        guard let soundUrl = Bundle.main.url(forResource: name, withExtension: "m4a") else { return }
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }

    /// Plays the system click sound.
    /// Must be called on the main thread.
    @MainActor public static func playClick() {
        let version = UIDevice.current.systemVersion
        if version.starts(with: "15.") || version.starts(with: "16.") {
            AudioServicesPlaySystemSound(1306)
        }
    }
}