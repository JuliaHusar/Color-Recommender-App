//
//  AlbumCollectionViewCell.swift
//  VividListenes
//
//  Created by Julia Husar on 4/16/25.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            albumImageView.contentMode = .scaleAspectFit
            albumTitleLabel.numberOfLines = 0
            albumTitleLabel.textAlignment = .center
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            albumImageView.image = nil
            albumTitleLabel.text = nil
        }

}
