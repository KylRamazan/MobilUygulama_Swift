
import UIKit
import Toaster

class MessagesSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var gecerliUser:User?
    var tumMesajlar:[User] = [User]()

    var veriler:[User] = [User]()
    var aramaSonucu:[User] = [User]()
    var aramaYapiliyorMu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        mesajlar()
    
    //Ekrana tıklayınca klavyeyi kapatma
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)

}

func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(self.aramaYapiliyorMu) {
        return aramaSonucu.count
    }else{
        return tumMesajlar.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "hucreAdi", for: indexPath)
    
    if(self.aramaYapiliyorMu) {
        cell.textLabel?.text = aramaSonucu[indexPath.row].adSoyad
        cell.detailTextLabel?.text = aramaSonucu[indexPath.row].okulAdi + " - " + aramaSonucu[indexPath.row].bolum
    }else{
        cell.textLabel?.text = tumMesajlar[indexPath.row].adSoyad
        cell.detailTextLabel?.text = tumMesajlar[indexPath.row].okulAdi + " - " + tumMesajlar[indexPath.row].bolum
    }
    
    cell.accessoryType = .disclosureIndicator
    return cell
    
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var tiklanilanKisi:User?
    
    if(self.aramaYapiliyorMu) {
        print(aramaSonucu[indexPath.row].adSoyad)
        tiklanilanKisi = aramaSonucu[indexPath.row]
    }else{
        print(tumMesajlar[indexPath.row].adSoyad)
        tiklanilanKisi = tumMesajlar[indexPath.row]
    }
    print("tiklandi")
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let gecilecekSayfa = storyboard.instantiateViewController(withIdentifier: "mesajlasmaEkrani") as! MesajlasmaViewController
    gecilecekSayfa.mesajGonderilecekKisi = tiklanilanKisi
    gecilecekSayfa.gecerliUser = self.gecerliUser
    navigationController?.pushViewController(gecilecekSayfa, animated: true)
    
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if(searchText == "") {
        self.aramaYapiliyorMu = false
    }else{
        self.aramaYapiliyorMu = true
        self.aramaSonucu = self.tumMesajlar.filter({$0.adSoyad.lowercased().contains(searchText.lowercased())})
    }
    tableView.reloadData()
}

func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  let contextItem = UIContextualAction(style: .destructive, title: "Sil") {  (contextualAction, view, boolValue) in
    
    if(self.aramaYapiliyorMu) {
        print(self.aramaSonucu[indexPath.row].adSoyad)
        self.mesajSil(silinecekUser: self.aramaSonucu[indexPath.row])
    }else{
        print(self.tumMesajlar[indexPath.row].adSoyad)
        self.mesajSil(silinecekUser: self.tumMesajlar[indexPath.row])
    }
  }
  
    let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

  return swipeActions
}

func tableViewYenile(){
    self.tableView.reloadData()
}

func mesajSil(silinecekUser: User){
    let url = URL(string: "https://handancuhadar.com/veritabani/mesaj_sil.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let postString = "gonderici_id=" + gecerliUser!.userID + "&alici_id=" + silinecekUser.userID

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
                print(mesaj1!)
                Toast(text: mesaj1?.message, duration: Delay.short).show()
                DispatchQueue.main.async {
                    if mesaj1 != nil{
                        if mesaj1!.success == 1{
                            self.mesajlar()
                            
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


func mesajlar(){
    let url = URL(string: "https://handancuhadar.com/veritabani/mesajlar.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let postString = "gonderici_id=" + gecerliUser!.userID

    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error{
                 print("Error : \(error)")
        }else {
            if let response = response as? HTTPURLResponse {
                print("status code : \(response.statusCode)")
            }
            
            do {
                let kisiler = try? JSONDecoder().decode(Kisiler.self, from: data!)
                
                DispatchQueue.main.async {
                    self.tumMesajlar.removeAll()
                    kisiler?.users.forEach({ (user) in
                        if user.userID == self.gecerliUser?.userID{
                            
                        }else{
                            var deneme = true;
                            self.tumMesajlar.forEach({ (user1) in
                                if user1.userID == user.userID {
                                    deneme = false;
                                }
                            })
                            if deneme{
                                self.tumMesajlar.append(user)
                            }
                        }
                    })
                    //Do UI Code here.
                    //Call Google maps methods.
                    self.tableViewYenile()
                    print(self.tumMesajlar)
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
