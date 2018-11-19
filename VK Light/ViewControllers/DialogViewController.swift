//
//  DialogViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit
//import ReverseExtension

class DialogViewController: UIViewController {

    var dialogInfo : VKGetConversationsResponse.Item?
    var profile :  VKProfileModel?
    var group : VKGroupModel?
    private var messages : [VKMessageModel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        
        tableView.transform = CGAffineTransform.identity.rotated(by: .pi) // переворачиваем TableView
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.frame.size.width - 8.0) // передвигаем скролл-индикатор вправо*/
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        tableView.reloadData()
        //tableView.scrollToRow(at: IndexPath(index: messages!.count), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func setTitle() {
        guard let info = dialogInfo else {return}
        switch info.conversation.peer.type {
        case .user:
            guard let profile = profile else {return}
            self.title = profile.firstName + " " + profile.lastName
        case .chat:
            guard let chat = info.conversation.chatSettings else {return}
            self.title = chat.title
        case .group:
            guard let group = group else {return}
            self.title = group.name
        case .email:
            self.title = "ЧАТ С EMAIL"
        }
    }
    
    func loadMessages() {
        let api = VKMessagesApi()
        guard let dialogInfo = dialogInfo else {return}
        
        guard let vkResponse = api.getHistory(peerId: dialogInfo.conversation.peer.id, startMessageId: dialogInfo.lastMessage.id!) else {print("не удалось получить сообщения");return}
        if let response = vkResponse.response {
            messages = response.items
        }
        if let error = vkResponse.error {
            print(error)
        }
    }
    

}

extension DialogViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        
        let defaults = UserDefaults.standard
        if let message = messages?[indexPath.row] {
            cell.messageModel = message
            
            cell.isFromMe = String(message.fromId) == defaults.string(forKey: "vk_user_id")
        }
        cell.transform = CGAffineTransform.identity.rotated(by: .pi) // поворот
        cell.layoutSubviews()
        
        return cell
    }
    
}
