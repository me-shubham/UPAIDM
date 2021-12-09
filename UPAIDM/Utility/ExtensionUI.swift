//
//  ExtentionUI.swift
//  u-paid-m
//
//  Created by Srajansinghal on 03/12/20.
//

import UIKit
import ImageIO

extension UITextField  {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.setDate(Date(), animated: false)
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
         get {
             return self.placeHolderColor
         }
         set {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
         }
     }
    
    @IBInspectable var paddingLeftCustom: CGFloat {
            get {
                return leftView!.frame.size.width
            }
            set {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
                leftView = paddingView
                leftViewMode = .always
            }
        }

        @IBInspectable var paddingRightCustom: CGFloat {
            get {
                return rightView!.frame.size.width
            }
            set {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
                rightView = paddingView
                rightViewMode = .always
            }
        }
    
    func withImage(image: UIImage){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.backgroundColor = .clear
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        mainView.addSubview(view)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 12, width: 20, height: 20)
        view.addSubview(imageView)
        self.rightViewMode = .always
        self.rightView = mainView
    }
    
}



extension UIViewController {
func goToHome(){
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let navigationVC : UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
    UIApplication.shared.windows.first?.rootViewController = navigationVC
}

func goToLogin(){
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let navigationVC : UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationLogin") as! UINavigationController
     UIApplication.shared.windows.first?.rootViewController = navigationVC
}
}



// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}
