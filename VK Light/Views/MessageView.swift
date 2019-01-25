//
//  MessageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 06/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class MessageView : UIStackView, KnowsOwnSize {
    public var isForwarded = false
    public var messageWrapper: VKMessageWrapper! {
        didSet { presentContent() }
    }
    
    private var attachmentViews = [UIView]()
    
    let messageText : LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        
        label.topInset = 4
        label.bottomInset = 4
        label.rightInset = 8
        label.leftInset = 8
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        
        /*let constraints = [
            topAnchor.constraint(equalTo: topAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)*/
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func presentContent() {
        if isForwarded { presentHeader() }
        let message = messageWrapper.message
        
        if !message.text.isEmpty {
            messageText.text = message.text
            addArrangedSubview(messageText)
        }
        
        messageText.textColor = message.isOut || isForwarded ? .white : .black
        
        presentAttachments()
        presentForwarded()
    }
    
    
    func presentAttachments() {
        var photos: [VKPhotoModel] = []
        
        for attach in messageWrapper.message.attachments {
            switch attach.type {
            case .photo:
                photos.append(attach.photo!)
            case .sticker:
                print("cnикер: \(attach.sticker!)")
                presentSticker(sticker: attach.sticker!)
            case .audio:
                continue
            case .audioMessage:
                print("В аудио \(attach.audioMessage!.waveform.count) элементов")
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
            case .graffiti:
                continue
            case .poll:
                continue
            }
        }
        
        presentPhotos(photos: photos)
    }
    
    
    private func presentForwarded() {
        for m in messageWrapper.forwardedMessages {
            let fwdMessage = MessageView()
            fwdMessage.isForwarded = true
            fwdMessage.messageWrapper = m
            
            addArrangedSubview(fwdMessage)
        }
    }
    
    
    private func presentHeader() {
        let header = ForwardedMessageHeader()
        header.profile = messageWrapper.profile
        header.group = messageWrapper.group
        header.date = messageWrapper.message.date
        header.present()
        
        addArrangedSubview(header)
    }
    
    
    private func presentPhotos(photos: [VKPhotoModel]) {
        for photo in photos {
            let image = AttachedImageView()
            image.image = photo
            
            addArrangedSubview(image)
        }
    }
    
    
    private func presentSticker(sticker: VKStickerModel) {
        let image = CachedImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setSource(url: sticker.images.last!.url)
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        addArrangedSubview(image)
    }
    
    
    public func clean() {
        for a in attachmentViews {
            a.removeFromSuperview()
        }
        attachmentViews.removeAll()
    }
    
    
    override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        attachmentViews.append(view)
    }
    
    var heightOfSelf: CGFloat {
        guard let _ = messageWrapper else { fatalError() }
        var height: CGFloat = 0
        for item in attachmentViews {
            let kos = item as! KnowsOwnSize
            var newHeight = kos.heightOfSelf
            if newHeight == 0 { newHeight = 150 }
            height += newHeight
        }
        return height
    }
}
