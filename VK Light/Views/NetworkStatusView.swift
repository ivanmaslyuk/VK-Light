//
//  NetworkStatusView.swift
//  VK Light
//
//  Created by Иван Маслюк on 24/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class NetworkStatusView : UIView {
    
    enum Status {
        case loading
        case networkError
    }
    
    var status: Status = .loading {
        didSet {
            switch status {
            case .loading:
                statusLabel.textColor = .black
                statusLabel.text = "Загрузка..."
            case .networkError:
                statusLabel.textColor = .red
                statusLabel.text = "Ошибка сети"
                busyIndicator.startAnimating()
            }
        }
    }
    
    private var statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 17)
        return l
    }()
    
    private var busyIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.color = .gray
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(busyIndicator)
        addSubview(statusLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: busyIndicator.heightAnchor),
            
            busyIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            busyIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabel.leadingAnchor.constraint(equalTo: busyIndicator.trailingAnchor, constant: 5),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
