//
//  ObservableDataContainer.swift
//  VK Light
//
//  Created by Иван Маслюк on 25/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class ObservableDataContainer<T : Sequence> {
    var data: T
    
    init(data: T) {
        self.data = data
    }
    
    
}
