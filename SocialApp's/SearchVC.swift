//
//  SearchVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 29.12.2022.
//

import UIKit
import Firebase
import SDWebImage


class SearchVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextFieldField: UITextField!
    var searchUserEmail = ""
    
    var userDizisi = [UserProfileSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        userSearchCell()
    }
    
    func userSearchCell(){
        let firesotreDataBase = Firestore.firestore()
        if searchTextFieldField.text != ""{
            firesotreDataBase.collection("User").whereField("username", isEqualTo: searchTextFieldField!.text as Any).addSnapshotListener { (snapshot, Error) in
                if Error != nil {
                    print(Error?.localizedDescription as Any)
                }else{
                    if snapshot?.isEmpty != true && snapshot != nil{
                        for document in snapshot!.documents{
                            self.searchUserEmail = (document.get("email") as? String)!
                        }
                    }
                }
            }
        }else{
            self.mesajGoster(title: "Hata", message: "Lütfen Bir değer giriniz")
            return
        }
        let query = firesotreDataBase.collection("User").whereField("email", isEqualTo: searchUserEmail)
            .addSnapshotListener { (querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription as Any )
                }else{
                    if querySnapshot?.isEmpty != true && querySnapshot != nil{
                        self.userDizisi.removeAll(keepingCapacity: false)
                        for document in querySnapshot!.documents{
                            if let userImageUrl = document.get("profileImage") as? String{
                                if let username = document.get("username") as? String{
                                    let user = UserProfileSearch(userImageUrl: userImageUrl, username: username)
                                    self.userDizisi.append(user)
                                }
                             }
                        }
                  }
                    self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//kaç satırımız olucak
        return userDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cellde hangileri gösterilecek
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! SearchCell
        cell.usernameLabel.text = userDizisi[indexPath.row].username
        let userImageUrl = userDizisi[indexPath.row].userImageUrl
        cell.userImageView.sd_setImage(with: URL(string: userImageUrl))
        return cell
    }
    
    
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
