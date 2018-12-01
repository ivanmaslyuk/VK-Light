//
//  MessageContentView.swift
//  VK Light
//
//  Created by Иван Маслюк on 28/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class MessageContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var wrappedMessage: VKMessageWrapper? {
        didSet(newValue) {
            textView.text = newValue?.message.text
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        condigureSelf()
        addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func condigureSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        self.widthAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
        self.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
    }
    
    private func setupTextView() {
        
    }

}
