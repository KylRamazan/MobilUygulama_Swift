//
//  ViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 3.07.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var slogan: UILabel!
    @IBOutlet weak var slogan2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Animasyon()
    }
    
    
    
    func Animasyon(){
        
        self.logo.alpha = 0
        self.slogan.alpha = 0
        self.slogan2.alpha = 0
        
        UIView.animate(withDuration: 3, animations: {
            
            self.logo.transform = CGAffineTransform(translationX: 0, y: 200)
            self.logo.alpha = 1
            
            self.slogan.transform = CGAffineTransform(translationX: 0, y: -150)
            self.slogan.alpha = 1
            
            self.slogan2.transform = CGAffineTransform(translationX: 0, y: -150)
            self.slogan2.alpha = 1
            
        },completion: { (true) in
            
            self.sayfaGecisi()
            
        })
    }
    
    func sayfaGecisi(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "girisEkrani") as! LoginViewController
        navigationController?.pushViewController(gecilecekSayfa, animated: true)
    }

}

