//
//  AirDateText.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A view that displays an air date with contextual formatting.
///
/// For dates within the next 7 days, displays "Coming next Wednesday".
/// For dates further in the future, displays "Coming January 30, 2026".
/// For past dates and today, displays the plain formatted date.
public struct AirDateText: View {

    private let date: Date

    /// Creates an air date text view for the given date.
    ///
    /// - Parameter date: The air date to display.
    public init(date: Date) {
        self.date = date
    }

    public var body: some View {
        let calendar = Calendar.autoupdatingCurrent
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfDate = calendar.startOfDay(for: date)
        let days = calendar.dateComponents(
            [.day], from: startOfToday, to: startOfDate
        ).day ?? 0

        if days > 0, days <= 7 {
            let weekday = date.formatted(
                Date.FormatStyle().weekday(.wide)
            )
            Text(
                "COMING_NEXT_WEEKDAY \(weekday)",
                bundle: .module
            )
        } else if days > 7 {
            let formatted = date.formatted(
                .dateTime.year().month(.wide).day()
            )
            Text("COMING_DATE \(formatted)", bundle: .module)
        } else {
            Text(
                date,
                format: .dateTime.year().month(.wide).day()
            )
        }
    }

}
