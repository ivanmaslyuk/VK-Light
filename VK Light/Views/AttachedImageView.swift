//
//  AttachedImageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 06/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class AttachedImageView : UIView, KnowsOwnSize {
    
    private let topPadding: CGFloat = 3.0
    private let bottomPadding: CGFloat = 3.0
    
    public var image: VKPhotoModel! {
        didSet { setImage() }
    }
    
    private var imageView: CachedImageView = {
        var iv = CachedImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 7
        iv.backgroundColor = .darkGray
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setImage() {
        let img = image.getAppropriatelySized(for: 300)
//        let aspectRatio = Double(img.width) / Double(img.height)
//        let adjustedWidth = Double(300)
//        var adjustedHeight = adjustedWidth / aspectRatio
//
//        if adjustedHeight > 400 { adjustedHeight = 400 }
        let newSize = adjustedSize(for: img, maxWidth: 300)
        imageView.frame.size = newSize//CGSize(width: adjustedWidth, height: adjustedHeight)
        
        let constraints = [
            self.heightAnchor.constraint(equalToConstant: newSize.height + topPadding + bottomPadding),
            self.widthAnchor.constraint(equalToConstant: newSize.width),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding), // TODO: починить это, нет отступа сверху
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
            imageView.heightAnchor.constraint(equalToConstant: newSize.height),
            imageView.widthAnchor.constraint(equalToConstant: newSize.width),
        ]
        
        NSLayoutConstraint.activate(constraints)
        imageView.setSource(url: img.url)
        
    }
    
    private func adjustedSize(for size: VKPhotoModel.Size, maxWidth: CGFloat) -> CGSize {
        let aspectRatio = CGFloat(size.width) / CGFloat(size.height)
        let adjustedWidth = maxWidth
        var adjustedHeight = adjustedWidth / aspectRatio
        
        if adjustedHeight > 400 { adjustedHeight = 400 }
        
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    var heightOfSelf: CGFloat {
        let img = image.getAppropriatelySized(for: 300)
        let size = adjustedSize(for: img, maxWidth: 300)
        return size.height + topPadding + bottomPadding
    }
    
}
