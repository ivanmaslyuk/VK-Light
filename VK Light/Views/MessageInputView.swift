//
//  MessageInputView.swift
//  VK Light
//
//  Created by Иван Маслюк on 26/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit


/*class TextField: UITextView {
    
    var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}*/


class MessageInputView : UIView, UITextViewDelegate {
    
    var sendAction: (() -> ())? = nil
    
    var text: String {
        return fieldView.text
    }
    
    private var token: NSKeyValueObservation!
    
    private var fieldView : UITextView = {
        let f = UITextView()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.clipsToBounds = true
        f.layer.cornerRadius = 35 / 2
//        f.placeholder = "Сообщение..."
        f.layer.borderWidth = 0.5
        f.layer.borderColor = UIColor(red: 142, green: 142, blue: 147).cgColor
        f.backgroundColor = UIColor(white: 1, alpha: 0.5)//UIColor(red: 240, green: 240, blue: 240)
        f.textContainerInset = UIEdgeInsets(top: 8, left: 13, bottom: 0, right: 13)
        f.font = UIFont.systemFont(ofSize: 16)
        f.showsVerticalScrollIndicator = false
        f.isScrollEnabled = false
        return f
    }()
    
    private var attachButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "attach"), for: .normal)
        b.widthAnchor.constraint(equalToConstant: 24).isActive = true
        b.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return b
    }()
    
    private var sendButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "mic"), for: .normal)
        b.widthAnchor.constraint(equalToConstant: 14.57).isActive = true
        b.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return b
    }()
    
    private var separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        s.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return s
    }()
    
    private var translucentBackground : UIVisualEffectView = {
        let b = UIVisualEffectView()
        b.effect = UIBlurEffect(style: .regular)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(translucentBackground)
        addSubview(separator)
        addSubview(attachButton)
        addSubview(fieldView)
        addSubview(sendButton)
        setupConstraints()
        setupActions()
        
        /*token = fieldView.observe(\.constraints) { [weak self] (tv, change) in
            self?.fieldView.isScrollEnabled = change.newValue?.height == 100 ? true : false
        }*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            self.heightAnchor.constraint(equalTo: fieldView.heightAnchor, constant: 13),
            
            attachButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            attachButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            fieldView.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: 8),
            fieldView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            fieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            fieldView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            sendButton.leadingAnchor.constraint(equalTo: fieldView.trailingAnchor, constant: 8),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.topAnchor.constraint(equalTo: self.topAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            translucentBackground.topAnchor.constraint(equalTo: self.topAnchor),
            translucentBackground.rightAnchor.constraint(equalTo: self.rightAnchor),
            translucentBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            translucentBackground.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    private func setupActions() {
        // send button
        sendButton.addTarget(self, action: #selector(handleSendButtonPress), for: .touchUpInside)
    }
    
    @objc private func handleSendButtonPress() {
        sendAction?()
    }
    
    func finishEditing() {
        self.fieldView.endEditing(true)
    }
    
    func clear() {
        fieldView.text = ""
    }
}
