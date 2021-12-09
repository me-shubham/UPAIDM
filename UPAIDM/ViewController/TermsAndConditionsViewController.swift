//
//  TermsAndConditionsViewController.swift
//  UPAIDM
//
//  Created by shubham singh on 24/11/21.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var profileButton: NeumorphismButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutUsButton: NeumorphismButton!
    @IBOutlet weak var helpAndSupportButton: NeumorphismButton!
    @IBOutlet weak var homeButton: NeumorphismButton!
    @IBOutlet weak var termsAndConditionButton: NeumorphismButton!
    @IBOutlet weak var cryptoButton: NeumorphismButton!
    
    var user : User!
    
    let helpText = "<p>The Hellenium Project and its subsidiaries (&ldquo;Hellenium&rdquo;, &ldquo;we&rdquo; or &ldquo;us&rdquo;) welcome you to our website, mobile applications and other services provided via electronic means (together referred to as &ldquo;Electronic Services&rdquo;) and appreciate your interest in our products and services. Hellenium attaches importance to appropriate data protection. This page explains how we treat your personal data in connection with your use of our Electronic Services (&ldquo;Privacy Policy&rdquo;). By continuing to use the Hellenium, you confirm that you are 18 years of age or older. Please note that we may amend this Privacy Policy from time to time. The applicable version is always the current one, as referenced above (last updated).</p><h4>Purpose and scope of the privacy policy</h4><p>Protecting your privacy and treating the personal data of all users of our Electronic Services in accordance with the law is important to us. We understand that by using our Electronic Services you may be entrusting us with personal information (&ldquo;data&rdquo;) and assure you that we take our duty to protect and safeguard this data very seriously. This Privacy Policy therefore explains the kind of data we process when using our Electronic Services, the purpose for which we process it, how we process it, whom we may disclose it to and the security measures we have put in place to protect it.<br />This Privacy Policy applies to all data we obtain through your use of our Electronic Services. It does not apply to data we obtain through other channels nor to Electronic Services of third parties (&ldquo;third-party Electronic Services&rdquo;), even if you access them via a link in our Electronic Services or even if they are necessary for the operation of our Electronic Services. We have no influence on the content or privacy policy of third-party Electronic Services and therefore cannot assume any responsibility for them.</p><h4>Types of data being processed</h4><p>When you use our Electronic Services, details of your usage may be automatically registered by our backend systems (such as your IP address, browser, http-header user agent, device-specific information the content you accessed, including time and date of access, usage and user interaction, and the redirecting website from which you came to our Electronic Services). We also process personal data such as your name, address, e-mail address, phone number, date of birth, gender and other data transmitted to us if you register for the usage of our Electronic Services or if you complete a registration form or comment field for a newsletter, product demos, etc..</p><h4>Legal grounds and purpose of data processing</h4><p>We process the data based on the following legal grounds: <br /><br />-For the performance of a contract to which you are a party or in order to take steps at your request prior to entering into a contract; <br />-For compliance with a legal obligation to which we are subject; <br />-For the purposes of our legitimate interests.<br />We process the data for the following purposes: <br /><br />-To comply with bank&rsquo;s own internal guidelines; <br />-To check the identity and suitability of clients for certain products and services; <br />-To establish a basis for future information on the products and services offered by Hellenium and to improve their quality; <br />-To facilitate technical administration, research and further development in connection with the Hellenium; <br />-To ensure the security and operation of our IT environment; <br />-To use it for marketing and advertising measures (e.g. newsletters via e-mail, online advertising); <br />-To analyse and monitor the usage, user behaviour and navigation while using the Electronic Services; <br />-To facilitate client administration.<br /><br />We process all your personal data in accordance with the applicable laws on data protection and for as long as required.</p><h4>Disclosure of electronic services usage data</h4><p>Hellenium only discloses Electronic Services usage data to third parties as permitted by law, if we are legally obliged to do so or if such disclosure becomes necessary to enforce our rights, in particular to enforce claims arising from a contractual relationship. Within this scope as well as for the purpose of optimising our products and services, we may transmit data within the Hellenium Group between Group companies in Switzerland or abroad. Furthermore, we may disclose data to external service providers if this is necessary for the provision of products and services. Such service providers may not use the data for any other purpose than to process the order in question. All of the above persons and entities that may receive data must observe the applicable national and international data protection laws as well as the data protection standards of Hellenium. <br />Where so prescribed by applicable legislation, Hellenium may on request or under an ongoing duty to provide information disclose data to supervisory authorities, judicial authorities or other persons of authority.</p><h4>Security measures of Hellenium</h4><p>Hellenium will make every effort to take appropriate technical and organisational security measures to ensure that your personal data processed within the IT environment controlled by Hellenium is protected against unauthorised access, misuse, loss and/or destruction, taking account of the applicable legal and regulatory requirements. <br />Hellenium takes both physical and electronic process-specific security measures, including firewalls, personal passwords, and encryption and authentication technologies. Our employees and the service providers commissioned by us are bound by professional secrecy and must comply with all data protection provisions. <br />Additionally, access to personal data is restricted to only those employees, contractors and third parties who require this access in order to assure the purpose of data processing and the provision of products and services (need to know principle).</p><h4>Transmission of data via an open network</h4><p>Hellenium would like to draw your attention to the fact that if you use our Electronic Services via an open network, this may allow third parties (e.g. app stores, network providers or the manufacturer of your device), wherever they are located, to access and process your data. Open networks are beyond Hellenium&rsquo;s control and can therefore not be regarded as a secure environment. Any transmission of data via such open network cannot be guaranteed to be secure or error-free as data may be intercepted, amended, corrupted, lost, destroyed, arrive late or incomplete, contain viruses or may be monitored. In particular, data sent via an open network may leave the country &ndash; even where both sender and recipient are in the same country &ndash; and may be transmitted to and potentially processed in third-party countries, where data protection requirements may be lower than in your country of residence. <br />Where data is transmitted via an open network, we cannot be held responsible for the protection of this data and we accept no responsibility or liability for the security of your data during transmission. We, therefore, recommend avoiding the transmission of any confidential information via open networks.</p><h4>Cookies</h4><p>The Hellenium use cookies for statistical purposes as a tool for our web developers and to improve the user experience. Cookies are small files which are stored on your electronic device to keep track of your visit to the Electronic Services and your preferences; as you move between pages, and sometimes to save settings between visits. Cookies help the builders of Electronic Services gather statistics about how often people visit certain areas of the site, and help in tailoring Electronic Services to be more useful and user-friendly. <br />Please note that most web browsers accept cookies automatically. You can configure your browser to not save any or only certain cookies on your electronic device or to always display a warning before receiving a new cookie. Deactivating cookies can, however, prevent you from using certain functions on our Electronic Services. <br />Please click here to let us know how we can use cookies. You can withdraw your consent at any time. These settings do not apply to Hellenium mobile applications. <br />Remark: For some Electronic Services, cookies are only persistent during user session and will be deleted after the session is terminated.</p><h4>Analysis tools</h4><p>We use various analysis tools from third parties such as Google Analytics for the purpose of reporting for Electronic Services. This involves the creation of pseudo-anonymised data and use of cookies to help analyse how users use our Electronic Services. The information about your use generated by these cookies, such as the <br /><br />-host name of the accessing electronic device (masked IP address) <br />-type/version of browser used <br />-operating system <br />-referrer URL (website from which visitors are redirected to the Hellenium by clicking a link) <br />-date and time of server request <br />-device-specific information <br /><br />may be transmitted to third party servers located in countries outside of the European Union and is used for analysis purposes. <br />Please click here to let us know how we can use cookies. You can withdraw your consent at any time. These settings do not apply to Hellenium mobile applications. <br />Please refer to the previous section, &ldquo;Cookies&rdquo;, for information on deleting cookies.</p><h4>Links</h4><p>The Hellenium may contain links to third-party Electronic Services that are not operated or monitored by us. Please be aware that such third-party Electronic Services are not bound by this Privacy Policy and that we are not responsible for their content or their principles regarding the handling of personal data. We therefore recommend consulting and checking the individual privacy policies or terms of use of third-party Electronic Services.</p><h4>Data subject rights</h4><p>According to applicable data protection laws and regulations, you may have the following rights:<br /><br />-requesting information on personal data that we hold about you, <br />-demanding that the information be rectified should it be incorrect, <br />-asking that your data be deleted if the Bank is not permitted or is not legally obliged to retain the data, <br />-demanding that the processing of your data be restricted, <br />-objecting to the processing by us, <br />-transferred in a generally useable, machine-readable, and standardised format. <br /><br />You also have a right of appeal (as far as this affects you) to the respective Data Protection Supervisory Authority</p><h4>Questions / Contact</h4><p>If you have questions about the processing of your personal data, please feel free to contact us by using the following contact details:<br /><br />Hellenium &amp; Co. Ltd.<br />Global Data Protection Officer P.O. <br />Box 8010 Zurich, Switzerland <br />dataprivacy@juliusbaer.com</p>"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        if let userName = userDefaults.string(forKey: UDKeys.userFullName) {
        
            self.welcomeLabel.text = "Hey, \(userName)"
            
        }
        
        titleLabel.text = "Terms And Conditions"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        
        aboutUsButton.cornerRadius = 8
        helpAndSupportButton.cornerRadius = 8
        homeButton.cornerRadius = 8
        termsAndConditionButton.cornerRadius = 8
        cryptoButton.cornerRadius = 8
        
    }
    

    @IBAction func aboutUsTapped(_ sender: Any) {
       
        self.moveToAnotherTab(identifier: "AboutUsViewController", animation: false)
        
    }
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        
        self.goToHome()
        
    }
    
    @IBAction func termsAndConditionTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func cryptoTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "CyptoTabViewController", animation: false)
        
    }
    
    
    @IBAction func helpAndSupportTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "HelpAndSupportViewController", animation: false)
        
    }
    
    
}

extension TermsAndConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? HelpAndSupportTableViewCell
        
        let htmlString = newAttrSize(blockQuote: self.helpText.htmlToAttributedString!)
        
        cell?.helpAndSupportLabel.attributedText = htmlString
        cell?.helpAndSupportLabel.numberOfLines = 0
        
        
        return cell ?? UITableViewCell()
        
    }
    
    func newAttrSize(blockQuote: NSAttributedString) -> NSAttributedString
    {
        let yourAttrStr = NSMutableAttributedString(attributedString: blockQuote)
        yourAttrStr.enumerateAttribute(.font, in: NSMakeRange(0, yourAttrStr.length), options: .init(rawValue: 0)) {
            (value, range, stop) in
            if let font = value as? UIFont {
                let resizedFont = font.withSize(font.pointSize * 0.75)
                yourAttrStr.addAttribute(.font, value: resizedFont, range: range)
            }
        }

        return yourAttrStr
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    
    
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

