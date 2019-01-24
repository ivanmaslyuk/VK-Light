//
//  DialogViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    //var dialogInfo : VKGetConversationsResponse.Item?
    var dialogWrapper: VKDialogWrapper!
    //var profile :  VKProfile?
    //var group : VKGroup?
    let messageHelper = MessageHelper()
    var messages : [VKMessageWrapper] = []
    var rowHeights = [CGFloat]()
    let lpEventHandler = VKLongPollEventHandler.shared
    var isCurrentlyLoadingMessages = true {
        didSet {
            if isCurrentlyLoadingMessages {
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
        
        title = dialogWrapper.dialogTitle
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        
        tableView.transform = CGAffineTransform.identity.rotated(by: .pi) // переворачиваем TableView
        pushScrollBarToRightSide()
        
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
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        lpEventHandler.addNewMessageSubscriber(subscriber: self)
        lpEventHandler.addTypingSubscriber(subscriber: self)
        lpEventHandler.addMessageFlagsSubscriber(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        lpEventHandler.removeNewMessageSubscriber(subscriber: self)
        lpEventHandler.removeTypingSubscriber(subscriber: self)
        lpEventHandler.removeMessageFlagsSubscriber(subscriber: self)
    }
    
    
    
    
    func loadMessages() {
        let countBeforeLoading = messages.count
        isCurrentlyLoadingMessages = true
        messageHelper.loadMessages(peerId: dialogWrapper.dialog.peer.id, startId: dialogWrapper.lastMessage.message.id!, offset: messages.count, count: 20) {
            (newMessages, error) in
            if let newMessages = newMessages {
                guard newMessages.count > 0 else {
                    self.isCurrentlyLoadingMessages = false
                    return
                }
                self.messages.append(contentsOf: newMessages)
                DispatchQueue.global().async {
                    self.calculateRowHights(startingAt: countBeforeLoading, count: newMessages.count)
                    DispatchQueue.main.async {
                        self.isCurrentlyLoadingMessages = false
                        self.tableView.reloadData()
                    }
                }
            }
            if let error = error {
                self.isCurrentlyLoadingMessages = false
                NotificationDebugger.print(text: error.rawValue)
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
        cell.transform = CGAffineTransform.identity.rotated(by: .pi)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let c = cell as! MessageCell
        c.messageWrapper = messages[indexPath.row]
        if indexPath.row + 1 == (messages.count - 1) && !isCurrentlyLoadingMessages{
            loadMessages()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.row]
    }
    
    func calculateRowHights(startingAt: Int, count: Int) {
        var current = startingAt
        for _ in 0...count-1 {
            calculateRowHeight(for: current)
            current += 1
        }
    }
    
    private func calculateRowHeight(for messageIndex: Int) {
        let bubble = MessageView()
        bubble.messageWrapper = messages[messageIndex]
        var height = bubble.heightOfSelf + MessageCell.absolutePadding
        if height < MessageCell.minHeight { height = MessageCell.minHeight }
        rowHeights.insert(height, at: messageIndex)
    }
    
    private func recalculateRowHeight(for messageIndex: Int) {
        let bubble = MessageView()
        bubble.messageWrapper = messages[messageIndex]
        var height = bubble.heightOfSelf + MessageCell.absolutePadding
        if height < MessageCell.minHeight { height = MessageCell.minHeight }
        rowHeights[messageIndex] = height
    }
    
    
}

extension DialogViewController : NewMessagesSubscriber {
    func newMessageReceived(message: VKMessageWrapper) {
        self.messages.insert(message, at: 0)
        DispatchQueue.global().async {
            self.calculateRowHeight(for: 0)
            DispatchQueue.main.async {
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
        }
    }
    
    var peerWatchedForMessages: Int {
        get {
            return dialogWrapper.dialog.peer.id
        }
    }
    
    var watchesAllMessages: Bool {
        get { return false }
    }
}

extension DialogViewController : UserTypingSubscriber {

    func userStartedTyping(userId: Int) {
        self.title = "печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.title = self.dialogWrapper.dialogTitle })
    }
    
    func watchingTypingFromUser() -> Int {
        return dialogWrapper.dialog.peer.id
    }
    
    func watchesTypingFromAllUsers() -> Bool {
        return false
    }
    
    
}

extension DialogViewController : TypingInChatSubscriber {
    func userStartedTypingInChat(userId: Int, chatId: Int) {
        self.title = "\(userId) печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.title = self.dialogWrapper.dialogTitle })
    }
    
    func watchingTypingInChat() -> Int {
        return dialogWrapper.dialog.peer.localId
    }
    
    func watchesTypingFromAllChats() -> Bool {
        return false
    }
    
    
}

extension DialogViewController : MessageFlagsSubscriber {
    func messageFlagsChanged(peerId: Int, messages: [MessageIdAndFlags]) {
        DispatchQueue.global().async {
            var deleted = [Int]()
            for message in messages {
                if message.flags.isDeleted || message.flags.isDeletedForEveryone {
                    for i in 0...self.messages.count-1 {
                        if self.messages[i].message.id == message.messageId {
                            deleted.append(i)
                        }
                    }
                }
            }
            
            var deletedPaths = [IndexPath]()
            for i in deleted {
                deletedPaths.append(IndexPath(row: i, section: 0))
                self.messages.remove(at: i)
                self.rowHeights.remove(at: i)
            }
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: deletedPaths, with: .fade)
                self.tableView.reloadData()
            }
        }
    }
    
    func watchesMessageFlagsForPeer() -> Int {
        return self.dialogWrapper.dialog.peer.id
    }
    
    func watchesMessageFlagsForAllPeers() -> Bool {
        return false
    }
    
    
}
