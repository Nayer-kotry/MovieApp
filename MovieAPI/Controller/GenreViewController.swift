//
//  GenreViewController.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 14/08/2023.
//

import UIKit

class GenreViewController: UIViewController, GenreManagerProtocol {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleNav: UINavigationItem!
    
    var genres : [String?] = []
    
    var selectedCell : String?
    override func viewDidLoad() {
        super.viewDidLoad()
   
        var manager = ResultsManager()
        manager.genreDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        manager.fetchGenres()
    }
    
    func config(genres: [String?]) {
        self.genres = genres
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
extension GenreViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath)
        let data = genres[indexPath.row]
        DispatchQueue.main.async {
            if data != nil {
                cell.textLabel?.text = data
            }
            else {
                cell.textLabel?.text = "Unknown genre"
            }
               
        }
        return cell
    }

}
extension GenreViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedCell = genres[indexPath.row]
        performSegue(withIdentifier: "GenreSegue", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destinationVC = segue.destination as? SearchViewController {

            destinationVC.showLabel = true
            destinationVC.genreSelected = selectedCell
        }
    }
}
