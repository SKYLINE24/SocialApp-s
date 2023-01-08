//
//  ProfilVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 12.12.2022.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage

class ProfilVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var postofNumberLabel: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var profileImage = ""
    var profileDescription = ""
    
    var postDizisi = [UserProfilePost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        fetchPosts()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        firebaseVerileriAl()//sayfa her açıldığında çalışacak wievdidload sayfa ilk açıldığında çalışır (sadece zaman döngüsü durumu)
    }
    
    
    
    @IBAction func takipEtTiklandi(_ sender: Any) {
        let uuid = UUID().uuidString
        let firestoreDatabase = Firestore.firestore()
        let firestorePost = ["email" : Auth.auth().currentUser!.email] as [String : Any]
            firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
            if error != nil{
                self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
            }else{
                self.tabBarController?.selectedIndex = 3
            }
        }
    }
    
    func firebaseVerileriAl(){
        let firestoreDatabase = Firestore.firestore()
        let docRef = firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid)
            docRef.getDocument(source: .cache){ (document, error) in
                if let document = document{
                    self.usernameLabel.text = document.get("username") as! String
                    self.profileDescription = document.get("profileDescription") as! String
                    self.profileImage = document.get("profileImage") as! String
                    self.imageView.sd_setImage(with: URL(string: self.profileImage))
                    self.descriptionLabel.text = self.profileDescription
                }else{
                    self.mesajGoster(title: "Hata", message: "Belgeler Bulunamadı!")
                }
            }
     }
    
    func fetchPosts(){
        let firesotreDataBase = Firestore.firestore()
        let query = firesotreDataBase.collection("Post").order(by: "tarih").whereField("email", isEqualTo: Auth.auth().currentUser!.email)
            .addSnapshotListener { (querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription )
                }else{
                    if querySnapshot?.isEmpty != true && querySnapshot != nil{
                        self.postDizisi.removeAll(keepingCapacity: false)
                        for document in querySnapshot!.documents{
                            if let gorselUrl = document.get("gorselUrl") as? String{
                                let userPost = UserProfilePost(gorselUrl: gorselUrl)
                                self.postDizisi.append(userPost)
                            }
                        }
                  }
                    self.tabelView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//kaç satırımız olucak
        self.postofNumberLabel.text = "\(postDizisi.count.self)"
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cellde hangileri gösterilecek
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCell", for: indexPath) as! ProfileCell
        let gorselUrl = postDizisi[indexPath.row].gorselUrl
        cell.leftImageView.sd_setImage(with: URL(string: gorselUrl))
        return cell
    }
    
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
