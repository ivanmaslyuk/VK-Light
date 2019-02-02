//
//  KnowsOwnSizeView.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/02/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class KnowsOwnSizeView : UIView, KnowsOwnSize {
    var heightOfSelf: CGFloat {
        return frame.height
    }
    
    
}
