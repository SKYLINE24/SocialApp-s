//
//  PaylasimCell.swift
//  SocialApp's
//
//  Created by Erbil Can on 22.12.2022.
//

import UIKit

class PaylasimCell: UITableViewCell {

    @IBOutlet weak var yorumText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var emailText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
