//
//  FilterViewController.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 15/10/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var buttonIncomingTransaction: UIButton!
    @IBOutlet weak var buttonAllTransaction: UIButton!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var buttonFiat: UIButton!
    @IBOutlet weak var buttonCrypto: UIButton!
    @IBOutlet weak var buttonOutgoingTransaction: UIButton!
    var isFiat = false, isCRypto = false, isAll = false, isIncoming = false, isOutgoing = false
    var callback : ((_ isFiat: Bool, _ isCRypto: Bool, _ isAll: Bool, _ isIncoming: Bool, _ isOutgoing: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 8
        viewBack.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setShadow(button: buttonIncomingTransaction)
        setShadow(button: buttonAllTransaction)
        setShadow(button: buttonApply)
        setShadow(button: buttonFiat)
        setShadow(button: buttonCrypto)
        setShadow(button: buttonOutgoingTransaction)
    }
    
    @IBAction func onClickCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickApply(_ sender: UIButton) {
        
        callback?(isFiat, isCRypto, isAll, isIncoming, isOutgoing)
    }
    
    @IBAction func onClickFiat(_ sender: UIButton) {
        
        buttonAllTransaction.backgroundColor = UIColor(named: "app_blue_color")
        buttonAllTransaction.tag = 0
        isAll = false
        
        if(sender.tag == 0) {
            
            sender.backgroundColor = UIColor(named: "app_green_color")
            sender.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            sender.tag = 1
            isFiat = true
            
        }else {
            
            sender.backgroundColor = UIColor(named: "app_background_color")
            sender.setTitleColor(UIColor(named: "app_title_color"), for: .normal)
            sender.tag = 0
            isFiat = false
            
            if isCRypto == true {
               
                buttonIncomingTransaction.backgroundColor = UIColor(named: "app_blue_color")
                buttonIncomingTransaction.tag = 0
                isIncoming = false
                
                buttonOutgoingTransaction.setTitleColor(UIColor(named: "app_title_color"), for: .normal)
                buttonOutgoingTransaction.backgroundColor = UIColor(named: "app_background_color")
                buttonOutgoingTransaction.tag = 0
                isOutgoing = false
                
            }
            
        }
        
    }
    
    @IBAction func onClickCrypto(_ sender: UIButton) {
        
        buttonAllTransaction.backgroundColor = UIColor(named: "app_blue_color")
        buttonAllTransaction.tag = 0
        isAll = false
        
        if(sender.tag == 0) {
            sender.backgroundColor = UIColor(named: "app_green_color")
            sender.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            sender.tag = 1
            isCRypto = true
        }else {
            sender.backgroundColor = UIColor(named: "app_background_color")
            sender.setTitleColor(UIColor(named: "app_title_color"), for: .normal)
            sender.tag = 0
            isCRypto = false
        }
    }
    
    @IBAction func onClickIncomingTransaction(_ sender: UIButton) {
        
        if isCRypto == true && isFiat == false {
            
            return
            
        }
        
        buttonAllTransaction.backgroundColor = UIColor(named: "app_blue_color")
        buttonAllTransaction.tag = 0
        isAll = false
        
        if(sender.tag == 0) {
            sender.backgroundColor = UIColor(named: "app_green_color")
            sender.tag = 1
            isIncoming = true
        }else {
            sender.backgroundColor = UIColor(named: "app_blue_color")
            sender.tag = 0
            isIncoming = false
        }
    }
    
    @IBAction func onClickOutgoingTransaction(_ sender: UIButton) {
        
        if isCRypto == true && isFiat == false {
            
            return
            
        }
        
        buttonAllTransaction.backgroundColor = UIColor(named: "app_blue_color")
        buttonAllTransaction.tag = 0
        isAll = false
        
        if(sender.tag == 0) {
            sender.backgroundColor = UIColor(named: "app_green_color")
            sender.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            sender.tag = 1
            isOutgoing = true
        }else {
            sender.backgroundColor = UIColor(named: "app_background_color")
            sender.setTitleColor(UIColor(named: "app_title_color"), for: .normal)
            sender.tag = 0
            isOutgoing = false
        }
        
    }
    
    @IBAction func onClickAllTransaction(_ sender: UIButton) {
        if(sender.tag == 0) {
            sender.backgroundColor = UIColor(named: "app_green_color")
            sender.tag = 1
            
            isAll = true
            isOutgoing = true
            isIncoming = true
            isCRypto = true
            isFiat = true
            
            buttonFiat.tag = 1
            buttonFiat.backgroundColor = UIColor(named: "app_green_color")
            buttonFiat.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            
            buttonCrypto.tag = 1
            buttonCrypto.backgroundColor = UIColor(named: "app_green_color")
            buttonCrypto.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            
            buttonIncomingTransaction.tag = 1
            buttonIncomingTransaction.backgroundColor = UIColor(named: "app_green_color")
            buttonIncomingTransaction.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            
            buttonOutgoingTransaction.tag = 1
            buttonOutgoingTransaction.backgroundColor = UIColor(named: "app_green_color")
            buttonOutgoingTransaction.setTitleColor(UIColor(named: "app_background_color"), for: .normal)
            
        }else {
            
            sender.backgroundColor = UIColor(named: "app_blue_color")
            sender.tag = 0
            isAll = false
        }
    }
    
    func setShadow(button: UIButton) {
        
        // Shadow Color and Radius
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8.0
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
