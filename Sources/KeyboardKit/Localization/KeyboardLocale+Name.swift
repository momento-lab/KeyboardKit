//
//  Locale+Name.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2023-04-13.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Locale {

    /// The full name of this locale in its own language.
    var localizedName: String {
        localizedName(in: self)
    }

    /// The full name of this locale in another locale.
    func localizedName(in locale: Locale) -> String {
        if identifier == "ckb_PC" {
            let locale = KeyboardLocale.kurdish_sorani.locale
            return locale.localizedName(in: locale) + " (PC)"
        }
        return locale.localizedString(forIdentifier: identifier) ?? ""
    }

    /// The language name of this locale in its own language.
    var localizedLanguageName: String {
        localizedLanguageName(in: self)
    }

    /// The language name of this locale in another locale.
    func localizedLanguageName(in locale: Locale) -> String {
        locale.localizedString(forLanguageCode: languageCode ?? "") ?? ""
    }
    
    var keyboardFirstRow: String {
        switch self {
        case KeyboardLocale.english.locale: "qwertyuiop"
        case KeyboardLocale.spanish.locale: "qwertyuiop"
        case KeyboardLocale.french.locale: "azertyuiop"
        case KeyboardLocale.dutch.locale: "qwertyuiop"
        case KeyboardLocale.portuguese.locale: "qwertyuiop"
        case KeyboardLocale.italian.locale: "qwertyuiop"
        case KeyboardLocale.turkish.locale: "qwertyuıopğü"
        default: "qwertyuiop"
        }
    }
    
    var keyboardSecondRow: String {
        switch self {
        case KeyboardLocale.english.locale: "asdfghjkl"
        case KeyboardLocale.spanish.locale: "asdfghjklñ"
        case KeyboardLocale.french.locale: "qsdfghjklm"
        case KeyboardLocale.dutch.locale: "asdfghjkl"
        case KeyboardLocale.portuguese.locale: "asdfghjkl"
        case KeyboardLocale.italian.locale: "asdfghjkl"
        case KeyboardLocale.turkish.locale: "asdfghjklşi"
        default: "asdfghjkl"
        }
    }
    
    var keyboardThirdRow: String {
        switch self {
        case KeyboardLocale.english.locale: "zxcvbnm"
        case KeyboardLocale.spanish.locale: "zxcvbnm"
        case KeyboardLocale.french.locale: "wxcvbn´"
        case KeyboardLocale.dutch.locale: "zxcvbnm"
        case KeyboardLocale.portuguese.locale: "zxcvbnm"
        case KeyboardLocale.italian.locale: "zxcvbnm"
        case KeyboardLocale.turkish.locale: "zxcvbnmöç"
        default: "zxcvbnm"
        }
    }
    
    var keyboardThirdRowForPad: String {
        switch self {
        case KeyboardLocale.english.locale: "zxcvbnm,."
        case KeyboardLocale.spanish.locale: "zxcvbnm,."
        case KeyboardLocale.french.locale: "wxcvbn´,."
        case KeyboardLocale.dutch.locale: "zxcvbnm,."
        case KeyboardLocale.portuguese.locale: "zxcvbnm,."
        case KeyboardLocale.italian.locale: "zxcvbnm,."
        case KeyboardLocale.turkish.locale: "zxcvbnmöç,."
        default: "zxcvbnm,."
        }
    }
}

public extension Collection where Element == Locale {

    /// Sort the collection by the localized item name, then
    /// optionally place a locale first.
    ///
    /// - Parameters:
    ///   - insertFirst: The locale to place first, by default `nil`.
    func sorted(
        insertFirst first: Element? = nil
    ) -> [Element] {
        sorted(
            by: { $0.localizedName.lowercased() < $1.localizedName.lowercased() },
            insertFirst: first
        )
    }

    /// Sort the collection by the localized item name for a
    /// certain locale, then optionally place a locale first.
    ///
    /// - Parameters:
    ///   - locale: The locale to use to get the localized name.
    ///   - insertFirst: The locale to place first, by default `nil`.
    func sorted(
        in locale: Locale,
        insertFirst first: Element? = nil
    ) -> [Element] {
        sorted(
            by: { $0.localizedName(in: locale).lowercased() < $1.localizedName(in: locale).lowercased() },
            insertFirst: first
        )
    }

    /// Sort the collection by a sort comparator, then place
    /// a locale first in the sorted result.
    ///
    /// - Parameters:
    ///   - comparator: The sort comparator to use.
    ///   - insertFirst: The locale to place first, by default `nil`.
    func sorted(
        by comparator: (Locale, Locale) -> Bool,
        insertFirst first: Element?
    ) -> [Element] {
        let sorted = self.sorted(by: comparator)
        guard let first = first else { return sorted }
        var filtered = sorted.filter { $0 != first }
        filtered.insert(first, at: 0)
        return filtered
    }
}
