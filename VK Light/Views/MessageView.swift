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
    private var depth: Int
    
    private var maxContentWidth: CGFloat {
        var width = MessageCell.bubbleWidth
        if depth > 0 {
            width -= CGFloat(3 * depth)
        }
        return width
    }
    
    let messageText : LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        
        label.topInset = 6
        label.bottomInset = 6
        label.rightInset = 12
        label.leftInset = 12
        
        return label
    }()
    
    init(depth: Int) {
        self.depth = depth
        super.init(frame: .zero)
        axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func presentContent() {
        if isForwarded { presentHeader() }
        let message = messageWrapper.message
        
        if !message.text.isEmpty {
            messageText.text = message.text
            messageText.maxWidth = maxContentWidth
            addArrangedSubview(messageText)
        }
        
//        messageText.textColor = message.isOut || isForwarded ? .white : .black
        
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
            let fwdMessage = ForwardedMessageView(depth: depth + 1)
            fwdMessage.message = m
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
        
        
        guard !photos.isEmpty else { return }
        for i in 0...photos.count-1 {
            let image = AttachedImageView(image: photos[i], width: maxContentWidth)
            if !isForwarded {
                if messageWrapper.isSingleImage {
                    image.addPadding = false
                }
                if i == 0 {
                    image.roundTop = true
                }
                if i == photos.count-1 {
                    image.roundBottom = true
                }
            }
            addArrangedSubview(image)
        }
    }
    
    
    private func presentSticker(sticker: VKStickerModel) {
        let image = CachedImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setSource(url: sticker.images.last!.url)
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 160).isActive = true
        image.widthAnchor.constraint(equalToConstant: 160).isActive = true
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
            height += kos.heightOfSelf
        }
        return height
    }
    
}
