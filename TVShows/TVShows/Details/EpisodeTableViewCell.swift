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
    @IBOutlet weak var seasonAndEpisode: UILabel!
    
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
        title.text = item.title
        seasonAndEpisode.text = "S" + item.season + " Ep" + item.episodeNumber
    }
}
