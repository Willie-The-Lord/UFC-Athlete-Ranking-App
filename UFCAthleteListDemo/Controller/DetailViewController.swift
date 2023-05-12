//
//  DetailViewController.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/8.
//

import UIKit

class DetailViewController: UIViewController {
    
    var athlete: Athlete?
    let favoriteButton = UIButton(type: .custom)
    let myColorRed = UIColor(red: 216/255, green: 12/255, blue: 12/255, alpha: 1.0)
    
    @objc func favoriteButtonTapped() {
        favoriteButton.isSelected = !favoriteButton.isSelected
        athlete?.favorite.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Athlete Description: 00-00-00
        // Split the string into three components
        let components = athlete?.description.components(separatedBy: "-")
        let win = Int(components?[0] ?? "") ?? 0
        let lose = Int(components?[1] ?? "") ?? 0
        let draw = Int(components?[2] ?? "") ?? 0

        
        // Create a scroll view that fills the entire view
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)

        // Set constraints for scroll view
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
   
        
        
        // Create a vertical stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        // Add the stack view to a parent view and set constraints
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 1000) // set a height constraint
        ])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        let guide = view.safeAreaLayoutGuide
//        stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16).isActive = true
//        stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16).isActive = true
        
        
        // Create an image view and add it to the scroll view
        DispatchQueue.global(qos: .userInitiated).async {
            let athleteImageData = NSData(contentsOf: URL(string: self.athlete!.image)!)
            DispatchQueue.main.async {
                let imageView = UIImageView(image: UIImage(data: athleteImageData! as Data))
                imageView.contentMode = .scaleAspectFit
                imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
                stackView.insertArrangedSubview(imageView, at: 1)
            }
        }
        
        
        // Create a vertical stack view
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 10
        
        
        
        let athleteName = UILabel()
        
        let attributedText = NSMutableAttributedString(string: athlete?.named ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 25, weight: .heavy),
            .foregroundColor: UIColor.black,

        ]
        attributedText.addAttributes(attributes, range: NSMakeRange(0, attributedText.length))

        // Set the attributed text on the label
        athleteName.attributedText = attributedText
        titleStackView.addArrangedSubview(athleteName)
        
        if athlete?.favorite ?? false {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(myColorRed, renderingMode: .alwaysOriginal), for:.selected)
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(myColorRed, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(myColorRed, renderingMode: .alwaysOriginal), for: .normal)
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(myColorRed, renderingMode: .alwaysOriginal), for: .selected)
        }
        
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        

        titleStackView.addArrangedSubview(favoriteButton)
        
        stackView.addArrangedSubview(titleStackView)
        

        
        
        
        // MARK: - WIN, LOSE, DRAW
        // HStack
        let statStackView = UIStackView()
        statStackView.axis = .horizontal
        statStackView.alignment = .center
        statStackView.spacing = 30
        statStackView.distribution = .equalSpacing
        
        // VStack
        let vstackView1 = UIStackView()
        vstackView1.axis = .vertical
        vstackView1.alignment = .center
        vstackView1.spacing = 5
        vstackView1.distribution = .equalSpacing
        
        let vstackView2 = UIStackView()
        vstackView2.axis = .vertical
        vstackView2.alignment = .center
        vstackView2.spacing = 5
        vstackView2.distribution = .equalSpacing
        
        let vstackView3 = UIStackView()
        vstackView3.axis = .vertical
        vstackView3.alignment = .center
        vstackView3.spacing = 5
        vstackView3.distribution = .equalSpacing
        
        
        
        // Create labels
        let attributedWinLabel = NSMutableAttributedString(string: "Wins")
        let attributesWinLabel: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor(red: 37/255, green: 150/255, blue: 190/255, alpha: 1.0)
        ]
        attributedWinLabel.addAttributes(attributesWinLabel, range: NSMakeRange(0, attributedWinLabel.length))
        
        let attributedLoseLabel = NSMutableAttributedString(string: "Loses")
        let attributesLoseLabel : [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.red.withAlphaComponent(0.7)
        ]
        attributedLoseLabel.addAttributes(attributesLoseLabel , range: NSMakeRange(0, attributedLoseLabel.length))
        
        let attributedDrawLabel = NSMutableAttributedString(string: "Draws")
        let attributesDrawLabel : [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.gray.withAlphaComponent(0.7)
        ]
        attributedDrawLabel.addAttributes(attributesDrawLabel , range: NSMakeRange(0, attributedDrawLabel.length))
        
        
        let winLabel = UILabel()
        winLabel.attributedText = attributedWinLabel
        let loseLabel = UILabel()
        loseLabel.attributedText = attributedLoseLabel
        let drawLabel = UILabel()
        drawLabel.attributedText = attributedDrawLabel
        let winShow = UILabel()
        winShow.text = components?[0] ?? ""
        let loseShow = UILabel()
        loseShow.text = components?[1] ?? ""
        let drawShow = UILabel()
        drawShow.text = components?[2] ?? ""
        
    
        // Add labels to stack view
        vstackView1.addArrangedSubview(winLabel)
        vstackView1.addArrangedSubview(winShow)
        
        vstackView2.addArrangedSubview(loseLabel)
        vstackView2.addArrangedSubview(loseShow)
        
        vstackView3.addArrangedSubview(drawLabel)
        vstackView3.addArrangedSubview(drawShow)
        
        
        statStackView.addArrangedSubview(vstackView1)
        statStackView.addArrangedSubview(vstackView2)
        statStackView.addArrangedSubview(vstackView3)
        
        stackView.addArrangedSubview(statStackView)
        
        
        // MARK: - CHART
        
        let chartView = PieChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        chartView.data = [CGFloat(win), CGFloat(lose), CGFloat(draw)]
        chartView.backgroundColor = UIColor.white
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackView.addArrangedSubview(chartView)
        
        
        
    
        
        
        
        // MARK: - SIG STR BY POSITION
        
        // HStack
        let statStackView2 = UIStackView()
        statStackView2.axis = .horizontal
        statStackView2.alignment = .center
        statStackView2.spacing = 30
        statStackView2.distribution = .equalSpacing
        
        // VStack
        let vstackView4 = UIStackView()
        vstackView4.axis = .vertical
        vstackView4.alignment = .center
        vstackView4.spacing = 5
        vstackView4.distribution = .equalSpacing
        
        let vstackView5 = UIStackView()
        vstackView5.axis = .vertical
        vstackView5.alignment = .center
        vstackView5.spacing = 5
        vstackView5.distribution = .equalSpacing
        
        let vstackView6 = UIStackView()
        vstackView6.axis = .vertical
        vstackView6.alignment = .center
        vstackView6.spacing = 5
        vstackView6.distribution = .equalSpacing
        
        let attributedStandingLabel = NSMutableAttributedString(string: "Standing")
        let attributesStandingLabel: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor(red: 37/255, green: 150/255, blue: 190/255, alpha: 1.0)
        ]
        attributedStandingLabel.addAttributes(attributesStandingLabel, range: NSMakeRange(0, attributedStandingLabel.length))
        
        let attributedClinchLabel = NSMutableAttributedString(string: "Clinch")
        let attributesClinchLabel : [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.red.withAlphaComponent(0.7)
        ]
        attributedClinchLabel.addAttributes(attributesClinchLabel , range: NSMakeRange(0, attributedClinchLabel.length))
        
        let attributedGroundLabel = NSMutableAttributedString(string: "Ground")
        let attributesGroundLabel : [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.gray.withAlphaComponent(0.7)
        ]
        attributedGroundLabel.addAttributes(attributesGroundLabel , range: NSMakeRange(0, attributedGroundLabel.length))
        
        let standingLabel = UILabel()
        standingLabel.attributedText = attributedStandingLabel
        let clinchLabel = UILabel()
        clinchLabel.attributedText = attributedClinchLabel
        let groundLabel = UILabel()
        groundLabel.attributedText = attributedGroundLabel
        
        let standingShow = UILabel()
        standingShow.text = athlete?.standing
        let clinchShow = UILabel()
        clinchShow.text = athlete?.clinch
        let groundShow = UILabel()
        groundShow.text = athlete?.ground
        
        
        // Add labels to stack view
        vstackView4.addArrangedSubview(standingLabel)
        vstackView4.addArrangedSubview(standingShow)
        
        vstackView5.addArrangedSubview(clinchLabel)
        vstackView5.addArrangedSubview(clinchShow)
        
        vstackView6.addArrangedSubview(groundLabel)
        vstackView6.addArrangedSubview(groundShow)
        
        
        statStackView2.addArrangedSubview(vstackView4)
        statStackView2.addArrangedSubview(vstackView5)
        statStackView2.addArrangedSubview(vstackView6)
        
        stackView.addArrangedSubview(statStackView2)
        
        // MARK: - CHART
        
        let standing = Int(athlete?.standing ?? "") ?? 0
        let clinch = Int(athlete?.clinch ?? "") ?? 0
        let ground = Int(athlete?.ground ?? "") ?? 0
        
        
        let chartView2 = PieChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        chartView2.data = [CGFloat(standing), CGFloat(clinch), CGFloat(ground)]
        chartView2.backgroundColor = UIColor.white
        chartView2.translatesAutoresizingMaskIntoConstraints = false
        chartView2.widthAnchor.constraint(equalToConstant: 150).isActive = true
        chartView2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackView.addArrangedSubview(chartView2)
        
        
        let image = UIImage(named: "ufc")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        
//        print("\(stackView.intrinsicContentSize.height)")
        
//        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 2000)
//        scrollView.addSubview(stackView)
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
