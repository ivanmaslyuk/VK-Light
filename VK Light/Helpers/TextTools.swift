//
//  TextTools.swift
//  VK Light
//
//  Created by Иван Маслюк on 04/02/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

public func lastLineMaxX(message: NSAttributedString, labelWidth: CGFloat) -> CGFloat {
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let labelSize = CGSize(width: labelWidth, height: .infinity)
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: labelSize)
    let textStorage = NSTextStorage(attributedString: message)
    
    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = .byWordWrapping
    textContainer.maximumNumberOfLines = 0
    
    let lastGlyphIndex = layoutManager.glyphIndexForCharacter(at: message.length - 1)
    let lastLineFragmentRect = layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex,
                                                                  effectiveRange: nil)
    
    return lastLineFragmentRect.maxX
}
