//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Midhun on 22/08/24.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    var movie: MovieData?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movie else { return }
        titleLbl.text = movie.title
        yearLbl.text = "  \(movie.year)"
        if let posterURL = URL(string: movie.poster) {
            posterImgView.kf.setImage(with: posterURL)
        }
    }

}
