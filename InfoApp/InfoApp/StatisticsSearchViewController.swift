import SwiftUI

class StatisticsSearchViewController: UIViewController {
    
    @IBOutlet weak var lblKullanici: UILabel!
    @IBOutlet weak var lblUnili: UILabel!
    @IBOutlet weak var lblLiseli: UILabel!
    @IBOutlet weak var lblYazilim: UILabel!
    
    var veriler:[User] = [User]()
    var bilgiKullaniciSayisi:String = "Yükleniyor"
    var bilgiLiseliKullaniciSayisi:String = "Yükleniyor"
    var bilgiUniversiteliKullaniciSayisi:String = "Yükleniyor"
    var bilgiYazilimMuhSay:String = "Yükleniyor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verileriGetir()
        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func istatistik(){
        self.bilgiKullaniciSayisi = String(veriler.count)
        let tempUni = self.veriler.filter({$0.egitim.lowercased().contains("universite")})
        let tempLise = self.veriler.filter({$0.egitim.lowercased().contains("lise")})
        let tempYazilim = self.veriler.filter({$0.bolum.contains("Yazılım Mühendisliği")})
        self.bilgiUniversiteliKullaniciSayisi = String(tempUni.count)
        self.bilgiLiseliKullaniciSayisi = String(tempLise.count)
        self.bilgiYazilimMuhSay = String(tempYazilim.count)
        
        self.lblKullanici.text = self.bilgiKullaniciSayisi
        self.lblUnili.text = self.bilgiUniversiteliKullaniciSayisi
        self.lblLiseli.text = self.bilgiLiseliKullaniciSayisi
        self.lblYazilim.text = self.bilgiYazilimMuhSay
        
        print("-------------Istatistik------------")
        print("Kullanici Sayisi : \(self.bilgiKullaniciSayisi)")
        print("Universiteli Kullanici Sayisi : \(self.bilgiUniversiteliKullaniciSayisi)")
        print("Liseli Kullanici Sayisi : \(self.bilgiLiseliKullaniciSayisi)")
        print("Yazilim Sayisi : \(self.bilgiYazilimMuhSay)")
    }
    
    func verileriGetir(){
            let url = URL(string: "https://handancuhadar.com/veritabani/tum_kisiler.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error{
                         print("Error : \(error)")
                }else {
                    if let response = response as? HTTPURLResponse {
                        print("status code : \(response.statusCode)")
                    }
                    
                    do {
                        
                        let tempVerileri = try? JSONDecoder().decode(Kisiler.self, from: data!)
                        
                        DispatchQueue.main.async {
                            tempVerileri?.users.forEach({ (user) in
                            self.veriler.append(user)
                            })
                            
                            self.istatistik()
                            
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
