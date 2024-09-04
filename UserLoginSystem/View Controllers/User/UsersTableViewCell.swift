//
//  UsersTableViewCell.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 06/08/24.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
