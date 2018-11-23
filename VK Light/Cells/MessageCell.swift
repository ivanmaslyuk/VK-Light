//
//  MessageCell.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    // сделать модель
    /*var isFromMe : Bool = true
    var messageModel : VKMessageModel?*/
    var message : Message?
    var leftConstraint : NSLayoutConstraint?
    var rightConstraint : NSLayoutConstraint?
    
    let messageText : UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        label.isScrollEnabled = false
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.isSelectable = false
        
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let messageCard : UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 15
        card.layer.masksToBounds = true
        card.clipsToBounds = false
        return card
    }()
    
    private let sticker : UIImageView = {
        return UIImageView()
    }()
    
    private let stackView : UIStackView = {
        let stView = UIStackView()
        
        return stView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = false
        
        addSubview(messageCard)
        addSubview(messageText)
        
        
        
        
        messageCard.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        messageCard.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
        //messageCard.widthAnchor.constraint(equalToConstant: 250).isActive = true
        messageCard.widthAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
        messageCard.widthAnchor.constraint(equalTo: messageText.widthAnchor, constant: 6).isActive = true
        messageCard.heightAnchor.constraint(equalTo: messageText.heightAnchor)
        
        messageText.topAnchor.constraint(equalTo: messageCard.topAnchor).isActive = true
        messageText.bottomAnchor.constraint(equalTo: messageCard.bottomAnchor).isActive = true
        messageText.rightAnchor.constraint(equalTo: messageCard.rightAnchor, constant: 3).isActive = true
        messageText.leftAnchor.constraint(equalTo: messageCard.leftAnchor, constant: 3).isActive = true
        
        self.rightConstraint = messageCard.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        self.leftConstraint = messageCard.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        self.heightAnchor.constraint(equalTo: messageCard.heightAnchor, constant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let message = message else {return}
        
        if message.isFromMe {
            clipToRight()
            messageCard.backgroundColor = UIColor(red: 10.0/255.0, green: 115.0/255.0, blue: 255.0/255.0, alpha: 1)
            messageText.textColor = UIColor.white
        } else {
            clipToLeft()
            messageCard.backgroundColor = UIColor(red: 229.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1)
            messageText.textColor = UIColor.black
        }
        
        self.messageText.text = message.text
    }
    
    func clipToRight() {
        rightConstraint?.isActive = true
        leftConstraint?.isActive = false
    }
    
    func clipToLeft() {
        leftConstraint?.isActive = true
        rightConstraint?.isActive = false
    }

}
