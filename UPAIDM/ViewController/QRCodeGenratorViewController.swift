//
//  QRCodeGenratorViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 03/12/20.
//

import UIKit

class QRCodeGenratorViewController: UIViewController {
    
    @IBOutlet weak var imageViewQRCode: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    var invoice : Invoice!
    
    
    override func viewDidLoad() {
        
        buttonContinue.layer.cornerRadius = 15
        buttonContinue.clipsToBounds = true
        
        super.viewDidLoad()
        
       // print("\(String(describing: transaction.transactionId))")
        
        imageViewQRCode.image = generateQRCode(from: invoice._id ?? "")
        // Do any additional setup after loading the view.
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickExit(_ sender: NeumorphismButton) {
        userDefaults.set(false, forKey: UDKeys.isLogin)
        userDefaults.synchronize()
        self.navigationController?.popToRootViewController(animated: true)

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
