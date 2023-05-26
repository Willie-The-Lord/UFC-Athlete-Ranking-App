//
//  ViewController.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/7.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var defaultView: UIView!
   
    // Construct a spinner
    let spinner = UIActivityIndicatorView(style: .large)
    
    // List of athletes
    var athletes: [Athlete] = []
    
    // List of favorite athletes
    var favoriteAthletes: [Athlete] = []
    var sortAthletes: [Athlete] = []
    var filteredAthletes: [Athlete] = []
    
    // Get our Data Source
    // We are sure that the UFCService exists, hence we use ! in this situation
    var ufcService: UFCService!
    
    // Flag to indicate whether to show all athletes or only favorites
    var showFavoritesOnly = false
    
    var isSorted = false
    
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)

    
    let loveButton = UIButton(type: .system)
    let sortButton = UIButton(type: .system)
    
    
    
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
            self.favoriteAthletes = athletes
            self.sortAthletes = athletes
            self.filteredAthletes = athletes
            self.tableView.reloadData()

            // When the api data is loaded, stop animating
            self.spinner.stopAnimating()
        })
        
        
        let stackView = UIStackView(arrangedSubviews: [loveButton, sortButton])
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        loveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        loveButton.tintColor = UIColor.black
        loveButton.addTarget(self, action: #selector(loveButtonTapped(_:)), for: .touchUpInside)

        sortButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        sortButton.tintColor = UIColor.black
        sortButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        
        // Create a UIBarButtonItem with the buttons
        let barButtonItem = UIBarButtonItem(customView: stackView)
        
        // Set the right bar button item
        navigationItem.rightBarButtonItem = barButtonItem
        
        configureDefaultView()
        
        // Data Source & Delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Athletes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
    }
    
    // Button action
    @objc func loveButtonTapped(_ sender: Any) {
        // Perform the desired functionality when the button is tapped
        showFavoritesOnly.toggle() // Toggle the flag
        updateAthletesToShow() // Update the list of athletes to show
        updateLoveButtonImage()
        tableView.reloadData() // Reload the table view to reflect the changes
    }
    
    
    @objc func sortButtonTapped(_ sender: Any) {
        // Perform the desired functionality when the button is tapped
        isSorted.toggle() // Toggle the flag
        updateAthletesToShow() // Update the list of athletes to show
        updateSortButtonImage()
        tableView.reloadData() // Reload the table view to reflect the changes
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
    
    // Update the list of athletes to show based on the flag
    func updateAthletesToShow() {
        if showFavoritesOnly && isSorted {
            filteredAthletes = athletes.filter { $0.favorite == true }
            filteredAthletes = filteredAthletes.sorted { $0.named < $1.named }
        } else if showFavoritesOnly && !isSorted {
            filteredAthletes = athletes.filter { $0.favorite == true }
        } else if !showFavoritesOnly && isSorted {
            filteredAthletes = athletes.sorted { $0.named < $1.named }
        } else {
            filteredAthletes = athletes
        }
        
        // Show or hide the default view based on the number of filtered athletes
        defaultView.isHidden = !filteredAthletes.isEmpty
    }
    
    // Update the button image based on the flag
    func updateLoveButtonImage() {
        let imageName = showFavoritesOnly ? "heart.fill" : "heart"
        let buttonImage = UIImage(systemName: imageName)
        self.loveButton.setImage(buttonImage, for: .normal)
    }
    
    func updateSortButtonImage() {
        let imageName = isSorted ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
        let buttonImage = UIImage(systemName: imageName)
        self.sortButton.setImage(buttonImage, for: .normal)
    }
    
    func configureDefaultView() {
//        let defaultImage = UIImage(named: "sad_conor")
//        let defaultImageView = UIImageView(image: defaultImage)
//        defaultImageView.contentMode = .scaleAspectFit
//        defaultImageView.frame.size.width = 200
        
        // Create a label for the message
        let label = UILabel()
        label.text = "No athletes available"
        label.textAlignment = .center
        label.textColor = .gray

        
        // Add the label to the default view
        defaultView = UIView()
        defaultView.addSubview(label)

        
        // Configure auto layout constraints for the label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: defaultView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: defaultView.centerYAnchor)
        ])
        
        // Add the default view as a subview of the table view
        tableView.addSubview(defaultView)
        
        // Configure auto layout constraints for the default view
        defaultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
//            defaultView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        // Hide the default view initially
        defaultView.isHidden = true
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredAthletes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "athleteCell") as! AthleteCell
        
        let currentAthlete = self.filteredAthletes[indexPath.row]
        
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

// Implement UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            filteredAthletes = filteredAthletes.filter { $0.named.lowercased().contains(searchText) }
        } else {
            updateAthletesToShow()
        }

        tableView.reloadData()
    }
}
