//
//  StubPersonRepository.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

public final class StubPersonRepository: PersonRepository, Sendable {

    public init() {}

    public func person(withID id: Int) async throws(PersonRepositoryError) -> Person {
        guard let person = Self.people[id] else {
            throw .notFound
        }
        return person
    }

}

extension StubPersonRepository {

    // MARK: - TMDb Person Data

    // swiftlint:disable line_length
    static let people: [Int: Person] = [
        // Tom Cruise
        500: Person(
            id: 500,
            name: "Tom Cruise",
            biography: "Thomas Cruise Mapother IV (born July 3, 1962) is an American actor and film producer. Regarded as a Hollywood icon, he has received various accolades, including an Honorary Palme d'Or and three Golden Globe Awards, in addition to nominations for four Academy Awards.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/3mShHjSQR7NXOVbdTu5rT2Qd0MN.jpg")
        ),
        // Brad Pitt
        287: Person(
            id: 287,
            name: "Brad Pitt",
            biography: "William Bradley Pitt (born December 18, 1963) is an American actor and film producer. He has received various accolades, including two Academy Awards, two British Academy Film Awards, two Golden Globe Awards, and a Primetime Emmy Award.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/ajNaPmXVVMJFg9GWmu6MJzTaXdV.jpg")
        ),
        // Harrison Ford
        3: Person(
            id: 3,
            name: "Harrison Ford",
            biography: "Legendary Hollywood Icon Harrison Ford was born on July 13, 1942 in Chicago, Illinois. His family history includes a strong lineage of actors, radio personalities, and models.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
        ),
        // Sydney Sweeney
        115_440: Person(
            id: 115_440,
            name: "Sydney Sweeney",
            biography: "Sydney Bernice Sweeney is an American actress known for her roles in HBO's Euphoria and The White Lotus.",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg")
        ),
        // Emma Stone
        54693: Person(
            id: 54693,
            name: "Emma Stone",
            biography: "Emily Jean Stone is an American actress. She is the recipient of various accolades, including two Academy Awards and two Golden Globe Awards.",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/8NwSfyYWIIUE1cI9Xhz92b0w7WD.jpg")
        ),
        // Demi Moore
        3416: Person(
            id: 3416,
            name: "Demi Moore",
            biography: "Demi Gene Moore is an American actress. She is known for her roles in Ghost, Indecent Proposal, and The Substance.",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/wApParZYBDi4yxekjfxjKEifJYh.jpg")
        ),
        // Chris Hemsworth
        74568: Person(
            id: 74568,
            name: "Chris Hemsworth",
            biography: "Chris Hemsworth is an Australian actor best known for playing Thor in the Marvel Cinematic Universe.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/piQGdoIQOF3C1EI5cbYZLAW1gfj.jpg")
        ),
        // Will Smith
        2888: Person(
            id: 2888,
            name: "Will Smith",
            biography: "Willard Carroll Smith II is an American actor, rapper, and film producer. Smith has been nominated for five Golden Globe Awards and two Academy Awards.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/8TlKqbXYgHmmaEoPBJ7djJ8Rxxa.jpg")
        ),
        // Nicolas Cage (from Trending)
        2963: Person(
            id: 2963,
            name: "Nicolas Cage",
            biography: "Nicolas Cage (born Nicolas Kim Coppola; January 7, 1964) is an American actor and filmmaker. He is the recipient of various accolades, including an Academy Award, a Screen Actors Guild Award, and a Golden Globe Award.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/y1RtezurZYveYkVNRht7CwEgSYY.jpg")
        ),
        // Elle Fanning (from Movie Credits - Predator: Badlands)
        18050: Person(
            id: 18050,
            name: "Elle Fanning",
            biography: "Mary Elle Fanning (born April 9, 1998) is an American actress. She is known for her roles in Maleficent, The Great, and Super 8.",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/e8CUyxQSE99y5IOfzSLtHC0B0Ch.jpg")
        ),
        // Dimitrius Schuster-Koloamatangi (from Movie Credits - Predator: Badlands)
        3_223_391: Person(
            id: 3_223_391,
            name: "Dimitrius Schuster-Koloamatangi",
            biography: "",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/rmIZTT1AZK3C9fYhEOtGKtSrF8E.jpg")
        ),
        // Ravi Narayan (from Movie Credits - Predator: Badlands)
        1_891_826: Person(
            id: 1_891_826,
            name: "Ravi Narayan",
            biography: "",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/iM9dr3AjXTt7IGpRzZlQVG7hINa.jpg")
        ),
        // Ginnifer Goodwin (from Movie Credits - Zootopia 2)
        417: Person(
            id: 417,
            name: "Ginnifer Goodwin",
            biography: "Jennifer Michelle \"Ginnifer\" Goodwin (born May 22, 1978) is an American actress. She is known for her roles in Big Love, Once Upon a Time, and Zootopia.",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/xOCA2WN5MRfXmJmlzEbFEhIbfIQ.jpg")
        ),
        // Jason Bateman (from Movie Credits - Zootopia 2)
        23532: Person(
            id: 23532,
            name: "Jason Bateman",
            biography: "Jason Bateman (born January 14, 1969) is an American television and film actor. He is known for his role as Michael Bluth in Arrested Development and Marty Byrde in Ozark.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/8e6mt0vGjPo6eW52gqRuXy5YnfN.jpg")
        ),
        // Dan Trachtenberg (from Movie Credits - Predator: Badlands - Director)
        568_322: Person(
            id: 568_322,
            name: "Dan Trachtenberg",
            biography: "Dan Trachtenberg (born May 11, 1981) is an American filmmaker and podcast host. He is best known for directing 10 Cloverfield Lane and Prey.",
            knownForDepartment: "Directing",
            gender: .male,
            profilePath: URL(string: "/crABZLMi5SAz7rKm0wV6JUOeKs5.jpg")
        ),
        // Patrick Aison (from Movie Credits - Predator: Badlands - Writer)
        1_061_155: Person(
            id: 1_061_155,
            name: "Patrick Aison",
            biography: "Patrick Aison is an American writer and producer who wrote the screenplay for the 2022 film Prey.",
            knownForDepartment: "Writing",
            gender: .male,
            profilePath: nil
        ),
        // Benjamin Wallfisch (from Movie Credits - Predator: Badlands - Composer)
        40825: Person(
            id: 40825,
            name: "Benjamin Wallfisch",
            biography: "Benjamin Mark Lasker Wallfisch (born 7 August 1979) is a British composer, conductor, and music producer known for his work on film scores including Blade Runner 2049, It, and The Flash.",
            knownForDepartment: "Sound",
            gender: .male,
            profilePath: URL(string: "/dWcshjk0OUi3stGFFrwZIsYKZfQ.jpg")
        ),
        // Byron Howard (from Movie Credits - Zootopia 2 - Director)
        76595: Person(
            id: 76595,
            name: "Byron Howard",
            biography: "Byron P. Howard (born December 26, 1968) is an American animator, character designer, story artist, film director, producer, and screenwriter. He is best known for directing Bolt, Tangled, Zootopia, and Encanto.",
            knownForDepartment: "Directing",
            gender: .male,
            profilePath: URL(string: "/ePJXkxrD44nM0VB7Xx9Q4ityzfT.jpg")
        )
    ]
    // swiftlint:enable line_length

}
