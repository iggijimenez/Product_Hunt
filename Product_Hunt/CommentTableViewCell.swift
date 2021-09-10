//
//  CommentTableViewCell.swift
//  Product_Hunt
//
//  Created by Jimenez on 9/10/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var CommentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
