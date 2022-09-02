//
//  SettingsViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 4.07.2021.
//

import UIKit
import Toaster

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var txtAdSoyad: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOkulAdi: UITextField!
    @IBOutlet weak var txtBolumAdi: UITextField!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtSifre: UITextField!
    @IBOutlet weak var btnGuncelle: UIButton!
    var mesaj:Mesaj!
    var girisYapanKullanici:Kisiler?
    var guncelKullanici:Kisiler?
    var userId:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userId = self.girisYapanKullanici?.users.first?.userID
        self.txtAdSoyad.text = self.girisYapanKullanici?.users.first?.adSoyad
        self.txtEmail.text = self.girisYapanKullanici?.users.first?.email
        self.txtOkulAdi.text = self.girisYapanKullanici?.users.first?.okulAdi
        self.txtBolumAdi.text = self.girisYapanKullanici?.users.first?.bolum
        self.txtKullaniciAdi.text = self.girisYapanKullanici?.users.first?.kullaniciAdi
        self.txtSifre.text = self.girisYapanKullanici?.users.first?.sifre
        
        self.btnGuncelle.layer.cornerRadius = 20
        self.btnGuncelle.clipsToBounds = true
        
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func guncelle(_ sender: Any) {
        
        if txtAdSoyad.text!.isEmpty || txtEmail.text!.isEmpty || txtOkulAdi.text!.isEmpty || txtBolumAdi.text!.isEmpty || txtKullaniciAdi.text!.isEmpty  || txtSifre.text!.isEmpty{
            Toast(text: "Değerler Boş Geçilemez", duration: Delay.short).show()
        }else{
            if isValidEmail(txtEmail.text!){
                Toast(text: "İşlem gerçekleştiriliyor.", duration: Delay.short).show()
                self.bilgileriGuncelle()
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
     
    func anasayfaGec(gonderilecekKisi: Kisiler){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "anasayfaEkrani") as! HomeViewController
        gecilecekSayfa.denemeGiris = gonderilecekKisi
        navigationController?.pushViewController(gecilecekSayfa, animated: true)
    }
    
    func bilgileriGuncelle(){
        let url = URL(string: "https://handancuhadar.com/veritabani/update_user.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let userid = self.girisYapanKullanici?.users.first?.userID
 
        var postString = "user_id=" + userid!
        postString += "&email=" + txtEmail.text!
        postString += "&ad_soyad=" + txtAdSoyad.text!
        postString += "&okul_adi=" + txtOkulAdi.text!
        postString += "&bolum=" + txtBolumAdi.text!
        postString += "&kullanici_adi=" + txtKullaniciAdi.text!
        postString += "&sifre=" + txtSifre.text!

        request.httpBody = String(postString).data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error{
                         print("Error : \(error)")
                }else {
                    if let response = response as? HTTPURLResponse {
                        print("status code : \(response.statusCode)")
                    }
                    
                    do {
                        let mesaj1 = try? JSONDecoder().decode(Mesaj.self, from: data!)
                        print(mesaj1!)
                        Toast(text: mesaj1?.message, duration: Delay.short).show()
                        DispatchQueue.main.async {
                            self.mesaj = mesaj1
                        }
                        if mesaj1 != nil{
                            if mesaj1!.success == 1{
                                self.girisYap()
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
    
    func girisYap(){
        let url = URL(string: "https://handancuhadar.com/veritabani/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let email = txtEmail.text!
        let sifre = txtSifre.text!

                //let postString = "ad_soyad=TESTad&email=deneme&okul_adi=deneme&bolum=deneme&kullanici_adi=Deneme123&sifre=123321&egitim=123321"
                //let postString = "email=\(txtMail.text)&sifre=\(txtSifre.text)"
        let postString = "email=" + email + "&sifre=" + sifre

        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                     print("Error : \(error)")
            }else {
                if let response = response as? HTTPURLResponse {
                    print("status code : \(response.statusCode)")
                }
                
                do{
                    let denemeSinif = try? JSONDecoder().decode(Kisiler.self, from: data!)
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        if denemeSinif != nil{
                            if denemeSinif!.success == 1{
                                Toast(text: "Başarıyla Güncellendi", duration: Delay.short).show()
                                self.anasayfaGec(gonderilecekKisi:denemeSinif!)
                            }
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
