//
//  MainViewController.swift
//  MovieApp
//
//  Created by Midhun on 22/08/24.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    private var movies: [MovieData] = []
    private var filteredMovies: [MovieData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        fetchAPI(with: "")
    }
    
    private func fetchAPI(with searchTerm: String) {
        let baseURL = "http://www.omdbapi.com/"
        let url = "\(baseURL)?apikey=b5e926ed&type=movie&s=\(searchTerm)"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success:
                if let data = response.data, let json = try? JSON(data: data) {
                    let movieJSON = json["Search"].arrayValue
                    self.movies = movieJSON.map { MovieData(json: $0) }
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                } else {
                    self.showAlert("No movies found")
                }
            case .failure:
                self.showAlert("Failed to fetch movies")
            }
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func filterMovies(_ searchTerm: String) {
        if searchTerm.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchTerm.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        let posterURL = URL(string: "\(movie.poster)")
        cell.posterView.kf.setImage(with: posterURL)
        cell.titleLbl.text = movie.title
        cell.yearLbl.text = movie.year
        
        // Check if movie is favorite
        let isFavorite = getFavoriteMovies().contains(movie.imdbID)
        cell.favImg.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        cell.movie = movie // Set movie property
        cell.onFavoriteToggle = { [weak self] movie in
            if let strongSelf = self {
                let isFavorite = getFavoriteMovies().contains(movie.imdbID)
                if isFavorite {
                    removeFavorite(movie: movie)
                } else {
                    saveFavorite(movie: movie)
                }
                strongSelf.filterMovies(strongSelf.searchBar.text ?? "")
            }
        }
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchTerm = textField.text else { return true }
        fetchAPI(with: searchTerm)
        textField.resignFirstResponder()
        return true
    }
}
