//
//  CachedImageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 08/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class CachedImageView: UIImageView, KnowsOwnSize {
    
    /*var isAvatar: Bool = false {
        didSet {
            layer.cornerRadius = isAvatar ? frame.height / 2 : 0
            clipsToBounds = true
        }
    }*/
    
    func setSource(url: URL) {
        DispatchQueue.global().async {
            let imageCache = NSCache<AnyObject, AnyObject>()
            if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.image = cachedImage
            } else {
                URLSession.shared.dataTask(with: url) {(data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            let imageToCache = UIImage(data: data)
                            imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                            self.image = imageToCache
                        }
                    }
                    }.resume()
            }
        }
    }
    
    var heightOfSelf: CGFloat {
        return frame.height
    }
    
}
