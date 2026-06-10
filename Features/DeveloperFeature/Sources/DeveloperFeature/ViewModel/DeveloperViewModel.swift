//
//  DeveloperViewModel.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation

/// Drives ``DeveloperView``.
///
/// The developer home is a static list with no business logic, so this view model
/// is intentionally empty — it exists to keep the screen's ownership and lifecycle
/// consistent with other view models. Push navigation is owned by the screen's
/// local `NavigationStack` path.
@Observable
@MainActor
public final class DeveloperViewModel {

    public init() {}

}
