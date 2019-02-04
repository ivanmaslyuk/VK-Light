//
//  AudioWaveformView.swift
//  VK Light
//
//  Created by Иван Маслюк on 28/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class AudioWaveformView : UIView {
    
    private var waveform = [Int]()
    private var strokes = [UIView]()
    
    init(waveform: [Int]) {
        super.init(frame: .zero)
        self.waveform = average(from: waveform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present() {
        for _ in 0...80 {
            let stroke = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
            strokes.append(stroke)
        }
    }
    
    private func average(from wf: [Int]) -> [Int] {
        // one value ranges from 0 to 31
        let sourceCount = wf.count
        let ratio = Double(sourceCount) / 80.0
        return [Int]()
    }
}
