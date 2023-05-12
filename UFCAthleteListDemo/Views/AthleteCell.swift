//
//  AthleteCell.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/7.
//

import UIKit

class AthleteCell: UITableViewCell {
    
    @IBOutlet weak var athleteImageView: UIImageView!
    
    @IBOutlet weak var athleteNameLabel: UILabel!
    
    @IBOutlet weak var athleteDescriptionLabel: UILabel!
    
    // Set each athlete value
    
    var athlete: Athlete? {
        didSet {
            self.athleteNameLabel.text = athlete?.named
            self.athleteDescriptionLabel.text = athlete?.description
            
            // Set favorite image
            // If favorite then heart, otherwise no image
            self.accessoryView = athlete?.favorite ?? false ? UIImageView(image: UIImage(named: "ufc-icon")) : .none
            
            DispatchQueue.global(qos: .userInitiated).async {
                let athleteImageData = NSData(contentsOf: URL(string: self.athlete!.image)!)
                DispatchQueue.main.async {
                    self.athleteImageView.image = UIImage(data: athleteImageData! as Data)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
