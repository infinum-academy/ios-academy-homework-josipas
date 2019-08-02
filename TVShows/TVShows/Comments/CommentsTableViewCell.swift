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
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = nil
        commentLabel.text = nil
    }
}

extension CommentsTableViewCell {
    func configure(with item: Comment) {
        username.text = item.userEmail
        commentLabel.text = item.text
        userImage.image = UIImage(named: "img-placeholder-user\(Int.random(in: 1...3))")
    }
}


