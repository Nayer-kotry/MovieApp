//
//  ViewController.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 13/08/2023.
//

import UIKit

class SearchViewController: UIViewController, SearchManagerProtocol {
 
    

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies : Movies = Movies(results: [])
    var manager = ResultsManager()
    var showLabel : Bool? = false
    var genreSelected : String?
    var cellSelected : MovieCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.searchDelegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        manager.fetchAllMovies(genre: genreSelected)
        searchBar.placeholder = "Type the name of a movie"
        tableView.register(UINib.init(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.delegate = self
        if showLabel != nil {
            
            genreLabel.isHidden = false
            if (genreSelected != nil){
                genreLabel.text = genreSelected
            }
            else{
                genreLabel.constraints.first?.isActive = false
                genreLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true

            }
            
            
        }

    }

    func config(results: Movies){
        movies = results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    
    

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        if self.searchBar.text == ""{
            self.searchBar.placeholder = "type something..."
            return false

        }
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        if let inputMovie = self.searchBar.text {
            manager.fetchMovieSearch(title: inputMovie, genre: genreSelected)
        }
        searchBar.text = ""
        
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell {
            let data = movies.results[indexPath.row]
            cell.configure(data: data)
            return cell
        }
      
        return UITableViewCell()
        
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected = movies.results[indexPath.row]
        performSegue(withIdentifier: "movieViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MovieViewController {

            destinationVC.id = cellSelected?.id
            destinationVC.movieTitle = cellSelected?.title
            destinationVC.releaseDate = cellSelected?.releaseYear
            destinationVC.duration = cellSelected?.duration
            destinationVC.rating = cellSelected?.rating
            destinationVC.plot = cellSelected?.plot
            destinationVC.imageURL = cellSelected?.image
        }
  
    }
}
