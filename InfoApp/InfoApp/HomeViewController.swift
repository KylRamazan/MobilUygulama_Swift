import UIKit
import Toaster

class HomeViewController: UIViewController {

    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var viewUniversiteler: CardView!
    @IBOutlet weak var viewBolumler: CardView!
    @IBOutlet weak var viewArkadaslar: CardView!
    @IBOutlet weak var viewMesajlar: CardView!
    @IBOutlet weak var viewIstatistikler: CardView!
    @IBOutlet weak var viewAyarlar: CardView!
    var veriler:[User] = [User]()
    
    var denemeGiris:Kisiler?
    
    override func viewDidLoad() {
        print(self.denemeGiris)
        self.navigationItem.hidesBackButton = true
        self.lblKullaniciAdi.text = denemeGiris?.users.first?.kullaniciAdi
        super.viewDidLoad()
         
        
        viewUniversiteler.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewUniversiteler.isUserInteractionEnabled = true
        
        viewBolumler.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewBolumler.isUserInteractionEnabled = true
        
        viewArkadaslar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewArkadaslar.isUserInteractionEnabled = true
        
        viewMesajlar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewMesajlar.isUserInteractionEnabled = true
        
        viewIstatistikler.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewIstatistikler.isUserInteractionEnabled = true
        
        viewAyarlar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        viewAyarlar.isUserInteractionEnabled = true
        
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
            let tag = gestureRecognizer.view?.tag
            switch tag! {
            case 1 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "universitelerEkrani") as! UniversitySearchViewController
                gecilecekSayfa.gecerliUser = self.denemeGiris?.users.first
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            case 2 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "bolumlerEkrani") as! DepartmentSearchViewController
                gecilecekSayfa.gecerliUser = self.denemeGiris?.users.first
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            case 3 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "arkadaslarEkrani") as! FriendsSearchViewController
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            case 4 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "mesajlarEkrani") as! MessagesSearchViewController
                gecilecekSayfa.gecerliUser = self.denemeGiris?.users.first
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            case 5 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "istatistiklerEkrani") as! StatisticsSearchViewController
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            case 6 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "ayarlarEkrani") as! SettingsViewController
                gecilecekSayfa.girisYapanKullanici = self.denemeGiris
                navigationController?.pushViewController(gecilecekSayfa, animated: true)
            default:
                print("default")
            }
        }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        Toast(text: "Başarıyla Çıkış Yapıldı.", duration: Delay.short).show()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "girisEkrani") as! LoginViewController
        navigationController?.pushViewController(gecilecekSayfa, animated: true)
        
    }
    
//    func verileriGetir(){
//            let url = URL(string: "https://handancuhadar.com/veritabani/tum_kisiler.php")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error{
//                         print("Error : \(error)")
//                }else {
//                    if let response = response as? HTTPURLResponse {
//                        print("status code : \(response.statusCode)")
//                    }
//
//                    do {
//
//                        let tempVerileri = try? JSONDecoder().decode(Kisiler.self, from: data!)
//
//                        DispatchQueue.main.asyncAfter(deadline: .now()) {
//                            tempVerileri?.users.forEach({ (user) in
//                            self.veriler.append(user)
//                            })
//                        }
//                    }
//                    catch let error{
//                        print("error : \(error.localizedDescription)")
//                    }
//                }
//            }
//            task.resume()
//        }
}
