//
//  DialogHeaderView.swift
//  VK Light
//
//  Created by Иван Маслюк on 25/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class DialogHeaderView: UIView {
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    var status: String! {
        didSet {
            statusLabel.text = status
        }
    }
    
    private var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .black
        return l
    }()
    
    private var statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .gray
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(statusLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
