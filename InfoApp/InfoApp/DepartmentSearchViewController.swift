//
//  DepartmentSearchViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 4.07.2021.
//

import UIKit

class DepartmentSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var gecerliUser:User?
    var veriler:[User] = [User]()
    var verilerUni:[User] = [User]()
    var aramaSonucu:[User] = [User]()
    var aramaYapiliyorMu = false
    
    override func viewDidLoad() {
        verileriGetir()
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
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
            return verilerUni.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hucreAdi", for: indexPath)
        
        if(self.aramaYapiliyorMu) {
            cell.textLabel?.text = aramaSonucu[indexPath.row].bolum
            cell.detailTextLabel?.text = aramaSonucu[indexPath.row].adSoyad
        }else{
            cell.textLabel?.text = verilerUni[indexPath.row].bolum
            cell.detailTextLabel?.text = verilerUni[indexPath.row].adSoyad
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
            print(verilerUni[indexPath.row].adSoyad)
            tiklanilanKisi = verilerUni[indexPath.row]
        }
        
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
            self.aramaSonucu = self.verilerUni.filter({$0.bolum.lowercased().contains(searchText.lowercased())})
        }
        
        tableView.reloadData()
    
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
                                
                                if user.userID == self.gecerliUser?.userID{
                                    
                                }else{
                                    self.veriler.append(user)
                                }
                            })
                            
                            self.verilerUni = self.veriler.filter({$0.egitim.lowercased().contains("universite")})
                            self.tableView.reloadData()
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
