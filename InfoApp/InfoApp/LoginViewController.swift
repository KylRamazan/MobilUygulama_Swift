
import UIKit
import Toaster


class LoginViewController: UIViewController {

    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtSifre: UITextField!
    
    var kisiler = [Kisiler]()
    var denemeGiris:Kisiler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.txtSifre.isSecureTextEntry = true
        
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func sifremiUnuttum(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "sifreEkrani") as! PasswordViewController
        navigationController?.pushViewController(gecilecekSayfa, animated: true)
        
    }
    
    @IBAction func girisYap(_ sender: Any) {
        
        if txtMail.text!.isEmpty || txtSifre.text!.isEmpty {
            Toast(text: "Email ve Şifre Alanı Boş Geçilemez!", duration: Delay.short).show()
        }else{
            if isValidEmail(txtMail.text!){
                Toast(text: "İşlem Gerçekleştiriliyor...", duration: Delay.short).show()
                girisYap()
            }else{
                Toast(text: "Geçerli Bir Mail Adresi Giriniz!", duration: Delay.short).show()
            }
        }
    }
    
    @IBAction func yeniKullaniciOlustur(_ sender: Any) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "yeniKullaniciEkrani") as! NewUserViewController
            navigationController?.pushViewController(gecilecekSayfa, animated: true)
       
        
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
    
    func girisYap(){
        let url = URL(string: "https://handancuhadar.com/veritabani/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let email = txtMail.text!
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
                
                do {
                    let denemeSinif = try? JSONDecoder().decode(Kisiler.self, from: data!)
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        if denemeSinif != nil{
                            Toast(text: denemeSinif?.message, duration: Delay.short).show()
                            if denemeSinif!.success == 1{
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
 
