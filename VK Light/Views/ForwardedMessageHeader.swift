//
//  ForwardedMessageHeader.swift
//  VK Light
//
//  Created by Иван Маслюк on 06/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit


class ForwardedMessageHeader : UIView, KnowsOwnSize {
    
    public var profile: VKProfile?
    public var group: VKGroup?
    public var date: Date!
    public var avatarDiameter = 35
    
    private var avatarImage: CachedImageView = {
        let img = CachedImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 35 / 2
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImage)
        addSubview(nameLabel)
        addSubview(dateLabel)
        
        let constraints = [
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: CGFloat(avatarDiameter)),
            avatarImage.widthAnchor.constraint(equalToConstant: CGFloat(avatarDiameter)),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -1),
            
            dateLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 4),
            dateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 1),
            
            self.heightAnchor.constraint(equalTo: avatarImage.heightAnchor, constant: 10),
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func present() {
        if let p = profile {
            nameLabel.text = p.formattedName
            if let url = p.photo100 {
                avatarImage.setSource(url: url)
            }
        }
        if let g = group {
            nameLabel.text = g.name
            avatarImage.setSource(url: g.photo100)
        }
        dateLabel.text = date.description
    }
    
    var heightOfSelf: CGFloat {
        return CGFloat(avatarDiameter) + 10
    }
}
