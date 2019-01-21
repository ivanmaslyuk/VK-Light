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
    
    struct LastMessageInDialogPayload {
        let isChat: Bool
        let isOutAndUnread: Bool
    }
    
    var messageWrapper: VKMessageWrapper! { didSet { didSetMessage() } }
    var payload: LastMessageInDialogPayload!
    
    private var imgWidthFull: NSLayoutConstraint!
    private var imgWidth0: NSLayoutConstraint!
    private var textLeadingFull: NSLayoutConstraint!
    private var textLeading0: NSLayoutConstraint!
    
    private var showAvatar : Bool! {
        didSet(val) {
            /* такой вид вызывает варнинги, т.к. устанавливается, что отступ от картинки равен 5, когда он по другому активному констрейнту равен 0 */
//            imgWidthFull.isActive = showAvatar
//            imgWidth0.isActive = !showAvatar
//            textLeadingFull.isActive = showAvatar
//            textLeading0.isActive = !showAvatar
            if showAvatar {
                imgWidth0.isActive = false
                imgWidthFull.isActive = true
                textLeading0.isActive = false
                textLeadingFull.isActive = true
            } else {
                imgWidthFull.isActive = false
                imgWidth0.isActive = true
                textLeadingFull.isActive = false
                textLeading0.isActive = true
            }
        }
    }
    
    private var avatarView: CachedImageView = {
        let av = CachedImageView()
        av.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            av.heightAnchor.constraint(equalToConstant: 28),
            
        ])
        
        av.layer.cornerRadius = 14
        av.clipsToBounds = true
        
        return av
    }()
    
    private var textView: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.lineBreakMode = .byTruncatingTail
        tv.numberOfLines = 1
        tv.preferredMaxLayoutWidth = 200
        return tv
    }()
    
    private var unreadMarkView: UIView = {
        let umv = UIView()
        umv.translatesAutoresizingMaskIntoConstraints = false
        umv.backgroundColor = UIColor(red: 63.0/255.0, green: 129.0/255.0, blue: 203.0/255.0, alpha: 1)
        
        NSLayoutConstraint.activate([
            umv.heightAnchor.constraint(equalToConstant: 7),
            umv.widthAnchor.constraint(equalToConstant: 7)
        ])
        
        umv.layer.cornerRadius = 3.5
        umv.clipsToBounds = true
        
        return umv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarView)
        addSubview(textView)
        addSubview(unreadMarkView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(avatarView)
        addSubview(textView)
        addSubview(unreadMarkView)
        
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 28),
            widthAnchor.constraint(equalToConstant: 240),
            
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            textView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            unreadMarkView.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5),
            unreadMarkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        imgWidthFull = avatarView.widthAnchor.constraint(equalToConstant: 28)
        imgWidth0 = avatarView.widthAnchor.constraint(equalToConstant: 0)
        textLeadingFull = textView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 5)
        textLeading0 = textView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 0)
    }
    
    
    private func didSetMessage() {
        if let url = messageWrapper.profile?.photo100 {
            avatarView.setSource(url: url)
        }
        if let url = messageWrapper.group?.photo100 {
            avatarView.setSource(url: url)
        }
        
        textView.textColor = messageWrapper.hasText ? UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1) : UIColor(red: 21.0/255.0, green: 101.0/255.0, blue: 192.0/255.0, alpha: 1)
        
        textView.text = messageWrapper.message.text
        
        let attachCount = messageWrapper.message.attachments.count
        if !messageWrapper.hasText && attachCount > 0 {
            textView.text = "\(attachCount) вложений"
        }
        if messageWrapper.isSticker { textView.text = "Стикер" }
        
        showAvatar = messageWrapper.message.isOut || payload.isChat
        unreadMarkView.isHidden = !payload.isOutAndUnread
    }
    
}
