//
//  AttachedImageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 06/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class AttachedImageView : UIView {
    
    public var image: VKPhotoModel! {
        didSet { setImage() }
    }
    
    private var imageView: CachedImageView = {
        var iv = CachedImageView()
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
        let aspectRatio = Double(img.width) / Double(img.height)
        let adjustedWidth = Double(300)
        var adjustedHeight = adjustedWidth / aspectRatio
        
        if adjustedHeight > 400 { adjustedHeight = 400 }
        
        imageView.frame.size = CGSize(width: adjustedWidth, height: adjustedHeight)
        
        let constraints = [
            self.heightAnchor.constraint(equalToConstant: CGFloat(adjustedHeight) + 6),
            self.widthAnchor.constraint(equalToConstant: CGFloat(adjustedWidth)),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 3), // TODO: починить это, нет отступа сверху
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            imageView.heightAnchor.constraint(equalToConstant: CGFloat(adjustedHeight)),
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(adjustedWidth)),
        ]
        
        NSLayoutConstraint.activate(constraints)
        imageView.setSource(url: img.url)
        
    }
    
    
}
