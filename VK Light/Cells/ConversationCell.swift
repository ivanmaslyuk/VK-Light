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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dialogImage.layer.cornerRadius = self.dialogImage.frame.height / 2
        self.dialogImage.clipsToBounds = true
        unreadCountView.clipsToBounds = true
        unreadCountView.layer.cornerRadius = unreadCountView.frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let img = dialogWrapper.photo100 {
            dialogImage.setSource(url: img)
        }
        dialogName.text = dialogWrapper.dialogTitle
 
        
        let unreadCount = dialogWrapper.dialog.unreadCount ?? 0
        unreadCountLabel.text = String(unreadCount)
        unreadCountView.isHidden = unreadCount == 0
        dialogTimeLabel.text = dialogWrapper.lastMessage.formattedTime(hoursOnly: false)
        
        let outAndUnread = dialogWrapper.dialog.outRead != dialogWrapper.lastMessage.message.id! && dialogWrapper.lastMessage.message.isOut
        lastMessageView.payload = LastMessageView.LastMessageInDialogPayload.init(isChat: dialogWrapper.isChat, isOutAndUnread: outAndUnread)
        lastMessageView.messageWrapper = dialogWrapper.lastMessage
    }
    
    override func prepareForReuse() {
        self.dialogImage?.image = nil
    }
    
    

}
