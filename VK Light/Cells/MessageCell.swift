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
    
    let bubblePadding: CGFloat = 8
    let bubbleMargin: CGFloat = 5
    let bubbleWidth: CGFloat = 300
    
    let messageText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
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
    
    private let stackView : UIStackView = {
        let stView = UIStackView()
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.backgroundColor = .clear
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
        
        stackView.addArrangedSubview(messageText)
        addSubview(messageCard)
        addSubview(stackView)
        addSubview(avatar)
        addSubview(timeLabel)
        
        let constraints = [
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            avatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bubbleMargin),
            
            stackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: bubbleMargin + bubblePadding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: bubbleMargin + bubblePadding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(bubbleMargin + bubblePadding)),
            stackView.widthAnchor.constraint(lessThanOrEqualToConstant: bubbleWidth),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36 - bubblePadding * 2),
            
            messageCard.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -bubblePadding),
            messageCard.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: bubblePadding),
            messageCard.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -bubblePadding),
            messageCard.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: bubblePadding),
            
            timeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: timeLabel.bottomInset),
            timeLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: timeLabel.rightInset)
        ]
        
        leftConstr = avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        rightConstr = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(bubbleMargin + bubblePadding))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        clearAttachments()
    }
    
    
    func setMessage() {
        messageText.text = messageWrapper.message.text
        messageText.textColor = .white
        messageCard.backgroundColor = messageWrapper.isSticker ? .clear : messageWrapper.message.out == 1 ? .darkGray : .lightGray
        leftConstr.isActive = messageWrapper.message.out == 0
        rightConstr.isActive = messageWrapper.message.out == 1
        timeLabel.text = messageWrapper.formattedTime
        let lastAttachType = messageWrapper.message.attachments.last?.type
        timeLabel.backgroundColor = lastAttachType == .sticker || lastAttachType == .photo ? UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5) : .clear
        timeLabel.layer.cornerRadius = timeLabel.frame.size.height / 2
        
        avatar.isHidden = messageWrapper.message.out == 1
        if messageWrapper.message.out == 0 {
            if let photo = messageWrapper.group?.photo50 {
                avatar.setSource(url: photo)
            }
            if let photo = messageWrapper.profile?.photo100 {
                avatar.setSource(url: photo)
            }
        }
        
        presentAttachments()
        
        
        
    }
    
    
    private var attachmentViews: [UIView] = []
    
    
    private func presentAttachments() {
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
    }
    
    
    private func presentPhotos(photos: [VKPhotoModel]) {
        for photo in photos {
            let image = CachedImageView()
            image.setSource(url: photo.sizes.last!.url)
            image.contentMode = .scaleAspectFit
            let size = photo.getAppropriateSize(for: Int(bubbleWidth))
            image.heightAnchor.constraint(equalToConstant: CGFloat(size.height)).isActive = true
            image.backgroundColor = .red
            image.widthAnchor.constraint(equalToConstant: bubbleWidth).isActive = true
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
        //image.backgroundColor = .blue
        attachmentViews.append(image)
        stackView.addArrangedSubview(image)
    }
    
    
    private func clearAttachments() {
        for a in attachmentViews {
            a.removeFromSuperview()
        }
        attachmentViews.removeAll()
    }

}
