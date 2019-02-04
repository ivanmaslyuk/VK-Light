//
//  AttachedImageView.swift
//  VK Light
//
//  Created by Иван Маслюк on 06/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit

class AttachedImageViewOld : UIView, KnowsOwnSize {
    
    var roundTop: Bool! {
        didSet {
//            let top: CGFloat = roundTop ?? false ? 16.0 : 7.0
//            let bottom: CGFloat = roundBottom ?? false ? 16.0 : 7.0
//            imageView.roundCorners(topLeft: top, topRight: top, bottomLeft: bottom, bottomRight: bottom)
        }
    }
    
    var roundBottom: Bool! {
        didSet {
//            let top: CGFloat = roundTop ?? false ? 16.0 : 7.0
//            let bottom: CGFloat = roundBottom ?? false ? 16.0 : 7.0
//            imageView.roundCorners(topLeft: top, topRight: top, bottomLeft: bottom, bottomRight: bottom)
        }
    }
    
    private let topPadding: CGFloat = 3.0
    private let bottomPadding: CGFloat = 3.0
    
    public var image: VKPhoto! {
        didSet { setImage() }
    }
    
    private var imageView: CachedImageView = {
        var iv = CachedImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 7
        iv.backgroundColor = .darkGray
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews() called for AttachedImageView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setImage() {
        print("AttachedImageView frame before setting image: \(frame)")
        let img = image.getAppropriatelySized(for: Int(frame.width))
        let newSize = adjustedSize(for: img, maxWidth: frame.width)
        imageView.frame.size = newSize
        
        let constraints = [
            self.heightAnchor.constraint(equalToConstant: newSize.height + topPadding + bottomPadding),
//            self.widthAnchor.constraint(equalToConstant: newSize.width),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
            imageView.heightAnchor.constraint(equalToConstant: newSize.height),
            imageView.widthAnchor.constraint(equalToConstant: newSize.width),
        ]
        
        NSLayoutConstraint.activate(constraints)
        imageView.setSource(url: img.url)
        
        //layoutSubviews()
        print("AttachedImageView frame after setting image: \(frame)")
    }
    
    private func adjustedSize(for size: VKPhoto.Size, maxWidth: CGFloat) -> CGSize {
        let aspectRatio = CGFloat(size.width) / CGFloat(size.height)
        let adjustedWidth = maxWidth
        var adjustedHeight = adjustedWidth / aspectRatio
        
        if adjustedHeight > 400 { adjustedHeight = 400 }
        
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    var heightOfSelf: CGFloat {
        let img = image.getAppropriatelySized(for: 300)
        let size = adjustedSize(for: img, maxWidth: 300)
        return size.height + topPadding + bottomPadding
    }
    
}





class AttachedImageView : UIView, KnowsOwnSize {
    var roundTop: Bool! {
        didSet {
            updateCornerMask()
        }
    }
    
    var roundBottom: Bool! {
        didSet {
            updateCornerMask()
        }
    }
    
    var addPadding: Bool! {
        didSet {
            let verticalPadding: CGFloat = 1.5
            let horizontalPadding: CGFloat = 3
            topConstraint.constant = addPadding ? verticalPadding : 0
            bottomConstraint.constant = addPadding ? -verticalPadding : 0
            leftConstraint.constant = addPadding ? horizontalPadding : 0
            rightConstraint.constant = addPadding ? -horizontalPadding : 0
            widthConstraint.constant = addPadding ? width - horizontalPadding * 2 : width
        }
    }
    
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    private var image: VKPhoto
    private var width: CGFloat
    private var height: CGFloat!
    
    private var imageView: CachedImageView = {
        var iv = CachedImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 7
        iv.backgroundColor = UIColor(red: 188, green: 212, blue: 240)
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    init(image: VKPhoto, width: CGFloat) {
        self.image = image
        self.width = width
        super.init(frame: .zero)
        addSubview(imageView)
        setupConstraints()
        setImage()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstraints() {
        topConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1.5)
        bottomConstraint = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1.5)
        rightConstraint = imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3)
        leftConstraint = imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3)
        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: width - 6)
        
        let minWidth = imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        let maxWidth = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
        minWidth.priority = .required
        maxWidth.priority = .required
        
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leftConstraint,
            rightConstraint,
            widthConstraint,
            minWidth,
            maxWidth
        ])
    }
    
    private func setImage() {
        let size = image.getAppropriatelySized(for: 3000)
        let ratio = getAspectRatio(for: size)
        height = width/ratio
        
        let hc = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/ratio)
        hc.priority = .defaultHigh
        hc.isActive = true
        
        imageView.setSource(url: size.url)
    }
    
    private func getAspectRatio(for size: VKPhoto.Size) -> CGFloat {
        let aspectRatio = CGFloat(size.width) / CGFloat(size.height)
        return aspectRatio
    }
    
    var heightOfSelf: CGFloat {
        let size = image.getAppropriatelySized(for: 3000)
        let ratio = getAspectRatio(for: size)
        var h = widthConstraint.constant / ratio
        if h > 400 {
            h = 400
        }
        if h < 60 {
            h = 60
        }
        return h + topConstraint.constant + (-bottomConstraint.constant)
    }
    
    private func updateCornerMask() {
        // изменяем padding
        topConstraint.constant = (roundTop ?? false) ? ((addPadding ?? true) ? 3 : 0) : ((addPadding ?? true) ? 1.5 : 0)
        bottomConstraint.constant = (roundBottom ?? false) ? ((addPadding ?? true) ? -3 : 0) : ((addPadding ?? true) ? -1.5 : 0)
        // изменяем закругленность углов
        let top: CGFloat = (roundTop ?? false) ? 15 : 7.0
        let bottom: CGFloat = (roundBottom ?? false) ? 15 : 7.0
        var h = height - topConstraint.constant - (-bottomConstraint.constant)
        let w = widthConstraint.constant
        if h > 400 {
            h = 400
        }
        if h < 60 {
            h = 60
        }
        imageView.roundCorners(topLeft: top, topRight: top, bottomLeft: bottom, bottomRight: bottom, maskHeight: h, maskWidth: w)
    }
    
    
}





extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}





extension UIView{
    func roundCorners(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat, maskHeight: CGFloat, maskWidth: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
//        print(bounds)
        let maskPath = UIBezierPath(shouldRoundRect: CGRect(x: 0, y: 0, width: maskWidth, height: maskHeight), topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        layer.masksToBounds = true
        
        
        
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = (self.layer.mask! as! CAShapeLayer).path! // Reuse the Bezier path
//        borderLayer.strokeColor = UIColor.red.cgColor
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.lineWidth = 5
//        borderLayer.frame = self.bounds
//        self.layer.addSublayer(borderLayer)
    }
    
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))
    }
}
