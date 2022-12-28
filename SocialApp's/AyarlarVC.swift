//
//  SettingsVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 12.12.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func cikisYapTiklandi(_ sender: Any) {
        do{
            try Auth.auth().signOut()//kullanıcıdan çıkış yapmış oluyoruz butona tıkladığımızda, izlyeceğimiz segue de aşşağıda, kullanıcı uygulamaya tekrar girdiğinde giriş yapması gerekecek
            performSegue(withIdentifier: "toVC", sender: nil)
        }catch{
            print("Hata")
        }
    }
    

}
