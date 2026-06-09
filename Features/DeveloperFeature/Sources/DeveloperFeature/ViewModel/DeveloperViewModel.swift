//
//  DeveloperViewModel.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation

/// Drives ``DeveloperScreen``. The MVVM replacement for `DeveloperFeature`.
///
/// The developer home is a static list with no business logic, so this view model
/// is intentionally empty — it exists to keep the screen's ownership and lifecycle
/// consistent with the other migrated features. Push navigation is owned by the
/// screen's local `NavigationStack` path.
@Observable
@MainActor
public final class DeveloperViewModel {

    public init() {}

}
