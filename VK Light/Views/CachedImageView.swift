//
//  CachedImageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 08/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class CachedImageView: UIImageView {
    
    var isAvatar: Bool = false {
        didSet {
            layer.cornerRadius = isAvatar ? frame.height / 2 : 0
        }
    }
    
    
    func setSource(url: URL) {
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    
}
