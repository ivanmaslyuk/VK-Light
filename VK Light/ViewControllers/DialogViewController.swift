//
//  DialogViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    var dialogWrapper: VKDialogWrapper!
    let messageHelper = MessageHelper()
    var messages : [VKMessageWrapper] = []
    var rowHeights = [CGFloat]()
    let lpEventHandler = VKLongPollEventHandler.shared
    let titleView = DialogHeaderView()
    let messageInputView = MessageInputView()
    var isSubscribed: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var inputViewOffset: NSLayoutConstraint!
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = self.titleView
        titleView.title = dialogWrapper.dialogTitle
        self.resetStatus()
        
        setAvatar()
        setupTableView()
        setupInputView()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if isMovingFromParent { return }
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            inputViewOffset.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.addContentInsetsToTableView()
                self.view.layoutIfNeeded()
                if self.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)) ?? false {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
                }
            }, completion: nil)
        }
    }
    
    @objc func handleTableViewTapped(recognizer: UITapGestureRecognizer) {
        self.messageInputView.finishEditing()
    }
    
    private func setupInputView() {
        view.addSubview(messageInputView)
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.inputViewOffset = messageInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        inputViewOffset.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTapped(recognizer:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        messageInputView.sendAction = self.sendMessage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isSubscribed {
            subscribe()
            isSubscribed = true
        }
        addContentInsetsToTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isMovingFromParent {
            unsubscribe()
            isSubscribed = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        pushScrollBarToRightSide(size: size)
        coordinator.animate(alongsideTransition: nil, completion: { (_) in
            self.addContentInsetsToTableView()
        })
    }
    
    private func pushScrollBarToRightSide(size: CGSize? = nil) {
        let frameWidth: CGFloat = size?.width ?? tableView.frame.size.width
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: frameWidth - 8.0) // передвигаем скролл-индикатор вправо
        
    }
    
    private func addContentInsetsToTableView() {
        let topInset = -inputViewOffset.constant + 48 //messageInputView.frame.height
        let bottomInset = (navigationController?.navigationBar.frame.height) ?? 0 + UIApplication.shared.statusBarFrame.size.height
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        let scrollInsets = tableView.scrollIndicatorInsets
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: scrollInsets.right)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        setAvatar()
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
    
    
    func resetStatus() {
        if let p = dialogWrapper.profile {
            titleView.status = p.online == .yes ? "в сети" : "не в сети"
        }
        if let _ = dialogWrapper.group {
            titleView.status = "сообщество"
        }
        if dialogWrapper.isChat {
            titleView.status = "\(dialogWrapper.dialog.chatSettings!.membersCount!) участников"
        }
    }
    
    func setAvatar() {
        let iv = CachedImageView()
        iv.layer.cornerRadius = 18
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 36).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 36).isActive = true
        if let url = dialogWrapper.photo100 {
            iv.setSource(url: url)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: iv)
    }
    
    func subscribe() {
        lpEventHandler.addNewMessageSubscriber(subscriber: self)
        lpEventHandler.addTypingSubscriber(subscriber: self)
        lpEventHandler.addTypingInChatSubscriber(subscriber: self)
        lpEventHandler.addMessageFlagsSubscriber(subscriber: self)
    }

    func unsubscribe() {
        lpEventHandler.removeNewMessageSubscriber(subscriber: self)
        lpEventHandler.removeTypingSubscriber(subscriber: self)
        lpEventHandler.removeMessageFlagsSubscriber(subscriber: self)
        lpEventHandler.removeTypingInChatSubscriber(subscriber: self)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        
        tableView.transform = CGAffineTransform.identity.rotated(by: .pi) // переворачиваем TableView
        pushScrollBarToRightSide()
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    func sendMessage() {
        let peerId = dialogWrapper.dialog.peer.id
        let randomId = Int32.random(in: 0...Int32.max)
        let message = messageInputView.text
        VKMessagesApi().send(peerId: peerId, randomId: randomId, message: message, latitude: nil, longitude: nil, attachments: nil, replyTo: nil, forwardedMessages: nil, stickerId: nil, parseLinks: true) { (response, error) in
            
        }
        messageInputView.clear()
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
        self.resetStatus()
        self.messages.insert(message, at: 0)
        DispatchQueue.global().async {
            self.calculateRowHeight(for: 0)
            DispatchQueue.main.async {
                if (self.isViewLoaded && self.view.window != nil && UIApplication.shared.applicationState == .active) { // if view is visible
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                }
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
        self.titleView.status = "печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.resetStatus() })
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
        self.titleView.status = "\(userId) печатает..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.resetStatus() })
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
