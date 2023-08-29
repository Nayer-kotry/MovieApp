//
//  MovieViewController.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 16/08/2023.
//

import UIKit

class MovieViewController: UIViewController{
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var movieUIImage: UIImageView!
    
    @IBOutlet weak var moveTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var castLabel: UILabel!

    @IBOutlet weak var WrittenByLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    @IBOutlet weak var DirectorLabel: UILabel!
    
    //MARK: - Variables
 
    var id: String?
    var movieTitle: String?
    var releaseDate:  Int?
    var duration: Int?
    var rating: Float?
    var cast: String?
    var plot: String?
    var actors : [String] = []
    var directors : [String] = []
    var writers : [String] = []
    var creators : [String] = []
    var imageURL: String?
    let movieViewModel = MovieViewModel()
    //MARK: - UI lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var MovieManager = MovieResultManager()
//        if id != nil {
//            MovieManager.fetchByTitleID(id:self.id!)
//        }
        //MovieManager.actorNamesDelegate = self
        //MovieManager.fetchDirectorsByTitleID(id: self.id!, info: ["extendedCast","creators_directors_writers"], imageURL: imageURL)
   
        movieViewModel.loadCast(id: self.id!, info:  ["extendedCast","creators_directors_writers"], imageURL: imageURL) { cast, imageData in
          
            self.actors = cast[0] ?? []
            self.directors = cast[1] ?? []
            self.writers = cast[2] ?? []
            self.creators = cast[3] ?? []
            self.config(imageData)
        }
     
        
    }
    
    //MARK: - Functions
    
    func config(_ imageData:Data? = nil) {
//        let actorNames = data?.actorNames
//        let creatorNames = data?.cast
//
//
//         directors = getCastNames(type: "directors", cast: creatorNames!)
//         writers = getCastNames(type: "writers", cast: creatorNames!)
//         creators = getCastNames(type: "creators", cast: creatorNames!)
//
//        if let arrayOfActors = actorNames?.results?.cast?.edges {
//
//            actors = arrayOfActors.map{
//                if let name =   $0?.node?.name?.nameText?.text {
//                    return name
//                }
//                return ""
//
//            }
//        }
//
        DispatchQueue.main.async {
            
            self.castLabel.text = "Cast: \(self.actors.joined(separator: " - "))"
            self.WrittenByLabel.text = "Written by: \(self.writers.joined(separator: " - "))"
            self.DirectorLabel.text = "Directors: \(self.directors.joined(separator: " - "))"
            self.moveTitleLabel.text = self.movieTitle
            self.ratingLabel.text = String(format:"%.1f", self.rating ?? 0)
            if let img = imageData{
                self.movieUIImage.image = UIImage(data: img)
            }
       
            if let seconds = self.duration {
                let hrs = seconds/3600
                let mins = (seconds - (3600*hrs))/60
                self.durationLabel?.text = "\(hrs)h \(mins)m"
            }
            else {
                self.durationLabel?.text = "Unknown"
            }
            
            
            if let releaseDate = self.releaseDate {
                self.releaseYearLabel.text = "\(releaseDate)"
            } else {
                self.releaseYearLabel.text = "Unknown"
            }
            
            if let plot = self.plot {
                self.plotLabel.text = "\(plot)"
            } else {
                self.plotLabel.text = "Unknown"
            }
           
        }
    }
 


//extension MovieViewController : ActorNamesDelegate {
//
//    func config(actorNames: ActorNames?) {
//        print("hi")
//
//
//    }
//
//    func observe(completion: (() -> Void)?) {
//        print("Hello World")
//        completion?()
//    }
//

  
    
//    func getCastNames(type: String, cast: CreatorResults) -> [String] {
//        var array: [CreditsInfo?] = []
//        var resultArray: [String] = []
//
//        switch type {
//        case "creators":
//            array = cast.creators
//        case "directors":
//            array = cast.directors
//        case "writers":
//            array = cast.writers
//        default:
//            print("error")
//        }
//
//        if let arrayofCredits = array.compactMap({ $0?.credits }).first {
//            resultArray = arrayofCredits.compactMap {
//                $0?.name?.nameText?.text ?? ""
//            }
//        }
//
//        return resultArray
//    }

}

struct MovieModel: Codable {
    
    var id: String?
    var movieTitle: String?
    var releaseDate:  Int?
    var duration: Int?
    var rating: Float?
    var cast: String?
    var plot: String?
    var actors : [String] = []
    var directors : [String] = []
    var writers : [String] = []
    var creators : [String] = []
    var imageURL: URL?
    
    init(result: Movie) {
        if let urlString = result.primaryImage?.url {
            let url = URL(string: urlString)
            self.imageURL = url
        }
 
    }
    
    
}
