//
//  SearchVC.swift
//  SocialApp's
//
//  Created by Erbil Can on 29.12.2022.
//

import UIKit
import Firebase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    var usernameData = [String]()
    var tabledata = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    
    @objc func textFieldActive() {
        tableView.isHidden = usernameData.count > 0 ? false : true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

        let searchText  = textField.text! + string

        if searchText.count >= 3 {
            tableView.isHidden = false

            usernameData = tabledata.filter({ (result) -> Bool in
                return result.range(of: searchText, options: .caseInsensitive) != nil
            })

            tableView.reloadData()
        }
        else{
            usernameData = []
        }

        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection
    section: Int) -> Int {
        return usernameData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = usernameData[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath)

        cell.textLabel?.text = data

        return cell
    }
}
