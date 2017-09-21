//
//  DukePersonTableViewCell.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/19/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class DukePersonTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // fix bug where TextView has top padding
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
