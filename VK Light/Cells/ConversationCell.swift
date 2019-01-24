//
//  ConversationCell.swift
//  VK Light
//
//  Created by Иван Маслюк on 16/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var dialogName: UILabel!
    @IBOutlet weak var dialogImage: CachedImageView!
    @IBOutlet weak var unreadCountView: UIView!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var dialogTimeLabel: UILabel!
    @IBOutlet weak var lastMessageView: LastMessageView!
    
    var dialogWrapper: VKDialogWrapper!
    
    private var onlineIndicator: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 15),
            iv.heightAnchor.constraint(equalToConstant: 15)
        ])
        iv.image = UIImage(named: "online")
        return iv
    }()
    
    private var onlineMobileIndicator: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 12),
            iv.heightAnchor.constraint(equalToConstant: 17)
            ])
        iv.image = UIImage(named: "onlineMobile")
        return iv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dialogImage.layer.cornerRadius = self.dialogImage.frame.height / 2
        self.dialogImage.clipsToBounds = true
        unreadCountView.clipsToBounds = true
        unreadCountView.layer.cornerRadius = unreadCountView.frame.height / 2
        
        addSubview(onlineIndicator)
        addSubview(onlineMobileIndicator)
        NSLayoutConstraint.activate([
            onlineIndicator.bottomAnchor.constraint(equalTo: dialogImage.bottomAnchor),
            onlineIndicator.trailingAnchor.constraint(equalTo: dialogImage.trailingAnchor),
            onlineMobileIndicator.bottomAnchor.constraint(equalTo: dialogImage.bottomAnchor),
            onlineMobileIndicator.trailingAnchor.constraint(equalTo: dialogImage.trailingAnchor),
        ])
        bringSubviewToFront(onlineIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let img = dialogWrapper.photo100 {
            dialogImage.setSource(url: img)
        }
        dialogName.text = dialogWrapper.dialogTitle
 
        let unreadCount = dialogWrapper.unreadCount
        unreadCountLabel.text = String(unreadCount)
        unreadCountView.isHidden = unreadCount == 0
        dialogTimeLabel.text = dialogWrapper.lastMessage.formattedTime(hoursOnly: false)
        
        let outAndUnread = dialogWrapper.outRead != dialogWrapper.lastMessage.message.id! && dialogWrapper.lastMessage.message.isOut
        lastMessageView.payload = LastMessageView.LastMessageInDialogPayload(isChat: dialogWrapper.isChat, isOutAndUnread: outAndUnread)
        lastMessageView.messageWrapper = dialogWrapper.lastMessage
        
        onlineIndicator.isHidden = dialogWrapper.profile?.online != .yes || dialogWrapper.profile?.onlineMobile == .yes
        onlineMobileIndicator.isHidden = dialogWrapper.profile?.onlineMobile != .yes
    }
    
    override func prepareForReuse() {
        self.dialogImage?.image = nil
    }
    
    

}
