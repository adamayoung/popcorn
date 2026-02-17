//
//  MockConfigurationService.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockConfigurationService: ConfigurationService, @unchecked Sendable {

    var apiConfigurationCallCount = 0
    var apiConfigurationStub: Result<APIConfiguration, TMDbError>?

    var countriesCallCount = 0
    var countriesCalledWithLanguage: [String?] = []
    var countriesStub: Result<[Country], TMDbError>?

    var jobsByDepartmentCallCount = 0
    var jobsByDepartmentStub: Result<[Department], TMDbError>?

    var languagesCallCount = 0
    var languagesStub: Result<[Language], TMDbError>?

    var primaryTranslationsCallCount = 0
    var primaryTranslationsStub: Result<[String], TMDbError>?

    var timezonesCallCount = 0
    var timezonesStub: Result<[Timezone], TMDbError>?

    func apiConfiguration() async throws -> APIConfiguration {
        apiConfigurationCallCount += 1

        guard let stub = apiConfigurationStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let configuration):
            return configuration
        case .failure(let error):
            throw error
        }
    }

    func countries(language: String?) async throws -> [Country] {
        countriesCallCount += 1
        countriesCalledWithLanguage.append(language)

        guard let stub = countriesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
    }

    func jobsByDepartment() async throws -> [Department] {
        jobsByDepartmentCallCount += 1

        guard let stub = jobsByDepartmentStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let departments):
            return departments
        case .failure(let error):
            throw error
        }
    }

    func languages() async throws -> [Language] {
        languagesCallCount += 1

        guard let stub = languagesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let languages):
            return languages
        case .failure(let error):
            throw error
        }
    }

    func primaryTranslations() async throws -> [String] {
        primaryTranslationsCallCount += 1

        guard let stub = primaryTranslationsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let translations):
            return translations
        case .failure(let error):
            throw error
        }
    }

    func timezones() async throws -> [Timezone] {
        timezonesCallCount += 1

        guard let stub = timezonesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let timezones):
            return timezones
        case .failure(let error):
            throw error
        }
    }

}
