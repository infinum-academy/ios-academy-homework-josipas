//
//  TvShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 20/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Kingfisher

final class TvShowsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}

extension TvShowsTableViewCell {
    func configure(with item: TvShowItem) {
        title.text = item.title
        let url = URL(string: "https://api.infinum.academy\(item.imageUrl)")
        myImage.kf.setImage(with: url)
    }
}
