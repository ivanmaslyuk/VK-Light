//
//  MessageCell.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    var messageWrapper : VKMessageWrapper! {
        didSet{ setMessage() }
    }
    
    static var absolutePadding: CGFloat {
        return (bubbleMargin) * 2
    }
    
    var leftConstr: NSLayoutConstraint!
    var rightConstr: NSLayoutConstraint!
    
//    static let bubblePadding: CGFloat = 4
    static let bubbleMargin: CGFloat = 3
    static let minHeight: CGFloat = 36
    static let bubbleWidth: CGFloat = 300
    
    private let inColor = UIColor(red: 236, green: 237, blue: 239)
    private let outColor = UIColor(red: 204, green: 228, blue: 255)
    
    private var attachmentViews: [UIView] = []
    
    
    private var isIncoming: Bool! {
        didSet {
            if isIncoming {
                rightConstr.isActive = false
                leftConstr.isActive = true
            } else {
                leftConstr.isActive = false
                rightConstr.isActive = true
            }
        }
    }
    
    private let messageCard : UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        card.clipsToBounds = false
        return card
    }()
    
    private let avatar : CachedImageView = {
        var imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let messageView : MessageView = {
        let stView = MessageView(depth: 0)
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.backgroundColor = .black
        stView.axis = .vertical
        return stView
    }()
    
    private let timeLabel : LabelWithPadding = {
        var l = LabelWithPadding()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.clipsToBounds = true
        l.leftInset = 4.0
        l.rightInset = 4.0
        l.topInset = 2.0
        l.bottomInset = 2.0
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .white
        l.layer.cornerRadius = l.frame.size.height / 2
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageCard)
        contentView.addSubview(messageView)
        contentView.addSubview(avatar)
        contentView.addSubview(timeLabel)
        
        let constraints = [
            //heightAnchor.constraint(equalTo: messageView.heightAnchor, constant: (bubbleMargin + bubblePadding) * 2),
            
            avatar.widthAnchor.constraint(equalToConstant: 32),
            avatar.heightAnchor.constraint(equalToConstant: 32),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MessageCell.bubbleMargin),
            
            messageView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: MessageCell.bubbleMargin),
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MessageCell.bubbleMargin),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MessageCell.bubbleMargin),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: MessageCell.bubbleWidth),
//            messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
//            messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: MessageCell.minHeight),
            
            messageCard.topAnchor.constraint(equalTo: messageView.topAnchor),
            messageCard.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
            messageCard.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            messageCard.trailingAnchor.constraint(equalTo: messageView.trailingAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -(12 - timeLabel.rightInset)),
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -(6 - timeLabel.bottomInset)),
            
            
        ]
        
        leftConstr = avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        rightConstr = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MessageCell.bubbleMargin)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        //clearAttachments()
        messageView.clean()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.layer.cornerRadius = timeLabel.frame.size.height / 2
    }
    
    
    func setMessage() {
        messageCard.backgroundColor = messageWrapper.isSticker ? .clear : messageWrapper.message.isOut ? outColor : inColor
        isIncoming = !messageWrapper.message.isOut
        timeLabel.text = messageWrapper.formattedTime
        let lastAttachType = messageWrapper.message.attachments.last?.type
        timeLabel.backgroundColor = lastAttachType == .sticker || lastAttachType == .photo ? UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5) : .clear
        timeLabel.textColor = lastAttachType == .sticker || lastAttachType == .photo ? .white : .black
        
        avatar.isHidden = messageWrapper.message.out == 1
        if !messageWrapper.message.isOut {
            if let photo = messageWrapper.group?.photo50 {
                avatar.setSource(url: photo)
            }
            if let photo = messageWrapper.profile?.photo100 {
                avatar.setSource(url: photo)
            }
        }
        
        messageView.messageWrapper = messageWrapper
    }
    
    

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }
}
