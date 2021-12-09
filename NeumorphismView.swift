//
//  File.swift
//  NeumorphismKit
//
//  Created by Srajansinghal on 01/12/20.
//

import UIKit

@IBDesignable
public class NeumorphismView: UIView {
    
    private var _baseColor: UIColor = NeumorphismAppearance.shared.baseColor
    private var _cornerRadius: CGFloat = 8.0
    private var _neumorphismType: NeumorphismType = .convex

    @IBInspectable
    public var baseColor: UIColor = NeumorphismAppearance.shared.baseColor {
        willSet {
            _baseColor = newValue
            self.setupNeumorphism()
        }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 8.0 {
        willSet {
            _cornerRadius = newValue
            self.setupNeumorphism()
        }
    }

    @IBInspectable
    public var isConvex: Bool = true {
        willSet {
            _neumorphismType = newValue ? .convex : .concave
            self.setupNeumorphism()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNeumorphism()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNeumorphism()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupNeumorphism()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
       
        self.setupNeumorphism()
    }


    private func setupNeumorphism() {
        self.nsk.removeLayers()
        self.layer.cornerRadius = _cornerRadius
        let baseColorRGB = _baseColor.convertToRGB()
        switch _neumorphismType {
        case .convex:
            self.nsk.convexNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
        case .concave:
            self.nsk.concaveNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
        case .flat:
            self.nsk.removeLayers()
        case .basin:
            self.nsk.concaveNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
            

        }
    }

}

