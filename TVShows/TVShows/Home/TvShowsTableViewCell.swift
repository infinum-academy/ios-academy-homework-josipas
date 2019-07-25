//
//  TvShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 20/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class TvShowsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
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
    }
}
