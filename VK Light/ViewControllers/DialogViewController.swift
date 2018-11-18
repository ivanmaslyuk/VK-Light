//
//  DialogViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit
import ReverseExtension

class DialogViewController: UIViewController {

    var dialogInfo : VKGetConversationsResponse.Item?
    private var messages : [VKMessageModel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = dialogInfo?.conversation.peer.id {
            self.title = String(id)
        }
        
        //tableView.rowHeight = UITableView
        tableView.re.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        tableView.reloadData()
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
        cell.textLabel?.text = messages?[indexPath.row].text
        return cell
    }
}
