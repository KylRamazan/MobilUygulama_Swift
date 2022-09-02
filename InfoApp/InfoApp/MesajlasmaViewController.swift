import UIKit
import MessageKit
import InputBarAccessoryView
 

struct Sender : SenderType {
    var senderId: String
    var displayName: String
}

struct Message : MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class MesajlasmaViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate  {
 
    
    
    let currentUser = Sender(senderId: "self", displayName: "Deneme")
    let otherUser = Sender(senderId: "other", displayName: "Test")
    var messages = [MessageType]()
    var mesajGonderilecekKisi:User?
    var gecerliUser:User?
    
    override func viewDidLoad() {
        self.mesajlariGetir()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                self.mesajlariGetir()
        }
        super.viewDidLoad()
        self.title = mesajGonderilecekKisi?.adSoyad
 
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
         
    }
    
     
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print(text)
        mesajGonder(mesaj: text)
        inputBar.inputTextView.text = ""
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    
    func mesajlariGetir(){
        let url = URL(string: "https://handancuhadar.com/veritabani/mesaj_getir.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "gonderici_id=" + gecerliUser!.userID + "&alici_id=" + mesajGonderilecekKisi!.userID

        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                     print("Error : \(error)")
            }else {
                if let response = response as? HTTPURLResponse {
                    print("status code : \(response.statusCode)")
                }
                
                do {
                    let mesajlar = try? JSONDecoder().decode(Mesajlar.self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.messages.removeAll()
                        mesajlar?.messages.forEach({ (mesaj1) in
                                    if (mesaj1.gondericiID == self.gecerliUser?.userID){
                                        self.messages.append(Message(sender: self.currentUser, messageId: mesaj1.messageID, sentDate: Date().addingTimeInterval(-86400), kind: .text("\(mesaj1.mesajText)")))
                                    }else{
                                        self.messages.append(Message(sender: self.otherUser, messageId: mesaj1.messageID, sentDate: Date().addingTimeInterval(-86400), kind: .text("\(mesaj1.mesajText)")))
                                    }
                        })
                        self.messagesCollectionView.reloadData()
                    }
                }
                catch let error{
                    print("error : \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func mesajGonder(mesaj text: String){
        let url = URL(string: "https://handancuhadar.com/veritabani/mesaj_gonder.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "gonderici_id=" + gecerliUser!.userID + "&alici_id=" + mesajGonderilecekKisi!.userID + "&mesaj_text=" + text

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
                    DispatchQueue.main.async {
                        if mesaj1 != nil{
                            if mesaj1!.success == 1{
                                self.mesajlariGetir()
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
