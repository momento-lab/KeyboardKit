//
//  KeyboardViewController.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2023-02-13.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import KeyboardKitPro
import SwiftUI

/// This keyboard demonstrates how to set up KeyboardKit Pro
/// and customize the standard configuration.
///
/// To use the keyboard, simply enable it in System Settings,
/// then switch to it when you type in the demo (or any) app.
///
/// This keyboard uses KeyboardKit Pro-based autocomplete to
/// provide localized suggestions for every supported locale.
/// It also uses a Pro toggle toolbar, to add a menu "behind"
/// the main autocomplete toolbar.
///
/// > Important: This keyboard needs full access to use some
/// features, like haptic feedback.
class KeyboardViewController: KeyboardInputViewController {

    /// This demo will persist the current locale so that it
    /// can restore it the next time the keyboard is created.
    deinit {
        persistedLocaleId = state.keyboardContext.locale.identifier
    }

    /// This function is called when the controller launches.
    ///
    /// Here, we make demo-specific configurations, that are
    /// not overwritten when KeyboardKit Pro is registered.
    override func viewDidLoad() {

        /// 💡 Add more locales to the keyboard.
        ///
        /// ``DemoLayoutProvider`` adds a next locale button
        /// if you have more than one locale.
        state.keyboardContext.localePresentationLocale = .current
        // state.keyboardContext.locales = This is set to the license locales
        
        /// 💡 Setup a custom dictation key replacement.
        ///
        /// Since dictation is not available by default, the
        /// dictation button is removed if we don't set this.
        state.keyboardContext.keyboardDictationReplacement = .keyboardType(.emojis)
        
        /// 💡 Change the space long press behavior.
        ///
        /// The locale context menu will only open up if the
        /// keyboard has multiple locales.
        state.keyboardContext.spaceLongPressBehavior = .moveInputCursor
        // state.keyboardContext.spaceLongPressBehavior = .openLocaleContextMenu
        
        /// 💡 Setup haptic and audio feedback.
        ///
        /// The code below enables audio and haptic feedback,
        /// then sets up custom audio for the rocket button.
        let feedback = state.feedbackContext
        feedback.audioConfiguration = .enabled
        feedback.hapticConfiguration = .enabled
        feedback.register(.haptic(.selection, for: .repeat, on: .rocket))
        feedback.register(.audio(.rocketFuse, for: .press, on: .rocket))
        feedback.register(.audio(.rocketLaunch, for: .release, on: .rocket))
        
        /// 💡 Disable autocorrect.
        // state.autocompleteContext.isAutocorrectEnabled = false

        /// 💡 Call super to perform the base initialization.
        super.viewDidLoad()
    }

    /// This function is called whenever the keyboard should
    /// be created or updated.
    ///
    /// Here, we register a KeyboardKit Pro license key then
    /// use a ``DemoKeyboardView`` as the main keyboard view.
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()        
        
        /// 💡 Make the demo use a ``DemoKeyboardView``.
        ///
        /// We get an `unowned` controller reference that we
        /// can use to help us avoid memory leaks.
        setupPro(
            withLicenseKey: "299B33C6-061C-4285-8189-90525BCAF098",
            licenseConfiguration: setup   // Specified below
        ) { controller in
            DemoKeyboardView(controller: controller)
        }
    }

    /// This function is called by the `licenseConfiguration`
    /// to set up the keyboard with the registered license.
    func setup(with license: License) {
        
        /// 💡 Restore the last persisted locale.
        ///
        /// The demo will fall back to English, if it hasn't
        /// persisted a locale.
        let english = KeyboardLocale.english.locale
        state.keyboardContext.locale = persistedLocale ?? english
        
        /// 💡 Setup semi-working dictation.
        ///
        /// Dictation doesn't fully work for this demo since
        /// the main app requires a code signed app group.
        state.dictationContext.setup(with: .app)
        
        /// 💡 Setup a demo-specific layout provider.
        ///
        /// The demo provider adds a "next locale" button if
        /// needed, as well as a dictation button.
        services.layoutProvider = DemoLayoutProvider(
            localizedProviders: license.localizedKeyboardLayoutProviders
        )
        
        /// 💡 Setup a theme-based style provider.
        ///
        /// Themes are powerful ways to specify styles for a
        /// keyboard. You can insert any theme below.
        services.styleProvider = .themed(
            with: .standard,
            keyboardContext: state.keyboardContext,
            fallback: services.styleProvider
        )
    }


    // MARK: - Locale Persistency

    /// The defaults instance in which we store locale id
    var defaults: UserDefaults { .standard }

    /// The key used when persisting locales
    let persistedLocaleKey = "com.keyboardkit.demo.locale"

    /// The last locale used by the keyboard, if any.
    var persistedLocale: Locale? {
        guard let id = persistedLocaleId else { return nil }
        return Locale(identifier: id)
    }

    /// The last locale ID used by the keyboard, if any.
    var persistedLocaleId: String? {
        get { defaults.string(forKey: persistedLocaleKey) }
        set { defaults.set(newValue, forKey: persistedLocaleKey) }
    }
}
