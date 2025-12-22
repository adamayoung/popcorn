//
//  GameTheme.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the narrative style used to remix movie plots in Plot Remix game questions.
///
/// Each theme transforms movie plots into a distinct narrative voice, creating unique
/// riddles that challenge players to identify films from creatively rewritten descriptions.
/// Themes range from whimsical storytelling to cryptic prose, offering varied gameplay
/// experiences.
///
public enum GameTheme: Sendable, CaseIterable, Equatable {

    /// Dark, mysterious narrative style with cryptic phrasing.
    case darkCryptic

    /// Playful, lighthearted storytelling with imaginative language.
    case whimsical

    /// Hard-boiled detective fiction style with cynical undertones.
    case noir

    /// Epic, legendary narrative inspired by ancient myths and sagas.
    case mythic

    /// Storybook narrative style reminiscent of classic fairy tales.
    case fairyTale

    /// Futuristic, prophetic narrative with science fiction elements.
    case sciFiOracle

    /// Comedic, joke-oriented retellings with humorous exaggeration.
    case humorous

    /// Artistic, verse-like narrative with lyrical and metaphorical language.
    case poetic

    /// Formal, legal document style with technical jargon.
    case legalese

    /// Simple, innocent narrative as if told by a child.
    case child

    /// Nautical adventure style with pirate vocabulary and seafaring themes.
    case pirate

    /// Extremely brief, stripped-down narrative with minimal details.
    case minimalist

}
