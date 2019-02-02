//
//  VKCachedImageViewWithIntrinsicSize.swift
//  VK Light
//
//  Created by Иван Маслюк on 30/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class VKCachedImageViewWithIntrinsicSize : CachedImageView {
    var imageModel: VKPhotoModel?
    
    
    override var intrinsicContentSize: CGSize {
        let size = imageModel?.getAppropriatelySized(for: 3000)
        guard size != nil else { return .zero }
//        let adjusted = adjustedSize(for: size!, maxWidth: 300)
        print("intrinzicContentSize called for VKCachedImageViewWithIntrinsicSize")
        print("\(size!.width) || \(size!.height)")
        return CGSize(width: -1, height: -1)
    }
    
//    private func adjustedSize(for size: VKPhotoModel.Size, maxWidth: CGFloat) -> CGSize {
//        let aspectRatio = CGFloat(size.width) / CGFloat(size.height)
//        let adjustedWidth = maxWidth
//        var adjustedHeight = adjustedWidth / aspectRatio
//        
//        if adjustedHeight > 400 { adjustedHeight = 400 }
//        
//        return CGSize(width: adjustedWidth, height: adjustedHeight)
//    }
    
//    override func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
//        if axis == .horizontal {
//            return UILayoutPriority(rawValue: 1000)
//        } else {
//            return UILayoutPriority(rawValue: 1000)
//        }
//    }
    
//    override func contentHuggingPriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
//        if axis == .horizontal {
//            return UILayoutPriority(rawValue: 0)
//        } else {
//            return super.contentHuggingPriority(for: axis)
//        }
//    }
}
