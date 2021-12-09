//
//  Extention.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import Foundation
import UIKit

extension String {

    static func emojiFlag(for countryCode: String) -> String! {
        
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }

        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))

            // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
            // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }

        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {
    
    func moveToAnotherTab(identifier: String, animation: Bool) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: identifier)
        self.navigationController?.pushViewController(vc, animated: animation)
        
    }
    
}


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
