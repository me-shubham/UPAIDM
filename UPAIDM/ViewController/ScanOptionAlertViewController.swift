//
//  ScanOptionAlertViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 10/12/20.
//

import UIKit

class ScanOptionAlertViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    var callback : ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "app_background_color")
//        self.isModalInPresentation = true
        backView.layer.cornerRadius = 16
        backView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickNFCTag(_ sender: Any) {
        self.callback?(2)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickQRScanner(_ sender: Any) {
        self.callback?(3)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNearByUser(_ sender: Any) {
        self.callback?(1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickBroadcastNearByUser(_ sender: Any) {
        self.callback?(4)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
