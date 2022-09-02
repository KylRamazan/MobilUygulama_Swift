//
//  HighSchoolViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 4.07.2021.
//

import UIKit
import Toaster


class HighSchoolViewController: UIViewController {

    @IBOutlet weak var btnKayitOl: UIButton!
    @IBOutlet weak var txtAdSoyad: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtOkulAdi: UITextField!
    @IBOutlet weak var txtBolumAdi: UITextField!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtSifre: UITextField!
    var mesaj:Mesaj!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnKayitOl.layer.cornerRadius = 20
        self.btnKayitOl.clipsToBounds = true
        
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func kayitOl(_ sender: Any) {
        if txtAdSoyad.text!.isEmpty || txtMail.text!.isEmpty || txtOkulAdi.text!.isEmpty || txtBolumAdi.text!.isEmpty || txtKullaniciAdi.text!.isEmpty || txtSifre.text!.isEmpty{
            Toast(text: "Alanlar Boş Geçilemez!", duration: Delay.short).show()
        }else{
            if isValidEmail(txtMail.text!){
                Toast(text: "İşleminiz Gerçekleştiriliyor...", duration: Delay.short).show()
                kayitOl()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.mesaj != nil{
                        if self.mesaj.success == 1{
                            self.girisYapSayfaGec()
                        }
                    }
                }
            }else{
                Toast(text: "Geçerli Bir Mail Adresi Giriniz!", duration: Delay.short).show()
            }
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func girisYapSayfaGec(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "girisEkrani") as! LoginViewController
        navigationController?.pushViewController(gecilecekSayfa, animated: true)
    }
    
    func kayitOl(){
        let url = URL(string: "https://handancuhadar.com/veritabani/insert_user.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let ad_soyad = txtAdSoyad.text!
        let email = txtMail.text!
        let okul_adi = txtOkulAdi.text!
        let bolum = txtBolumAdi.text!
        let kullanici_adi = txtKullaniciAdi.text!
        let sifre = txtSifre.text!
        let egitim = "lise"

        let postString = "ad_soyad=\(ad_soyad)&email=\(email)&okul_adi=\(okul_adi)&bolum=\(bolum)&kullanici_adi=\(kullanici_adi)&sifre=\(sifre)&egitim=\(egitim)"
                //let postString = "email=\(txtMail.text)&sifre=\(txtSifre.text)"
//        let postString = "email=" + email + "&sifre=" + sifre

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
                    print(mesaj1)
                    if mesaj1 != nil{
                        Toast(text: mesaj1?.message, duration: Delay.short).show()
                      
                        }
                    DispatchQueue.main.async {
                        self.mesaj = mesaj1
                    }
                    
                }
                catch let error as NSError{
                    print("error : \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

