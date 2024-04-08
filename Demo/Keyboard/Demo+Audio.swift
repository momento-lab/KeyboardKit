//
//  AudioFeedback+Demo.swift
//  Keyboard
//
//  Created by Daniel Saidi on 2022-02-07.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation
import KeyboardKit

extension Feedback.Audio {
 
    static let fuse = Self.customUrl(
        Bundle.main.url(forResource: "fuse", withExtension: "wav")
    )
}