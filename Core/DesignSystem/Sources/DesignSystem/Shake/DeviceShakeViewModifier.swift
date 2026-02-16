//
//  DeviceShakeViewModifier.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

#if os(iOS)
    import UIKit

    extension UIDevice {

        static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")

    }

    extension UIWindow {

        override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
            }
        }

    }
#endif

@available(iOS 13.0, *)
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

    @available(iOS 13.0, *)
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }

}
