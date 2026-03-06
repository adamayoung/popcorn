//
//  ContentLoadErrorView.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct ContentLoadErrorView: View {

    private let message: String
    private let systemImage: String
    private let reason: String?
    private let recovery: String?
    private let isRetryable: Bool
    private let retryAction: (() -> Void)?

    public init(
        message: String,
        systemImage: String = "exclamationmark.triangle",
        reason: String? = nil,
        recovery: String? = nil,
        isRetryable: Bool = false,
        retryAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.systemImage = systemImage
        self.reason = reason
        self.recovery = recovery
        self.isRetryable = isRetryable
        self.retryAction = retryAction
    }

    public var body: some View {
        ContentUnavailableView {
            Label {
                Text(verbatim: message)
            } icon: {
                Image(systemName: systemImage)
            }
        } description: {
            VStack(spacing: .spacing8) {
                if let reason {
                    Text(verbatim: reason)
                        .foregroundStyle(.secondary)
                }

                if let recovery {
                    Text(verbatim: recovery)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
            }
        } actions: {
            if isRetryable, let retryAction {
                Button(LocalizedStringResource("RETRY", bundle: .module)) {
                    retryAction()
                }
                .buttonStyle(.bordered)
            }
        }
    }

}

#Preview("Retryable") {
    ContentLoadErrorView(
        message: "Something went wrong. Please try again.",
        isRetryable: true,
        retryAction: {}
    )
}

#Preview("With Reason and Recovery") {
    ContentLoadErrorView(
        message: "Unable to load episode details.",
        reason: "The server could not be reached.",
        recovery: "Check your internet connection and try again.",
        isRetryable: true,
        retryAction: {}
    )
}

#Preview("Not Retryable") {
    ContentLoadErrorView(
        message: "This content is no longer available."
    )
}
