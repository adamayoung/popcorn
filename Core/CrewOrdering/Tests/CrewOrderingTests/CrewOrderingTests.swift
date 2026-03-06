//
//  CrewOrderingTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import CrewOrdering
import Testing

@Suite("CrewOrdering")
struct CrewOrderingTests {

    // MARK: - departmentSortOrder

    @Test("Known departments return expected order")
    func knownDepartmentsReturnExpectedOrder() {
        #expect(CrewOrdering.departmentSortOrder("Directing") == 0)
        #expect(CrewOrdering.departmentSortOrder("Writing") == 1)
        #expect(CrewOrdering.departmentSortOrder("Production") == 2)
        #expect(CrewOrdering.departmentSortOrder("Camera") == 3)
        #expect(CrewOrdering.departmentSortOrder("Editing") == 4)
        #expect(CrewOrdering.departmentSortOrder("Sound") == 5)
        #expect(CrewOrdering.departmentSortOrder("Art") == 6)
    }

    @Test("Directing sorts before Writing")
    func directingSortsBeforeWriting() {
        #expect(
            CrewOrdering.departmentSortOrder("Directing")
                < CrewOrdering.departmentSortOrder("Writing")
        )
    }

    @Test("Unknown departments return Int.max")
    func unknownDepartmentsReturnIntMax() {
        #expect(CrewOrdering.departmentSortOrder("Visual Effects") == Int.max)
        #expect(CrewOrdering.departmentSortOrder("Costume & Make-Up") == Int.max)
        #expect(CrewOrdering.departmentSortOrder("") == Int.max)
    }

    // MARK: - jobSortOrder

    @Test("Known jobs return expected order")
    func knownJobsReturnExpectedOrder() {
        #expect(CrewOrdering.jobSortOrder("Director") == 0)
        #expect(CrewOrdering.jobSortOrder("Screenplay") == 10)
        #expect(CrewOrdering.jobSortOrder("Executive Producer") == 20)
        #expect(CrewOrdering.jobSortOrder("Director of Photography") == 30)
        #expect(CrewOrdering.jobSortOrder("Editor") == 40)
        #expect(CrewOrdering.jobSortOrder("Original Music Composer") == 50)
        #expect(CrewOrdering.jobSortOrder("Production Design") == 60)
    }

    @Test("Director sorts before First Assistant Director")
    func directorSortsBeforeFirstAssistantDirector() {
        #expect(
            CrewOrdering.jobSortOrder("Director")
                < CrewOrdering.jobSortOrder("First Assistant Director")
        )
    }

    @Test("Executive Producer sorts before Producer")
    func executiveProducerSortsBeforeProducer() {
        #expect(
            CrewOrdering.jobSortOrder("Executive Producer")
                < CrewOrdering.jobSortOrder("Producer")
        )
    }

    @Test("Unknown jobs return Int.max")
    func unknownJobsReturnIntMax() {
        #expect(CrewOrdering.jobSortOrder("Best Boy") == Int.max)
        #expect(CrewOrdering.jobSortOrder("Gaffer") == Int.max)
        #expect(CrewOrdering.jobSortOrder("") == Int.max)
    }

    // MARK: - groupedByDepartment

    @Test("Groups and sorts by department priority")
    func groupedByDepartmentSortsDepartments() {
        struct Member { let dept: String; let job: String; let name: String }
        let members = [
            Member(dept: "Production", job: "Producer", name: "A"),
            Member(dept: "Directing", job: "Director", name: "B"),
            Member(dept: "Writing", job: "Writer", name: "C")
        ]

        let result = CrewOrdering.groupedByDepartment(
            members,
            department: \.dept,
            jobSortOrder: { CrewOrdering.jobSortOrder($0.job) },
            name: \.name
        )

        #expect(result.count == 3)
        #expect(result[0].department == "Directing")
        #expect(result[1].department == "Writing")
        #expect(result[2].department == "Production")
    }

    @Test("Sorts members within department by job priority")
    func groupedByDepartmentSortsMembersByJob() {
        struct Member { let dept: String; let job: String; let name: String }
        let members = [
            Member(dept: "Directing", job: "Script Supervisor", name: "A"),
            Member(dept: "Directing", job: "Director", name: "B")
        ]

        let result = CrewOrdering.groupedByDepartment(
            members,
            department: \.dept,
            jobSortOrder: { CrewOrdering.jobSortOrder($0.job) },
            name: \.name
        )

        #expect(result[0].members[0].name == "B")
        #expect(result[0].members[1].name == "A")
    }

    @Test("Sorts members alphabetically by name for same job")
    func groupedByDepartmentSortsByNameForSameJob() {
        struct Member { let dept: String; let job: String; let name: String }
        let members = [
            Member(dept: "Directing", job: "Director", name: "Zack"),
            Member(dept: "Directing", job: "Director", name: "Adam")
        ]

        let result = CrewOrdering.groupedByDepartment(
            members,
            department: \.dept,
            jobSortOrder: { CrewOrdering.jobSortOrder($0.job) },
            name: \.name
        )

        #expect(result[0].members[0].name == "Adam")
        #expect(result[0].members[1].name == "Zack")
    }

    @Test("Returns empty array for empty input")
    func groupedByDepartmentReturnsEmptyForEmptyInput() {
        let result = CrewOrdering.groupedByDepartment(
            [String](),
            department: { $0 },
            jobSortOrder: { _ in 0 },
            name: { $0 }
        )

        #expect(result.isEmpty)
    }

}
