//
//  ConversationsViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {

    var conversations : [VKGetConversationsResponse.Item] = []
    var vkResponse : VKGetConversationsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Диалоги"
        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 88, bottom: 0, right: 0)
        
        let api = VKMessagesApi()
        let response = api.getConversations(count: 50, extended: true)!
        
        self.vkResponse = response.response
        if let response = response.response {
            self.conversations = response.items
        }
        if let error = response.error {
            print(error.errorCode)
            print(error.errorMsg)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationCell
        let item = conversations[indexPath.row]
        
        cell.profile = vkResponse?.findProfileById(id: item.conversation.peer.id)
        cell.group = vkResponse?.findGroupById(id: -item.conversation.peer.id)
        cell.item = item
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDialog", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDialog" {
            // в sender получаем индекс выбранного диалога
            if let destination = segue.destination as? DialogViewController {
                let conInfo = conversations[sender as! Int]
                destination.dialogInfo = conversations[sender as! Int]
                destination.group = vkResponse?.findGroupById(id: -conInfo.conversation.peer.id)
                destination.profile = vkResponse?.findProfileById(id: conInfo.conversation.peer.id)
            }
        }
    }

}
