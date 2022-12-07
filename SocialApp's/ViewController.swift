//
//  ViewController.swift
//  SocialApp's
//
//  Created by Erbil Can on 24.11.2022.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func girisYapildi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!){ (authdataresult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız. Tekrar deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            //kullanıcı kayıt işlemleri
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            hataMesaji(titleInput: "Hata", messageInput: "Email ve şifre giriniz")
        }
    }
    
    
   
    

}

