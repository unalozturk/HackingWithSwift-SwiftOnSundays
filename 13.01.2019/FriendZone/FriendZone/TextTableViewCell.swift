//
//  TextTableViewCell.swift
//  FriendZone
//
//  Created by Ünal Öztürk on 30.01.2019.
//  Copyright © 2019 Ünal Öztürk. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
