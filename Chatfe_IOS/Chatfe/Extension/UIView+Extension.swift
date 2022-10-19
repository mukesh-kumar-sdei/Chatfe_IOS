//
//  UIView+Extension.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

@IBDesignable
public class GradientView: UIView {
    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    @IBInspectable public var startColor: UIColor = .white {
        didSet { updateColors() }
    }
    @IBInspectable public var endColor: UIColor = .red {
        didSet { updateColors() }
    }
    
    // Expose start point and end point to IB...
    
    @IBInspectable public var startPoint: CGPoint {
        get {
            gradientLayer.startPoint
        }
        set {
            gradientLayer.startPoint = newValue
        }
    }
    
    @IBInspectable public var endPoint: CGPoint {
        get {
            gradientLayer.endPoint
        }
        set {
            gradientLayer.endPoint = newValue
        }
    }
    
    // init methods
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
}

private extension GradientView {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
