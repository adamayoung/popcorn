//
//  CrewOrdering.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

public enum CrewOrdering {

    private static let departmentOrder: [String: Int] = [
        "Directing": 0,
        "Writing": 1,
        "Production": 2,
        "Camera": 3,
        "Editing": 4,
        "Sound": 5,
        "Art": 6
    ]

    private static let jobOrder: [String: Int] = [
        // Directing
        "Director": 0,
        "First Assistant Director": 1,
        "Second Assistant Director": 2,
        "Third Assistant Director": 3,
        "Assistant Director": 4,
        "Script Supervisor": 5,

        // Writing
        "Screenplay": 10,
        "Writer": 11,
        "Story": 12,
        "Novel": 13,
        "Characters": 14,
        "Storyboard": 15,

        // Production
        "Executive Producer": 20,
        "Producer": 21,
        "Co-Producer": 22,
        "Associate Producer": 23,
        "Line Producer": 24,
        "Casting": 25,
        "Creator": 26,
        "Production Manager": 27,
        "Unit Production Manager": 28,
        "Production Coordinator": 29,

        // Camera
        "Director of Photography": 30,
        "Camera Operator": 31,
        "Steadicam Operator": 32,
        "Still Photographer": 33,

        // Editing
        "Editor": 40,
        "Assistant Editor": 41,
        "Color Grading": 42,

        // Sound
        "Original Music Composer": 50,
        "Music Supervisor": 51,
        "Music": 52,
        "Sound Designer": 53,
        "Supervising Sound Editor": 54,
        "Sound Mixer": 55,
        "Sound Editor": 56,
        "Boom Operator": 57,

        // Art
        "Production Design": 60,
        "Art Direction": 61,
        "Set Decoration": 62,
        "Set Designer": 63,
        "Costume Design": 64,
        "Makeup & Hair": 65,
        "Special Effects": 66
    ]

    public static func departmentSortOrder(_ department: String) -> Int {
        departmentOrder[department] ?? Int.max
    }

    public static func jobSortOrder(_ job: String) -> Int {
        jobOrder[job] ?? Int.max
    }

    /// Groups crew members by department and sorts both departments and members within each department.
    ///
    /// Departments are sorted by ``departmentSortOrder(_:)``, then alphabetically for ties.
    /// Members within each department are sorted by job priority (via `jobSortOrder`), then
    /// alphabetically by name for ties.
    ///
    /// - Parameters:
    ///   - members: The crew members to group and sort.
    ///   - department: Extracts the department name from a member.
    ///   - jobSortOrder: Returns the sort order for a member based on their job(s).
    ///   - name: Extracts the display name from a member for alphabetical tie-breaking.
    /// - Returns: An array of `(department, sortedMembers)` tuples in priority order.
    public static func groupedByDepartment<Member>(
        _ members: [Member],
        department: (Member) -> String,
        jobSortOrder: (Member) -> Int,
        name: (Member) -> String
    ) -> [(department: String, members: [Member])] {
        let grouped = Dictionary(grouping: members, by: department)

        return grouped
            .sorted { lhs, rhs in
                let lhsOrder = departmentSortOrder(lhs.key)
                let rhsOrder = departmentSortOrder(rhs.key)
                if lhsOrder != rhsOrder {
                    return lhsOrder < rhsOrder
                }
                return lhs.key < rhs.key
            }
            .map { dept, members in
                let sortedMembers = members.sorted { lhs, rhs in
                    let lhsJob = jobSortOrder(lhs)
                    let rhsJob = jobSortOrder(rhs)
                    if lhsJob != rhsJob {
                        return lhsJob < rhsJob
                    }
                    return name(lhs) < name(rhs)
                }
                return (department: dept, members: sortedMembers)
            }
    }

}
