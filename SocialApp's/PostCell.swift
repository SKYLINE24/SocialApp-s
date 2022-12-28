//
//  PostCell.swift
//  SocialApp's
//
//  Created by Erbil Can on 22.12.2022.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var yorumTextField: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
