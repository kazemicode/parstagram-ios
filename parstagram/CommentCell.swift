//
//  CommentCell.swift
//  parstagram
//
//  Created by Sara Kazemi on 11/1/20.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commenterPost: UILabel!
    @IBOutlet weak var commenterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
