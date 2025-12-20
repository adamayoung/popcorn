//
//  Person.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Person: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let biography: String
    public let knownForDepartment: String
    public let gender: Gender
    public let profileURL: URL?

    public init(
        id: Int,
        name: String,
        biography: String,
        knownForDepartment: String,
        gender: Gender,
        profileURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.biography = biography
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profileURL = profileURL
    }

}

extension Person {

    // swiftlint:disable line_length
    static var mock: Person {
        Person(
            id: 2283,
            name: "Stanley Tucci",
            biography:
            "Stanley Tucci Jr. (born November 11, 1960) is an American actor. Known as a character actor, he has played a wide variety of roles ranging from menacing to sophisticated. Tucci has earned numerous accolades, including six Emmy Awards, two Golden Globe Awards, and nominations for an Academy Award, a BAFTA Award, and a Tony Award.\n\nTucci made his film debut in John Huston's Prizzi's Honour (1985) and continued to play a variety of supporting roles in films such as Deconstructing Harry (1997), Road to Perdition (2002), and The Terminal (2004). He made his directorial debut with the comedy Big Night (1996), which he also co-wrote and starred in. Following roles in The Devil Wears Prada (2006) and Julie & Julia (2009), Tucci was nominated for the Academy Award for Best Supporting Actor for The Lovely Bones (2009). Tucci's other film roles include Burlesque (2010), Easy A (2010), Captain America: The First Avenger (2011), Margin Call (2011), The Hunger Games film series (2012–2015), Spotlight (2015), Supernova (2020), Worth (2021), and Conclave (2024).\n\nHe has starred in numerous television series such as the legal drama Murder One (1995–1997), the medical drama 3 lbs (2006), Ryan Murphy's limited series Feud: Bette & Joan (2017), and the drama Limetown (2018). He played Stanley Kubrick in the HBO film The Life and Death of Peter Sellers (2004). For his portrayal of Walter Winchell in the HBO film Winchell (1998), he received the Primetime Emmy Award for Outstanding Lead Actor in a Miniseries or Movie. Since 2020, Tucci has voiced Bitsy Brandenham in the Apple TV+ animated series Central Park.\n\nFrom 2021 to 2022, he hosted the CNN food and travel documentary series Stanley Tucci: Searching for Italy, for which he won two consecutive Primetime Emmy Awards for Outstanding Hosted Nonfiction Series. He was nominated for a Tony Award for Best Actor in a Play for his role in Frankie and Johnny in the Clair de Lune (2003) and a Grammy Award for narrating the audiobook The One and Only Shrek! (2008).",
            knownForDepartment: "Acting",
            gender: .male,
            profileURL: URL(
                string: "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
        )
    }
    // swiftlint:enable line_length

}
