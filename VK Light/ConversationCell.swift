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
    
    var profile: VKProfileModel?
    var group: VKGroupModel?

    var item: VKGetConversationsResponse.Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dialogImage.layer.cornerRadius = self.dialogImage.frame.height / 2
        self.dialogImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let unwrappedItem = item else {return}
        
        switch unwrappedItem.conversation.peer.type {
        case .chat:
            self.dialogName.text = unwrappedItem.conversation.chatSettings?.title
            if let photo = unwrappedItem.conversation.chatSettings?.photo {
                downloadAndSetImage(from: photo.photo100)
            }
            break
        case .group:
            guard let group = group else {return}
            self.dialogName.text = group.name
            downloadAndSetImage(from: group.photo100)
            break
        case .user:
            guard let profile = profile else {return}
            self.dialogName.text = profile.firstName + " " + profile.lastName
            if let photo = profile.photo100 {
                downloadAndSetImage(from: photo)
            }
            break
        case .email:
            self.dialogName.text = "ЧАТ С EMAIL"
            break
        }
        
        self.lastMessageLabel.text = unwrappedItem.lastMessage.text
    }
    
    override func prepareForReuse() {
        self.dialogImage?.image = nil
    }
    
    func downloadAndSetImage(from: URL) {
        URLSession.shared.dataTask(with: from) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "no error while downloading image")
                return
            }
            
            DispatchQueue.main.async {
                print(from)
                self.dialogImage.image = UIImage(data: data)
            }
            
        }.resume()
    }

}
