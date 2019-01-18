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
    
    var leftConstr: NSLayoutConstraint!
    var rightConstr: NSLayoutConstraint!
    
    let bubblePadding: CGFloat = 4
    let bubbleMargin: CGFloat = 5
    let bubbleWidth: CGFloat = 300
    
    private var attachmentViews: [UIView] = []
    
    /*let messageText : LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.topInset = 2
        label.rightInset = 4
        label.bottomInset = 2
        label.leftInset = 4
        
        return label
    }()*/
    
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
        imageView.layer.cornerRadius = 18
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
        l.layer.masksToBounds = true
        l.leftInset = 4.0
        l.rightInset = 4.0
        l.topInset = 2.0
        l.bottomInset = 2.0
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .white
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageCard)
        addSubview(messageView)
        addSubview(avatar)
        addSubview(timeLabel)
        
        let constraints = [
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            avatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bubbleMargin),
            
            messageView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: bubbleMargin + bubblePadding),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: bubbleMargin + bubblePadding),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(bubbleMargin + bubblePadding)),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: bubbleWidth),
            messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36 - bubblePadding * 2),
            
            messageCard.topAnchor.constraint(equalTo: messageView.topAnchor, constant: -bubblePadding),
            messageCard.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: bubblePadding),
            messageCard.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: -bubblePadding),
            messageCard.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: bubblePadding),
            
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: timeLabel.bottomInset - bubblePadding),
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: timeLabel.rightInset - bubblePadding),
            
            
        ]
        
        leftConstr = avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        rightConstr = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(bubbleMargin + bubblePadding))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        //clearAttachments()
        messageView.clean()
    }
    
    
    func setMessage() {
        //messageText.text = messageWrapper.message.text
        //messageText.textColor = .white
        messageCard.backgroundColor = messageWrapper.isSticker ? .clear : messageWrapper.message.isOut ? .darkGray : .lightGray
        leftConstr.isActive = messageWrapper.message.out == 0
        rightConstr.isActive = messageWrapper.message.out == 1
        timeLabel.text = messageWrapper.formattedTime
        let lastAttachType = messageWrapper.message.attachments.last?.type
        timeLabel.backgroundColor = lastAttachType == .sticker || lastAttachType == .photo ? UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5) : .clear
        timeLabel.layer.cornerRadius = timeLabel.frame.size.height / 2
        
        avatar.isHidden = messageWrapper.message.out == 1
        if !messageWrapper.message.isOut {
            if let photo = messageWrapper.group?.photo50 {
                avatar.setSource(url: photo)
            }
            if let photo = messageWrapper.profile?.photo100 {
                avatar.setSource(url: photo)
            }
        }
        
        //presentAttachments()
        messageView.messageWrapper = messageWrapper
        
        
    }
    
    
    /*private func presentAttachments() {
        var photos: [VKPhotoModel] = []
        
        for attach in messageWrapper.message.attachments {
            switch attach.type {
            case .photo:
                photos.append(attach.photo!)
            case .sticker:
                presentSticker(sticker: attach.sticker!)
            case .audio:
                continue
            case .audioMessage:
                continue
            case .doc:
                continue
            case .gift:
                continue
            case .link:
                continue
            case .market:
                continue
            case .marketAlbum:
                continue
            case .video:
                continue
            case .wall:
                continue
            case .wallReply:
                continue
            }
        }
        
        presentPhotos(photos: photos)
    }*/
    
    
    /*private func presentPhotos(photos: [VKPhotoModel]) {
        for photo in photos {
            let image = AttachedImageView()
            image.image = photo
            
            attachmentViews.append(image)
            stackView.addArrangedSubview(image)
        }
    }
    
    
    private func presentSticker(sticker: VKStickerModel) {
        let image = CachedImageView()
        image.setSource(url: sticker.images.last!.url)
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        attachmentViews.append(image)
        stackView.addArrangedSubview(image)
    }*/
    
    
    /*private func clearAttachments() {
        for a in attachmentViews {
            a.removeFromSuperview()
        }
        attachmentViews.removeAll()
    }*/

}
