//
//  PasswordViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 3.07.2021.
//

import UIKit
import Toaster

class PasswordViewController: UIViewController {

    @IBOutlet weak var btnYenile: UIButton!
    @IBOutlet weak var btnSifreOlustur: UIButton!
    @IBOutlet weak var txtRandom: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSayiGiriniz: UITextField!
    var mesaj:Mesaj!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtRandom.isUserInteractionEnabled = false
        
        self.btnYenile.layer.cornerRadius = 20
        self.btnYenile.clipsToBounds = true
        
        self.btnSifreOlustur.layer.cornerRadius = 20
        self.btnSifreOlustur.clipsToBounds = true
        
        self.txtRandom.text = randomUret()
        
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func yenile(_ sender: Any) {
        
        self.txtRandom.text = randomUret()
    }
    
    @IBAction func sifreOlustur(_ sender: Any) {
         
        if txtEmail.text!.isEmpty || txtRandom.text!.isEmpty{
            Toast(text: "Değerler Boş Geçilemez", duration: Delay.short).show()
            
        }else{
            
            if isValidEmail(txtEmail.text!){
                if(txtSayiGiriniz.text != txtRandom.text){
                    Toast(text: "Doğru değeri giriniz!", duration: Delay.short).show()
                }else{
                    Toast(text: "Yeni şifreniz mail adresinize gönderiliyor.", duration: Delay.short).show()
                    self.sifremiUnuttum()
                }
            }else{
                Toast(text: "Geçerli bir mail adresi giriniz!", duration: Delay.short).show()
            }
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
  
    func randomUret()->String {
        let randomInt = Int.random(in: 100000..<999999)
        return String(randomInt)
    }
    
    func girisYapSayfaGec(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "girisEkrani") as! LoginViewController
        self.navigationController?.pushViewController(gecilecekSayfa, animated: true)
        }
    
    func sifremiUnuttum(){
            let url = URL(string: "https://handancuhadar.com/veritabani/sifremi_unuttum.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let email = txtEmail.text!
            

            let postString = "email=\(email)" 

            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error{
                         print("Error : \(error)")
                }else {
                    if let response = response as? HTTPURLResponse {
                        print("status code : \(response.statusCode)")
                    }
                    
                    do {
                        let mesaj1 = try? JSONDecoder().decode(Mesaj.self, from: data!)
                         
                        
                        if mesaj1 != nil{
                            Toast(text: mesaj1?.message, duration: Delay.short).show()
                            if mesaj1!.success == 1{
                                //self.girisYapSayfaGec()
                                }
                            }
                    }
                    catch let error{
                        print("error : \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
}
