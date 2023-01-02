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

class ProfilVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var profileImage = ""
    var profileDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        firebaseVerileriAl()//sayfa her açıldığında mesela editten geri döndüğünde de çalışacak wievdidload da sayfa ilk açıldığında çalışır sadece
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
                }else {
                    self.mesajGoster(title: "Hata", message: "Belgeler Bulunamadı!")
                }
            }
    }
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
