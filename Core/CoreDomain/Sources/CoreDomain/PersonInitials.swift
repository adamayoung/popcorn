//
//  PersonInitials.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

///
/// Extracts initials from a person's name.
///
/// Takes the first character of the first word and the first character of the last
/// meaningful word, uppercased. Common name suffixes (Jr., Sr., II, III, etc.) are
/// ignored when determining the last word. Single names produce a single initial.
/// Empty or whitespace-only strings return `nil`.
///
/// - Parameter name: The person's full name.
///
/// - Returns: The uppercase initials, or `nil` if the name is empty.
///
public func personInitials(from name: String) -> String? {
    let words = name.split(separator: " ")

    guard let first = words.first else {
        return nil
    }

    let meaningful = words.filter { !nameSuffixes.contains($0.lowercased()) }
    let last = meaningful.count > 1 ? meaningful.last : words.last

    guard let last, words.count > 1 else {
        return String(first.prefix(1)).uppercased()
    }

    return "\(first.prefix(1))\(last.prefix(1))".uppercased()
}

private let nameSuffixes: Set<String> = ["jr.", "jr", "sr.", "sr", "ii", "iii", "iv", "phd", "md", "esq."]
