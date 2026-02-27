//
//  PersonInitials.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

/// Namespace for extracting initials from a person's name.
public enum PersonInitials {

    /// Extracts initials from a person's name.
    ///
    /// Takes the first character of the first meaningful word and the first character
    /// of the last meaningful word, uppercased. Common name suffixes (Jr., Sr., II,
    /// III, etc.) are ignored when determining words. Single names (or names where
    /// all but one word are suffixes) produce a single initial. Empty or
    /// whitespace-only strings return `nil`.
    ///
    /// - Parameter name: The person's full name.
    ///
    /// - Returns: The uppercase initials, or `nil` if the name is empty.
    public static func resolve(from name: String) -> String? {
        let words = name.split { $0.isWhitespace }

        guard !words.isEmpty else {
            return nil
        }

        let meaningful = words.filter { !suffixes.contains($0.lowercased()) }

        guard meaningful.count > 1,
              let first = meaningful.first,
              let last = meaningful.last
        else {
            return (meaningful.first ?? words.first)
                .map { String($0.prefix(1)).uppercased() }
        }

        return "\(first.prefix(1))\(last.prefix(1))".uppercased()
    }

    private static let suffixes: Set<String> = [
        "jr.", "jr", "sr.", "sr", "ii", "iii", "iv",
        "phd", "ph.d.", "ph.d", "md", "esq.", "esq"
    ]

}
