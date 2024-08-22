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
        fetchAPI()
    }
    
    private func fetchAPI() {
        let url = "http://www.omdbapi.com/?apikey=64e5c48a&type=movie&s=Don"
        AF.request(url).responseData { response in
            switch response.result {
            case .success:
                if let data = response.data, let json = try? JSON(data: data){
                    let movieJSON = json["Search"].arrayValue
                    self.movies = movieJSON.map{ MovieData(json: $0) }
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                }
            case .failure:
                break
            }
        }
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
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        let posterURL = URL(string: "\(movie.poster)")
        cell.posterView.kf.setImage(with: posterURL)
        cell.titleLbl.text = movie.title
        cell.yearLbl.text = movie.year
        return cell
    }
}

extension MainViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
    }
}
