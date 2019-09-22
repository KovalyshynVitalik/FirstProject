//
//  IventListTableTableViewController.swift
//  ConcertApp
//
//  Created by Misha on 8/5/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


struct Event {
    var name: String
    var imageName: String
    var textName: String
    
}

class EventListTableViewController: UIViewController {
    
    var eventList: [ArtistModel]?
        
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    let queryService = QueryService()
    var searchResults: [JsonDataImage] = []
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.navigationItem.title = "Artist"
//     setupNavBar()
        
    }
    
//    func setupNavBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//
//    }
    
    
    

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL,completion: @escaping(Data) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            completion(data)
            
        }
    }
   
}


extension EventListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectio: Int) -> Int {
        return self.searchResults.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            EventTableViewCell else { return UITableViewCell() }
        
        cell.lbl.text = searchResults[indexPath.row].imageTitle
        
        if let unwrappedURL = searchResults[indexPath.row].previewURL.first,let url = unwrappedURL {
            
            self.downloadImage(from: url) { (data) in
                DispatchQueue.main.async {
                
                    cell.img.image = UIImage(data: data)
                }
            }

        
        }
        return cell
    
    }
    
    //MARK: SearchBar dismiss keyboard
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        vc?.artistDescription = searchResults[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}


extension EventListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self?.searchResults = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
}
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
}


