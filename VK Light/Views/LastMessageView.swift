//
//  LastMessageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class LastMessageView : UIView {
    
    var messageWrapper: VKMessageWrapper!
    
    private var avatarView: CachedImageView = {
        let av = CachedImageView()
        av.isAvatar = true
        
        NSLayoutConstraint.activate([
            av.heightAnchor.constraint(equalToConstant: 28),
            av.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        return av
    }()
    
    private var textView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.lineBreakMode = .byTruncatingTail
        tv.numberOfLines = 1
        tv.preferredMaxLayoutWidth = 200
        return tv
    }()
    
    private var unreadMarkView: UIView = {
        let umv = UIView()
        umv.backgroundColor = UIColor(red: 63.0/255.0, green: 129.0/255.0, blue: 203.0/255.0, alpha: 1)
        
        NSLayoutConstraint.activate([
            umv.heightAnchor.constraint(equalToConstant: 28),
            umv.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        return umv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarView)
        addSubview(textView)
        addSubview(unreadMarkView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 5),
            textView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            unreadMarkView.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5),
            unreadMarkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
