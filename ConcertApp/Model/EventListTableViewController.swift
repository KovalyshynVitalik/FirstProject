//
//  IventListTableTableViewController.swift
//  ConcertApp
//
//  Created by Misha on 8/5/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
//import Alamofire
//import SDWebImage
import SystemConfiguration


struct Event {
    var name: String
    var imageName: String
    var textName: String
    
}

class EventListTableViewController: UIViewController  {
    
    var eventList: [ArtistModel]?
    
    
    @IBOutlet weak var tableView: UITableView!

    
    let queryService = QueryService()
    var searchResults: [JsonDataImage] = []
    var someArray: [String] = []
    var doubleArray: [[String]] = []
    let searchController = UISearchController(searchResultsController: nil)
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    var uniqueArtistId: [String] = []
    var artistDictionary = [String : [String]]()
    var selectedCell = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Artist"
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Artist Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        fillDictionary(data: searchResults)
        
        
        
        if isInternetAvailable() {
        }
        else {
            self.showAlert()
        }
    }
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL,completion: @escaping(Data) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            completion(data)
            
        }
    }
    
    func fillDictionary(data: [JsonDataImage]) {
        artistDictionary.removeAll()
        uniqueArtistId.removeAll()
        for itemIndex in 0 ..< data.count {
            if uniqueArtistId.contains(data[itemIndex].imageTitle) {
            } else {
                uniqueArtistId.append(data[itemIndex].imageTitle)
            }
            
            for index in 0 ..< uniqueArtistId.count {
                for songIndex in 0 ..< data.count {
                    if uniqueArtistId[index] == data[songIndex].imageTitle {
                        someArray.append(data[songIndex].trackName)
                    }
                }
                artistDictionary.updateValue(someArray , forKey: uniqueArtistId[index])
                someArray.removeAll()
            }
        }
        
        self.tableView.reloadData()
    }
    
    //Check internet conection
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    //Show alert that no internet conection
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
        
        cell.lbl.text = searchResults[indexPath.row].trackName

        
        if let unwrappedURL = searchResults[indexPath.row].previewURL.first,let url = unwrappedURL {
            
            self.downloadImage(from: url) { (data) in
                DispatchQueue.main.async {
                    
                    cell.img.image = UIImage(data: data)
                }
            }
        }
        return cell
        
    }
    
    //MARK: searchController dismiss keyboard
    @objc func dismissKeyboard() {
        searchController.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        vc?.artistDescription = searchResults[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
//    func fillItems(data: [JsonDataImage]) {
//        var tempImage: [URL] = []
//        tableView.removeAll()
//        fillDictionary(data: data)
//
//        for itemIndex in 0 ..< data.count {
//            for index in 0 ..< data[itemIndex].previewURL.count {
//                tempImage.append(data[itemIndex].previewURL[index]!)
//            }
//
//            eventList.append(JsonDataImage(description: data[itemIndex].trackId, eventCellModelContents: JsonDataImage.init(title: data[itemIndex].imageTitle, songName: data[itemIndex].songName, colectionId: data[itemIndex].collectionId, imageNames: tempImage)))
//            tempImage.removeAll()
//        }
//        self.tableView.reloadData()
//    }
    
    
}


extension EventListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dismissKeyboard()
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
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
            
//            if self?.searchResults.isEmpty ?? false {
//                let searchAlertController = UIAlertController(title: "Search", message: "No matching!", preferredStyle: .alert)
//                searchAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self?.present(searchAlertController, animated: true)
//            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    func searchBarTextDidBeginEditing(_ searchController: UISearchController) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchController: UISearchController) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
}

