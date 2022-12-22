//
//  PaylasimVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 12.12.2022.
//

import UIKit
import Firebase
import SDWebImage

class PaylasimVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var postDizisi = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()

    }
    func firebaseVerileriAl(){
        let firestoreDatabase = Firestore.firestore()//database değişkenimizi oluşturduk
        
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { (snapshot, error) in
            //Firestoredaki döküman çekme işlemini burda gerçekleştirdik
            if error != nil{
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{//snapshat boş mu değil mi burada onu kontrol ediyoruz
                    //her feed sayfasına geçtiğinde üstüne ekleyecek olduğu için silip aşşağıda tekrar yüklenmesini sağlıyoruz aşşağıdaki kod ile
                    self.postDizisi.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            if let yorum = document.get("yorum") as? String{
                                if let email = document.get("email") as? String{
                                    let post = Post(email: email, yorum: yorum, gorselUrl: gorselUrl)
                                    self.postDizisi.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()//yeni bir veri geldiğini ve gösterileceğini söylüyoruz
                }
            }
        }  //databasedeki post klasörüne kulaşabiliyorum şuan
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//kaç satırımız olucak
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cellde hangileri gösterilecek
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaylasimCell      //feed kısmındaki başlangıçta gösterilecekleri ayarladık
        cell.emailText.text = postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl))
        return cell
    }
    

}
