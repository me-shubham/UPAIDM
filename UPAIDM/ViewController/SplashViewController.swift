//
//  SplashViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 04/02/21.
//

import UIKit
import SwiftGifOrigin

class SplashViewController: UIViewController {

    @IBOutlet weak var imageViewSplash: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageViewSplash.loadGif(name: "Splash_GIF_1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            
            
            if(!userDefaults.bool(forKey: UDKeys.setSkip)){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tutorialViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
                UIApplication.shared.windows.first?.rootViewController = tutorialViewController
            }else{
            
            if(userDefaults.bool(forKey: UDKeys.isLogin)){
                UIViewController().goToHome()
                
            }else{
                UIViewController().goToLogin()
                
            }
                
            }
           
        
        }
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
