//
//  DuzenleVCViewController.swift
//  SocialApp's
//
//  Created by Erbil Can on 22.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class EditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileDescriptionTextField: UITextField!
    
    var profileDescription = ""
    var profileImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.isUserInteractionEnabled = true
        firebaseVerileriAl()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        profileImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func kaydetTiklandi(_ sender: Any) {//kaydet butonuna tıklandığında kullanıcının kaydetmek istediği açıklama ve profil fotoğrafı kaydolur
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")
        if let data = profileImageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (storagemetadata, error) in
                if error != nil{
                    self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin")
                }else{
                    imageReferance.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString//url nin stringe çevrilmiş hali
                            if let imageUrl = imageUrl{
                                let firestoreDatabase = Firestore.firestore()
                                let firestoreUser = ["profileImage" : imageUrl, "profileDescription" : self.profileDescriptionTextField.text! ] as [String : Any]
                                firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid).updateData(firestoreUser) { (error) in
                                    if error != nil{
                                        self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                    }else{
                                        self.mesajGoster(title: "Onaylandı", message: error?.localizedDescription ?? "Değişiklikler kaydedildi, Profile Geçebilirsiniz")
                                    }
                                 }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func firebaseVerileriAl(){//kullanıcının önceden verileri varsa düzenle butonun tıklanınca otomatik getirmek için
        let firestoreDatabase = Firestore.firestore()
        let docRef = firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid)
            docRef.getDocument(source: .cache){ (document, error) in
                if let document = document{
                    self.profileDescription = document.get("profileDescription") as! String
                    self.profileImage = document.get("profileImage") as! String
                    if self.profileDescription != nil{
                        self.profileDescriptionTextField.text = self.profileDescription
                    }else{
                        self.profileDescriptionTextField.text = ""
                    }
                    if self.profileImage != nil{
                        self.profileImageView.sd_setImage(with: URL(string: self.profileImage))
                    }else{
                        self.profileDescriptionTextField.text = ""
                    }
                    
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
