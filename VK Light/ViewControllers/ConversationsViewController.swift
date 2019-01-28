//
//  ConversationsViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {

    var dialogs = [VKDialogWrapper]()
    let lpHandler = VKLongPollEventHandler.shared
    let networkStatusView = NetworkStatusView()
    var isSubscribed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 80, bottom: 0, right: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        if dialogs.isEmpty {
            loadMoreDialogs()
        }
        
        if !isSubscribed {
            subscribe()
            isSubscribed = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationCell
        let wrapper = dialogs[indexPath.row]
        
        cell.dialogWrapper = wrapper
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDialog", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDialog" {
            self.tabBarController?.tabBar.isHidden = true
            // в sender получаем индекс выбранного диалога
            if let destination = segue.destination as? DialogViewController {
                let conInfo = dialogs[sender as! Int]
                destination.dialogWrapper = conInfo
            }
        }
    }
    
    func loadMoreDialogs() {
        MessageHelper().loadDialogs(count: 50, offset: 0, completion: { (response, error) in
            if let response = response {
                self.dialogs = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func subscribe() {
        VKLongPoller.shared.addStatusSubscriber(self)
        lpHandler.addMenuCounterSubscriber(subscriber: self)
        lpHandler.addNewMessageSubscriber(subscriber: self)
        lpHandler.addMessagesReadSubscriber(subscriber: self)
    }
    
    func unsubscribe() {
        VKLongPoller.shared.removeStatusSubscriber(self)
        lpHandler.removeMenuCounterSubscriber(subscriber: self)
        lpHandler.removeNewMessageSubscriber(subscriber: self)
        lpHandler.removeMessagesReadSubscriber(subscriber: self)
    }

}

extension ConversationsViewController : MenuCounterSubscriber {
    func counterChanged(newCount: Int) {
        let item = self.tabBarController!.tabBar.items![1]
        item.badgeValue = newCount > 0 ? String(newCount) : nil
    }
}

extension ConversationsViewController : NewMessagesSubscriber {
    func newMessageReceived(message: VKMessageWrapper) {
        // пытаемся найти индекс диалога в таблице, если он там есть
        var previousIndex: Int? = nil
        for i in 0...dialogs.count-1 {
            if dialogs[i].dialog.peer.id == message.message.peerId! {
                previousIndex = i
            }
        }
        
        // не пытаемся передвинуть если диалог уже на первом месте
        if previousIndex == 0 {
            if !message.message.isOut {
                dialogs[0].unreadCount += 1
            }
            dialogs[0].lastMessage = message
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            return
        }
        
        if previousIndex != nil {
            // меняем место уже загруженного диалога, меняя в нем lastMessage
            var dialog = dialogs.remove(at: previousIndex!)
            dialog.lastMessage = message
            if !message.message.isOut {
                dialog.unreadCount += 1
            }
            tableView.deleteRows(at: [IndexPath(row: previousIndex!, section: 0)], with: .top)
            
            dialogs.insert(dialog, at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        } else {
            // загружаем информацию о беседе и ставим ее на первое место
        }
    }
    
    var peerWatchedForMessages: Int {
        return 0
    }
    
    var watchesAllMessages: Bool {
        return true
    }
    
    
}

extension ConversationsViewController : MessagesReadSubscriber {
    func messagesRead(peerId: Int, localId: Int, sent: Bool) {
        for i in 0...dialogs.count-1 {
            if dialogs[i].dialog.peer.id == peerId {
                if sent {
                    dialogs[i].outRead = localId
                } else {
                    dialogs[i].unreadCount = 0
                }
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
            }
        }
    }
    
    func watchesMessagesReadForPeer() -> Int {
        return 0
    }
    
    func watchesMessagesReadForAllPeers() -> Bool {
        return true
    }
    
}

extension ConversationsViewController : LPStatusSubscriber {
    func lpStatusChanged(_ status: LPStatus) {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.frame.size = CGSize(width: 5.0, height: 5.0)
        self.navigationItem.titleView = status == .ok ? nil : networkStatusView
        networkStatusView.status = .networkError
//        self.title = status == .ok ? "Диалоги" : "LongPoller error"
    }
}
