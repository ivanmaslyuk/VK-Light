//
//  DialogViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    var dialogInfo : VKGetConversationsResponse.Item?
    var profile :  VKProfileModel?
    var group : VKGroupModel?
    let messageHelper = MessageHelper()
    var messages : [VKMessageWrapper] = []
    let lpEventHandler = VKLongPollEventHandler.shared
    var isCurrentlyLoadingMessages = false {
        didSet(new) {
            if new {
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        //addContentInsetsToTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        
        tableView.transform = CGAffineTransform.identity.rotated(by: .pi) // переворачиваем TableView
        pushScrollBarToRightSide()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // при перевороте экрана
        pushScrollBarToRightSide(size: size)
        //addContentInsetsToTableView()
    }
    
    private func pushScrollBarToRightSide(size: CGSize? = nil) {
        let frameWidth: CGFloat = size?.width ?? tableView.frame.size.width
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: frameWidth - 8.0) // передвигаем скролл-индикатор вправо
        
    }
    
    private func addContentInsetsToTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height, right: 0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == (messages.count - 1) && !isCurrentlyLoadingMessages{
            loadMessages()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        lpEventHandler.addNewMessageSubscriber(subscriber: self)
        lpEventHandler.addTypingSubscriber(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        lpEventHandler.removeNewMessageSubscriber(subscriber: self)
        lpEventHandler.removeTypingSubscriber(subscriber: self)
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
    
    func handleNewMessage(message: VKMessageWrapper) {
        self.messages.insert(message, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    func loadMessages() {
        guard let dialogInfo = dialogInfo else {
            return
        }
        isCurrentlyLoadingMessages = true
        messageHelper.loadMessages(peerId: dialogInfo.conversation.peer.id, startId: dialogInfo.lastMessage.id!, offset: messages.count) {
            (newMessages, error) in
            self.isCurrentlyLoadingMessages = false
            if let newMessages = newMessages {
                self.messages.append(contentsOf: newMessages)
                self.tableView.reloadData()
            }
            if let error = error {
                NotificationDebugger.print(text: String(error))
            }
        }
    }
    
    
    

}

extension DialogViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        
        cell.messageWrapper = messages[indexPath.row]
        cell.transform = CGAffineTransform.identity.rotated(by: .pi) // поворот
        //cell.layoutSubviews()
        
        return cell
    }
    
}

extension DialogViewController : NewMessagesSubscriber {
    func newMessageReceived(message: VKMessageWrapper) {
        handleNewMessage(message: message)
    }
    
    var peerWatchedForMessages: Int {
        get {
            return dialogInfo!.conversation.peer.id
        }
    }
    
    var watchesAllMessages: Bool {
        get { return false }
    }
}

extension DialogViewController : UserTypingSubscriber {

    func userStartedTyping(userId: Int) {
        self.title = "печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.setTitle() })
    }
    
    func watchingTypingFromUser() -> Int {
        return dialogInfo!.conversation.peer.id
    }
    
    func watchesTypingFromAllUsers() -> Bool {
        return false
    }
    
    
}

extension DialogViewController : TypingInChatSubscriber {
    func userStartedTypingInChat(userId: Int, chatId: Int) {
        self.title = "\(userId) печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.setTitle() })
    }
    
    func watchingTypingInChat() -> Int {
        return dialogInfo!.conversation.peer.localId
    }
    
    func watchesTypingFromAllChats() -> Bool {
        return false
    }
    
    
}
