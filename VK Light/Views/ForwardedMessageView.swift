//
//  ForwardedMessageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 30/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class ForwardedMessageView : UIView, KnowsOwnSize {
    
    var heightOfSelf: CGFloat {
//        layoutSubviews()
        let height = messageView.heightOfSelf + 6
        return height
    }
    
    
    var message: VKMessageWrapper! {
        didSet {
            messageView.isForwarded = true
            messageView.messageWrapper = self.message
        }
    }
    
    var depth: Int
    
    init(depth: Int) {
        self.depth = depth
        messageView = MessageView(depth: depth)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        addSubview(leftBar)
        addSubview(messageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var leftBar : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 2).isActive = true
        v.clipsToBounds = true
        v.layer.cornerRadius = 1
        v.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return v
    }()
    
    private var messageView : MessageView //= {
//        let v = MessageView(depth: depth)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
    
    private func setupConstraints() {
        let offset: CGFloat = depth == 1 ? 10 : 1
        NSLayoutConstraint.activate([
            leftBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
            leftBar.topAnchor.constraint(equalTo: messageView.topAnchor),
            leftBar.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
            
            messageView.leadingAnchor.constraint(equalTo: leftBar.trailingAnchor),
            messageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            messageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
//            self.heightAnchor.constraint(equalTo: messageView.heightAnchor, constant: 6)
        ])
    }
    
    
}
