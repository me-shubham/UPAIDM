//
//  ProfileViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEditProfile.layer.cornerRadius = 15
        buttonEditProfile.clipsToBounds = true
        setupUIData()
        
        // Do any additional setup after loading the view.
    }
    
    func setupUIData(){
        labelName.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
        labelPhoneNumber.text = (user.countryCode ?? "") + " " + (user.phoneNumber ?? "")
        labelEmail.text = user.email
    }
    
    @IBAction func onClickEditProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "EditProfile", sender: nil)
        
    }
    
    @IBAction func onClickHelp(_ sender: Any) {
        self.present(commonAlert(title: "Alert", message: "Under development."), animated: true, completion: nil)
        
    }
    
    @IBAction func onClickQA(_ sender: Any) {
        self.present(commonAlert(title: "Alert", message: "Under development."), animated: true, completion: nil)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "EditProfile"){
            if let viewController = segue.destination as? EditProfileViewController {
                viewController.user = user
                viewController.callback = { user in
                    if let user = user {
                        self.user = user
                        self.setupUIData()
                    }
                }
            }
        }
    }
  

}
