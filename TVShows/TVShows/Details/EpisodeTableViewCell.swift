//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}

extension EpisodeTableViewCell {
    func configure(with item: ShowEpisode) {
        print("naslov:")
        print(item.title)
        title.text = item.title
    }
}
