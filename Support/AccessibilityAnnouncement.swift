import UIKit

/// Posts VoiceOver announcements for state changes that are otherwise only visual/haptic.
enum AccessibilityAnnouncement {
    static func post(_ message: String) {
        guard UIAccessibility.isVoiceOverRunning else { return }
        UIAccessibility.post(notification: .announcement, argument: message)
    }
}
