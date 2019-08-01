//
//  CommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class CommentsTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = nil
        commentTextField.text = nil
    }
}

extension CommentsTableViewCell {
    func configure(with item: Comment) {
        username.text = item.userEmail
        commentTextField.text = item.text
    }
}


