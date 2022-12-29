//
//  ProfilVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 12.12.2022.
//

import UIKit
import Firebase
import SDWebImage

class ProfilVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var profileImage = ""
    var profileDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseVerileriAl()
        
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
                    print("Document does not exist in cache")
                }
            }
    }
    func hataMesajiGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
