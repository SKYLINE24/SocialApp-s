//
//  UploadVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 12.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class UploadVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameBulma()
        
        imageView.isUserInteractionEnabled = true         // kullanıcı resme tıkladığında işlem yapabilir hale getiriyoruz
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))       //jest algılayıcı(tıklama algılayıcı)
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary      //nereden alacağımızı belirtiyoruz
        present(pickerController, animated: true, completion: nil)          //bitme buloğu olmayan animasyonlu pickercontroller present et sunmak gibi birşey
        
        
    }
    //görseli seçtikten sonra ne yapılacağını yazdığımız fonksiyon
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage      // info bana verilen sözlük bunun içerisine anahtar veriyoruz originalimage seçilen görselin orjinal hali demek
        self.dismiss(animated: true,completion: nil)        //resim seçildikten sonra bu satır ile kapatıyoruz
    }
    @IBAction func paylasTiklandi(_ sender: Any) {
        //seçilen resimi firebase e gönderme --uuid verme
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")// strorag ın altında bir media adlı klasör oluştur
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            //ekleyeceğimiz fotoğraflara id vererek her fotoğraf yüklemede bir dosya oluşturmak yerine farklı farklı dosyalar oluştururarak eklenilen bütün fotoğrafları tutabiliyor childdan sonra yazarak tamamlıyoruz
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (storagemetadata, error) in
                //.pudData seçeneğinde metadata ve completion seçeneğini seçiyoruz değerleri (data , nil) 3. seçenekte enter ı tıklıyoruz
                if error != nil{
                    self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin")
                }else{
                    imageReferance.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString//url nin stringe çevrilmiş hali
                          
                            if let imageUrl = imageUrl{
                                let firestoreDatabase = Firestore.firestore()
                                let firestorePost = ["gorselUrl" : imageUrl, "yorum" : self.yorumTextField.text!, "tarih" : FieldValue.serverTimestamp(), "username" : self.usernameLabel.text!, "email" : Auth.auth().currentUser!.email] as [String : Any]
                                            firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
                                                    if error != nil{
                                                        self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                                    }else{
                                                        self.imageView.image = UIImage(named: "gorselSec")
                                                        self.yorumTextField.text = ""
                                                        self.tabBarController?.selectedIndex = 0
                                                    }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    func usernameBulma(){
        let firestoreDatabase = Firestore.firestore()
        let docRef = firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid)

                docRef.getDocument(source: .cache) { (document, error) in
                    if let document = document {
                        self.usernameLabel.text = document.get("username") as! String
                    } else {
                        print("Document does not exist in cache")
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
