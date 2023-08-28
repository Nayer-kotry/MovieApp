//
//  MovieTableViewCell.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 14/08/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var plotLabel: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: MovieCell){
        DispatchQueue.main.async {
            
            self.titleLabel?.text =  data.title
            
            if let releaseYear = data.releaseYear {
                self.releaseYearLabel?.text = String(releaseYear)
            }
            else {
                self.releaseYearLabel?.text = "Unknown"
            }
            if let seconds = data.duration {
                let hrs = seconds/3600
                let mins = (seconds - (3600*hrs))/60
                self.durationLabel?.text = "\(hrs)h \(mins)m"
            }
            else {
                self.durationLabel?.text = "Unknown"
            }
            if let rating = data.rating {
                self.ratingLabel?.text = String(format:"%.1f", rating)
            }
            else {
                self.ratingLabel?.text = "0"
            }
            
            if let plot = data.plot{
                self.plotLabel?.text = plot
            }
            else {
                self.plotLabel?.text = ""
            }
            if let imageUrl = data.image {
                if let imageURL = URL(string: imageUrl) {
                    // Fetch image data from the URL asynchronously
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            // Convert image data to UIImage on the main queue
                            DispatchQueue.main.async {
                                if let image = UIImage(data: imageData) {
                                    // Set the UIImage in the UIImageView
                                    self.movieImage.image = image
                                }
                            }
                        }
                    }
                }
            }
           
                
        }
      
        
        
    }
    
}
