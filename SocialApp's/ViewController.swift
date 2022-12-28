//
//  ViewController.swift
//  SocialApp's
//
//  Created by Erbil Can on 24.11.2022.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func girisYapTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!){
                (AuthDataResult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız. Tekrar deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toPostVC", sender: nil)
                }
            }
        }
    }
    
    
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {//kullanıcıyı Authentication a kaydedip aynı zamanda firebase e User koleksiyonunu oluşturuyoruz
        if emailTextField.text != "" && sifreTextField.text != "" && usernameTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!){
                (AuthDataResult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                }
                else{
                    let firestoreDatabase = Firestore.firestore()
                    let firestoreUser = ["userID" : Auth.auth().currentUser?.uid , "profileImage" : "", "profileDescription" : "" , "username" : self.usernameTextField.text! , "email" : self.emailTextField.text! , "createDate" : FieldValue.serverTimestamp()] as [String : Any]
                    firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { (error) in
                        if error != nil{
                            self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                        }else{
                            self.usernameTextField.text = ""
                            self.emailTextField.text = ""
                            self.sifreTextField.text = ""
                        }
                    }
                    self.performSegue(withIdentifier: "toPostVC", sender: nil)
                }
                
            }
            //kullanıcı kayıt işlemleri
        }
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
       
    }

}

