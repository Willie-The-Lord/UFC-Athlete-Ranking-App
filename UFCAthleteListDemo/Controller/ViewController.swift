//
//  ViewController.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    // Construct a spinner
    let spinner = UIActivityIndicatorView(style: .large)
    
    // List of athletes
    var athletes: [Athlete] = []
    
    // Get our Data Source
    // We are sure that the UFCService exists, hence we use ! in this situation
    var ufcService: UFCService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Auto Layout spinner
        spinner.color = .gray
        spinner.hidesWhenStopped = true // Hide the spinner when the data finish loading
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // Initiate the instance
        self.ufcService = UFCService()
        
        
        // Start animating
        spinner.startAnimating()

        guard let confirmedService = self.ufcService else { return }

        confirmedService.getAthletes(completion: {athletes, error in
            guard let athletes = athletes, error == nil else {
                return
            }
            self.athletes = athletes
            self.tableView.reloadData()

            // When the api data is loaded, stop animating
            self.spinner.stopAnimating()
        })
        
        // Data Source & Delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
    }
    
    
    // Connect data to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let confirmedCell = self.tableView.cellForRow(at: selectedIndexPath) as? AthleteCell
        else { return }
        
        let confirmedAthlete = confirmedCell.athlete
        destination.athlete = confirmedAthlete
    }
    
    
}

extension ViewController: UITableViewDataSource {
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.athletes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "athleteCell") as! AthleteCell
        
        let currentAthlete = self.athletes[indexPath.row]
        
        cell.athlete = currentAthlete
        
        return cell
    }

}


extension ViewController: UITableViewDelegate {
    // MARK: Delegate
    
    // Implement a swipe action to toggle favorite state
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "", handler: { (action, view, completionHandler) in
            // Update data source when user taps action
            self.athletes[indexPath.row].favorite.toggle()
            
            if
                let cell = self.tableView.cellForRow(at: indexPath) as? AthleteCell,
                let confirmedAthlete = cell.athlete
            {
                cell.accessoryView = confirmedAthlete.favorite ? UIImageView(image: UIImage(named: "ufc-icon")) : .none
            }
            
            completionHandler(true)
        })
        
        // Set action image
        // Add to favorite: heart, delete from favorite: backward
        action.image = self.athletes[indexPath.row].favorite ? UIImage(systemName: "delete.backward.fill") : UIImage(systemName: "heart.fill")
        action.backgroundColor = self.athletes[indexPath.row].favorite ? UIColor(red: 216/255, green: 12/255, blue: 12/255, alpha: 1.0) : UIColor(red: 37/255, green: 150/255, blue: 190/255, alpha: 1.0)
        
        // Configuration
        let configuration = UISwipeActionsConfiguration(actions: [action])
        // We doesn't want the delete action trigger when user fully swipe on the cell. Set it to false
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

