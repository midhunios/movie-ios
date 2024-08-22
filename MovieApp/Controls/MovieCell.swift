//
//  MovieCell.swift
//  MovieApp
//
//  Created by Midhun on 22/08/24.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    var movie: MovieData?
    var onFavoriteToggle: ((MovieData) -> Void)? // Callback Property
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add UITapGestureRecognizer for UIImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favImgTapped))
        favImg.isUserInteractionEnabled = true
        favImg.addGestureRecognizer(tapGesture)
    }
    
    @objc private func favImgTapped() {
        guard let movie = movie else { return }
        onFavoriteToggle?(movie)
    }

}
