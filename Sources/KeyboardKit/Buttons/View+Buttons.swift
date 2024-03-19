//
//  View+Buttons.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-06-24.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /// Bind keyboard button styles and gestures to the view.
    /// 
    /// The `edgeInsets` init parameter can be used to apply
    /// intrinsic insets within the interactable button area.
    ///
    /// - Parameters:
    ///   - action: The keyboard action to trigger.
    ///   - style: The keyboard style to apply.
    ///   - actionHandler: The keyboard action handler to use.
    ///   - keyboardContext: The keyboard context to use.
    ///   - calloutContext: The callout context to affect, if any.
    ///   - edgeInsets: The edge insets to apply to the interactable area, if any.
    ///   - isPressed: An optional binding that can observe the button pressed state.
    ///   - isInScrollView: Whether the gestures are used in a scroll view, by default `false`.
    ///   - releaseOutsideTolerance: The percentage of the button size that spans outside the button and still counts as a release, by default `1`.
    func keyboardButton(
        for action: KeyboardAction,
        style: KeyboardButton.ButtonStyle,
        actionHandler: KeyboardActionHandler,
        keyboardContext: KeyboardContext,
        calloutContext: CalloutContext?,
        edgeInsets: EdgeInsets = .init(),
        isPressed: Binding<Bool> = .constant(false),
        isInScrollView: Bool = false,
        releaseOutsideTolerance: Double = 1
    ) -> some View {
        self
            .keyboardButton(style)
            .padding(edgeInsets)
            .contentShape(Rectangle())
            .keyboardButtonGestures(
                for: action,
                actionHandler: actionHandler,
                calloutContext: calloutContext,
                isPressed: isPressed,
                isInScrollView: isInScrollView,
                releaseOutsideTolerance: releaseOutsideTolerance
            )
            .localeContextMenu(
                for: action,
                context: keyboardContext,
                actionHandler: actionHandler
            )
            .keyboardButtonAccessibility(for: action)
    }
    
    @ViewBuilder
    func keyboardButtonAccessibility(
        for action: KeyboardAction
    ) -> some View {
        if let label = action.standardAccessibilityLabel {
            self.accessibilityElement()
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(label)
        } else {
            self.accessibilityHidden(true)
        }
    }
}

private extension View {
    
    @ViewBuilder
    func localeContextMenu(
        for action: KeyboardAction,
        context: KeyboardContext,
        actionHandler: KeyboardActionHandler
    ) -> some View {
        if shouldApplyLocaleContextMenu(for: action, context: context) {
            self.localeContextMenu(for: context) {
                actionHandler.handle(.release, on: action)
            }.id(context.locale.identifier)
        } else {
            self
        }
    }
    
    func shouldApplyLocaleContextMenu(
        for action: KeyboardAction,
        context: KeyboardContext
    ) -> Bool {
        switch action {
        case .nextLocale: return true
        case .space: return context.spaceLongPressBehavior == .openLocaleContextMenu
        default: return false
        }
    }
}

#Preview {
    
    struct Preview: View {
        
        @State
        var isPressed = false
        
        @State
        var context: KeyboardContext = {
            let context = KeyboardContext()
            context.locales = KeyboardLocale.allCases.map { $0.locale }
            context.localePresentationLocale = KeyboardLocale.swedish.locale
            context.spaceLongPressBehavior = .openLocaleContextMenu
            return context
        }()
        
        var body: some View {
            VStack {
                VStack(spacing: 20) {
                    button(for: Text("a"), style: .preview1)
                    button(
                        for: Text("A"),
                        style: .preview2,
                        insets: .init(top: 5, leading: 10, bottom: 15, trailing: 20)
                    )
                    button(
                        for: Text(context.locale.identifier),
                        action: .nextLocale,
                        style: .preview1
                    )
                    button(for: Image.keyboardGlobe, style: .preview1)
                }
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(20)
                
                Text("\(isPressed ? "Pressed": "Not Pressed")")
            }
        }
        
        func button<Content: View>(
            for content: Content,
            action: KeyboardAction = .backspace,
            style: KeyboardButton.ButtonStyle,
            insets: EdgeInsets = .init()
        ) -> some View {
            content
                .padding()
                .keyboardButton(
                    for: action,
                    style: style,
                    actionHandler: .preview,
                    keyboardContext: context,
                    calloutContext: .preview,
                    edgeInsets: insets,
                    isPressed: $isPressed
                )
        }
    }

    return Preview()
}
