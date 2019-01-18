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
    @IBOutlet weak var dialogImage: UIImageView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessageAvatar: UIImageView!
    @IBOutlet weak var lastMessageUnreadMark: UIView!
    @IBOutlet weak var unreadCountView: UIView!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var dialogTimeLabel: UILabel!
    
    var profile: VKProfileModel?
    var group: VKGroupModel?

    var item: VKGetConversationsResponse.Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dialogImage.layer.cornerRadius = self.dialogImage.frame.height / 2
        self.dialogImage.clipsToBounds = true
        lastMessageUnreadMark.clipsToBounds = true
        lastMessageUnreadMark.layer.cornerRadius = lastMessageUnreadMark.frame.height / 2
        unreadCountView.clipsToBounds = true
        unreadCountView.layer.cornerRadius = unreadCountView.frame.height / 2
        lastMessageAvatar.clipsToBounds = true
        lastMessageAvatar.layer.cornerRadius = lastMessageAvatar.frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let unwrappedItem = item else {return}
        
        switch unwrappedItem.conversation.peer.type {
        case .chat:
            self.dialogName.text = unwrappedItem.conversation.chatSettings?.title
            if let photo = unwrappedItem.conversation.chatSettings?.photo {
                downloadAndSetImage(for: dialogImage, from: photo.photo100)
                downloadAndSetImage(for: lastMessageAvatar, from: photo.photo100)
            }
            break
        case .group:
            guard let group = group else {return}
            self.dialogName.text = group.name
            downloadAndSetImage(for: dialogImage, from: group.photo100)
            downloadAndSetImage(for: lastMessageAvatar, from: group.photo100)
            break
        case .user:
            guard let profile = profile else {return}
            self.dialogName.text = profile.firstName + " " + profile.lastName
            if let photo = profile.photo100 {
                downloadAndSetImage(for: dialogImage, from: photo)
                downloadAndSetImage(for: lastMessageAvatar, from: photo)
            }
            break
        case .email:
            self.dialogName.text = "ЧАТ С EMAIL"
            break
        }
        
        self.lastMessageLabel.text = unwrappedItem.lastMessage.text
        lastMessageUnreadMark.isHidden = unwrappedItem.lastMessage.fromId == Int(UserDefaults.standard.value(forKey: "vk_user_id") as! String)
        lastMessageAvatar.isHidden = unwrappedItem.conversation.chatSettings == nil
        
        
        
        let unreadCount = unwrappedItem.conversation.unreadCount ?? 0
        unreadCountLabel.text = String(unreadCount)
        unreadCountView.isHidden = unreadCount == 0
        dialogTimeLabel.text = makeDatePretty(unwrappedItem.lastMessage.date)
        
        
    }
    
    override func prepareForReuse() {
        self.dialogImage?.image = nil
    }
    
    func downloadAndSetImage(for image: UIImageView, from: URL) {
        URLSession.shared.dataTask(with: from) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "no error while downloading image")
                return
            }
            
            DispatchQueue.main.async {
                //print(from)
                image.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
    private func makeDatePretty(_ date: Date) -> String {
        let calendar = Calendar.current
        
        let minutes = String(calendar.component(.minute, from: date))
        let formattedMinutes = minutes.count == 1 ? "0" + minutes : minutes
        return String(calendar.component(.hour, from: date)) + ":" + formattedMinutes
    }

}
