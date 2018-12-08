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
    var message : VKMessageWrapper! {
        didSet{ setMessage() }
    }
    
    var leftConstr : NSLayoutConstraint!
    var rightConstr : NSLayoutConstraint!
    let bubblePadding: CGFloat = 8
    let bubbleMargin: CGFloat = 5
    
    let messageText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let messageCard : UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        card.clipsToBounds = false
        return card
    }()
    
    private let avatar : CachedImageView = {
        var imageView = CachedImageView()
        imageView.heightAnchor.constraint(equalToConstant: 15)
        imageView.heightAnchor.constraint(equalToConstant: 15)
        imageView.isAvatar = true
        return imageView
    }()
    
    private let stackView : UIStackView = {
        let stView = UIStackView()
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.backgroundColor = .clear
        return stView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = false
        
        //addSubview(messageCard)
        //addSubview(messageText)
        
        //messageCard.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        //////messageCard.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
        ///////messageCard.widthAnchor.constraint(equalToConstant: 250).isActive = true
        //messageCard.widthAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true//
        //messageCard.widthAnchor.constraint(equalTo: messageText.widthAnchor, constant: 6).isActive = true
        //messageCard.heightAnchor.constraint(equalTo: messageText.heightAnchor)
        
        //messageText.topAnchor.constraint(equalTo: messageCard.topAnchor).isActive = true
        //messageText.bottomAnchor.constraint(equalTo: messageCard.bottomAnchor).isActive = true
        ///////messageText.rightAnchor.constraint(equalTo: messageCard.rightAnchor, constant: 3).isActive = true
        ///////messageText.leftAnchor.constraint(equalTo: messageCard.leftAnchor, constant: 3).isActive = true
        
        //self.rightConstraint = messageCard.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        //self.leftConstraint = messageCard.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        //self.heightAnchor.constraint(equalTo: messageCard.heightAnchor, constant: 4).isActive = true
        stackView.addArrangedSubview(messageText)
        addSubview(avatar)
        addSubview(messageCard)
        addSubview(stackView)
        
        let constraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: bubbleMargin + bubblePadding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(bubbleMargin + bubblePadding)),
            stackView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10), // ну хз
            
            messageCard.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -bubblePadding),
            messageCard.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: bubblePadding),
            messageCard.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -bubblePadding),
            messageCard.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: bubblePadding),
            
            messageText.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            messageText.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20)
        ]
        
        rightConstr = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(bubbleMargin + bubblePadding))
        leftConstr = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bubbleMargin + bubblePadding)
        
        leftConstr.isActive = true
        
        for c in constraints {
            c.isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        /*guard let message = message else {return}
        
        if message.message.out == 1 {
            //clipToRight()
            messageCard.backgroundColor = UIColor(red: 10.0/255.0, green: 115.0/255.0, blue: 255.0/255.0, alpha: 1)
            messageText.textColor = UIColor.white
        } else {
            //clipToLeft()
            messageCard.backgroundColor = UIColor(red: 229.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1)
            messageText.textColor = UIColor.black
        }
        
        self.messageText.text = message.message.text*/
    }*/
    
    /*func clipToRight() {
        rightConstraint?.isActive = true
        leftConstraint?.isActive = false
    }
    
    func clipToLeft() {
        leftConstraint?.isActive = true
        rightConstraint?.isActive = false
    }*/
    
    
    func setMessage() {
        messageText.text = message.message.text
        messageText.textColor = .white
        messageCard.backgroundColor = message.message.out == 1 ? .darkGray : .lightGray
        leftConstr.isActive = message.message.out == 0
        rightConstr.isActive = message.message.out == 1
        avatar.isHidden = message.message.out == 0
        
        //setNeedsLayout()
    }
    

}
