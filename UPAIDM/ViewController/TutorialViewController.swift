//
//  TutorialViewController.swift
//  Edble
//
//  Created by Srajan Singhal on 05/01/21.
//

import UIKit


class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: NeumorphismButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        
        pageControl.isUserInteractionEnabled = false
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
        
        
        
        view.bringSubviewToFront(pageControl)
        
        
//        btnNext.layer.cornerRadius = 5
//        btnNext.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        pageControl.updateDots()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        /*
         *
         */
        setupSlideScrollView(slides: slides)
    }
    

    func createSlides() -> [Slide] {
        
//        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide1.imageView.image = UIImage(named: "tutorial_1")
//        slide1.labelTitle.text = "Sign invoice"
//        slide1.labelDescription.text = "Need some description here."
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "tutorial_2")
        slide2.labelTitle.text = "Starting up"
        slide2.labelDescription.text = "Just two steps to it. Register and Fund your account."

        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "tutorial_3")
        slide3.labelTitle.text = "Selling products and services"
        slide3.labelDescription.text = "You can sell anything through the app. From stable value assets to Derivatives. Just create an invoice and send it to the entity you want to trade with."
    
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "tutorial_4")
        slide4.labelTitle.text = "Welcome to the future of payments"
        slide4.labelDescription.text = "Pay with any asset or derivative, without the involment of banks and card schemes, just using your mobile."
        
        let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.imageView.image = UIImage(named: "tutorial_5")
        slide5.labelTitle.text = "Tokenize travel"
        slide5.labelDescription.text = "Cover all your mobility and payment needs with just one app. Enjoy privillages as if you were a local."
        
        let slide6:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide6.imageView.image = UIImage(named: "tutorial_6")
        slide6.labelTitle.text = "Sending Invoices"
        slide6.labelDescription.text = "It only takes the click of a button. The app knows what to do. Just fill up the fields and press the button."
        
        let slide7:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide7.imageView.image = UIImage(named: "tutorial_7")
        slide7.labelTitle.text = "Making a payment"
        slide7.labelDescription.text = "It can happen in one or two stages. The options are -Commit-to-Pay- & Pay. The app will guide when each one is applicable by activating the right button. You can pay any entity or any smart object simply and easily!"
        
        let slide8:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide8.imageView.image = UIImage(named: "tutorial_8")
        slide8.labelTitle.text = "Activity monitoring"
        slide8.labelDescription.text = "All you need to know about your accounts in one place."
        
        return [ slide2, slide3, slide4,slide5, slide6, slide7, slide8]
        
    }
    
    
    func setupSlideScrollView(slides : [Slide]) {
//        var topPadding = CGFloat(20)
//        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        topPadding = window?.safeAreaInsets.top ?? CGFloat(20)
//        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(slides.count), height: scrollView.bounds.height)
        scrollView.isPagingEnabled = true
       
        
            for i in 0 ..< slides.count {
                    slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.bounds.width, height: view.bounds.height)
                    scrollView.addSubview(slides[i])
            }
      
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
       
        pageControl.currentPage = Int(pageIndex)
  
        
        if Int(pageIndex) == slides.count-1{
            btnNext.tag = 1
//            btnNext.setTitle("Got it", for: .normal )
//            btnNext.titleLabel?.text = "Got it"
            
            
        }else{
            btnNext.tag = 0
//            btnNext.setTitle("Next", for: .normal )
//            btnNext.titleLabel?.text = "Next"
        }
      
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: UDKeys.setSkip)
        self.goToLogin()
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        
        if btnNext.tag == 0{
            
            var frame = scrollView.frame
            
            frame.origin.x = frame.size.width * CGFloat(pageControl.currentPage + 1)
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        }else{
            UserDefaults.standard.set(true, forKey: UDKeys.setSkip)
            self.goToLogin()
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

