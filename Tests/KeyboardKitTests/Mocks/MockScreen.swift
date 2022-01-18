//
//  MockScreen.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

#if os(iOS) || os(watchOS) || os(macOS)
class MockScreen: UIScreen {
    
    var boundsValue = CGRect.zero
    var orientationValue = UIInterfaceOrientation.portrait
    
    override var bounds: CGRect {
        boundsValue
    }
    
}
#endif
