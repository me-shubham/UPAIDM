//
//  NeumorphismButton.swift
//  NeumorphismKit
//
//  Created by okudera on 2020/08/18.
//  Copyright © 2020 yuoku. All rights reserved.
//

import UIKit

@IBDesignable
public class NeumorphismButton: UIButton {
    
    //    let basinView = NeumorphismView()
        
        private var neumorphismType: NeumorphismType = .convex {
            didSet {
                self.setupNeumorphism()
            }
        }
        private var oldNeumorphismType: NeumorphismType = .convex

        private var _baseColor: UIColor = NeumorphismAppearance.shared.baseColor
        private var _cornerRadius: CGFloat = 16.0

        @IBInspectable
        public var baseColor: UIColor = NeumorphismAppearance.shared.baseColor {
            willSet {
                _baseColor = newValue
                self.setupNeumorphism()
            }
        }

        @IBInspectable
        public var cornerRadius: CGFloat = 16.0 {
            willSet {
                _cornerRadius = newValue
                self.setupNeumorphism()
            }
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupNeumorphism()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupNeumorphism()
        }
        
        @IBInspectable
        public var isConvex: Int = 0 {
            willSet {
                switch newValue {
                case 0:
                    self.neumorphismType = .convex
                case 1:
                    self.neumorphismType = .concave
                case 2:
                    self.neumorphismType = .flat
                case 3:
                    self.neumorphismType = .basin
                default:
                    self.neumorphismType = .convex
                }
                self.setupNeumorphism()
            }
        }

        public override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            setupNeumorphism()
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            
            self.setupNeumorphism()
        }
        
        

        public override var isHighlighted: Bool {
            didSet {
                if isHighlighted {
                    self.oldNeumorphismType = self.neumorphismType
                    self.neumorphismType = .concave
                }
                else {
                    self.neumorphismType = self.oldNeumorphismType
                }
            }
        }

        private func setupNeumorphism() {
            self.nsk.removeLayers()
            
            let baseColorRGB = _baseColor.convertToRGB()
            switch neumorphismType {
            case .convex:
                self.nsk.convexNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
            case .concave:
                self.nsk.concaveNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
            case .flat:
                self.nsk.removeLayers()
            case .basin:
    //            basinNeumorphism(cornerRadius: _cornerRadius)
                self.nsk.concaveNeumorphism(r: baseColorRGB.red, g: baseColorRGB.green, b: baseColorRGB.blue, cornerRadius: _cornerRadius)
    //            self.superview?.bringSubviewToFront(self)
            }
        }
        
    //    func basinNeumorphism(cornerRadius: CGFloat) {
    //
    //        basinView.removeFromSuperview()
    //        self.isHidden = true
    //        self.superview?.addSubview(basinView)
    //        basinView.nsk.removeLayers()
    //        basinView.baseColor = baseColor
    //        basinView.isConvex = true
    //        basinView.cornerRadius = cornerRadius
    ////        basinView.layer.cornerRadius = cornerRadius
    //        basinView.translatesAutoresizingMaskIntoConstraints = false
    //        let horizontalConstraint = NSLayoutConstraint(item: basinView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
    //        let verticalConstraint = NSLayoutConstraint(item: basinView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
    //        let xConstraint = NSLayoutConstraint(item: basinView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -2)
    //        let yConstraint = NSLayoutConstraint(item: basinView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: -2)
    //        self.superview?.addConstraints([horizontalConstraint, verticalConstraint, xConstraint, yConstraint])
    //        self.superview?.bringSubviewToFront(self)
    //
    //
    //
    //
    //    }
    //
    }
