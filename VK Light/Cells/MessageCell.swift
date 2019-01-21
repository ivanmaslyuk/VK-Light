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
        return (bubblePadding + bubbleMargin) * 2
    }
    
    var leftConstr: NSLayoutConstraint!
    var rightConstr: NSLayoutConstraint!
    
    static let bubblePadding: CGFloat = 4
    static let bubbleMargin: CGFloat = 5
    static let minHeight: CGFloat = 36
    let bubbleWidth: CGFloat = 300
    
    private let inColor = UIColor(red: 235, green: 237, blue: 239)
    private let outColor = UIColor(red: 28, green: 146, blue: 253)
    
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
        card.layer.cornerRadius = 18
        card.layer.masksToBounds = true
        card.clipsToBounds = false
        return card
    }()
    
    private let avatar : CachedImageView = {
        var imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let messageView : MessageView = {
        let stView = MessageView()
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
            
            messageView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: MessageCell.bubbleMargin + MessageCell.bubblePadding),
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MessageCell.bubbleMargin + MessageCell.bubblePadding),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(MessageCell.bubbleMargin + MessageCell.bubblePadding)),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: bubbleWidth),
            messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: MessageCell.minHeight - MessageCell.bubblePadding * 2),
            
            messageCard.topAnchor.constraint(equalTo: messageView.topAnchor, constant: -MessageCell.bubblePadding),
            messageCard.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: MessageCell.bubblePadding),
            messageCard.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: -MessageCell.bubblePadding),
            messageCard.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: MessageCell.bubblePadding),
            
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: timeLabel.bottomInset - MessageCell.bubblePadding),
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: timeLabel.rightInset - MessageCell.bubblePadding),
            
            
        ]
        
        leftConstr = avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        rightConstr = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(MessageCell.bubbleMargin + MessageCell.bubblePadding))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        //clearAttachments()
        messageView.clean()
    }
    
    
    func setMessage() {
        messageCard.backgroundColor = messageWrapper.isSticker ? .clear : messageWrapper.message.isOut ? outColor : inColor
        isIncoming = !messageWrapper.message.isOut
        timeLabel.text = messageWrapper.formattedTime
        let lastAttachType = messageWrapper.message.attachments.last?.type
        timeLabel.backgroundColor = lastAttachType == .sticker || lastAttachType == .photo ? UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5) : .clear
//        timeLabel.layer.cornerRadius = timeLabel.frame.size.height / 2
        
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
