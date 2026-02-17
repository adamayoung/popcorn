//
//  DeviceShakeViewModifier.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

#if os(iOS) && DEBUG
    import UIKit

    extension UIDevice {

        static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")

    }

    extension UIWindow {

        override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            super.motionEnded(motion, with: event)
            if motion == .motionShake {
                NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
            }
        }

    }

    struct DeviceShakeViewModifier: ViewModifier {

        let action: () -> Void

        func body(content: Content) -> some View {
            content
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                    action()
                }
        }

    }

    public extension View {

        func onShake(perform action: @escaping () -> Void) -> some View {
            modifier(DeviceShakeViewModifier(action: action))
        }

    }
#endif
