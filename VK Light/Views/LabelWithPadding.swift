//
//  LabelWithPadding.swift
//  VK Light
//
//  Created by Иван Маслюк on 09/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LabelWithPadding: UILabel, KnowsOwnSize {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    var heightOfSelf: CGFloat {
        //let labelSize = self.sizeThatFits(CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude))
        //return labelSize.height
        let noInsets = self.text?.height(withConstrainedWidth: 300 - leftInset - rightInset, font: self.font) ?? 0
        return noInsets + topInset + bottomInset
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
