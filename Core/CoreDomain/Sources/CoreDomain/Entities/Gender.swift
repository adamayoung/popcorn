//
//  Gender.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents the gender of a person.
///
/// Used to categorize people in the application, such as actors,
/// directors, and other crew members.
///
public enum Gender: Equatable, Sendable {

    /// Gender is not specified or unknown.
    case unknown

    /// Female gender.
    case female

    /// Male gender.
    case male

    /// Non-binary or other gender identity.
    case other

}
