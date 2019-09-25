
import Foundation

class QueryService {
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var dataImage: [JsonDataImage] = []
    
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([JsonDataImage]?, String) -> Void
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask =
                defaultSession.dataTask(with: url) { [weak self] data, response, error in
                    defer {
                        self?.dataTask = nil
                    }
                    
                    if let error = error {
                        self?.errorMessage += "DataTask error: " +
                            error.localizedDescription + "\n"
                    } else if
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        self?.updateSearchResults(data)
                        
                        DispatchQueue.main.async {
                            completion(self?.dataImage, self?.errorMessage ?? "")
                        }
                    }
            }
            
            dataTask?.resume()
        }
        
        
        DispatchQueue.main.async {
            completion(self.dataImage, self.errorMessage)
        }
    }
    
    func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        dataImage.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary {
                let previewURLString = [trackDictionary["artworkUrl100"] as? String, trackDictionary["artworkUrl60"]] as! [String]
                let previewURL = [URL(string: previewURLString[0]), URL(string: previewURLString[1])]
                if
                    let artistId = trackDictionary["artistId"] as? Int,
                    let artistName = trackDictionary["artistName"] as? String,
                    let previewURLSongString = trackDictionary["previewUrl"] as? String,
                    let previewURLSong = URL(string: previewURLSongString),
                    let collectionName = trackDictionary["collectionName"] as? String,
                    let trackName = trackDictionary["trackName"] as? String {
                    dataImage.append(JsonDataImage(artistName: artistName, artistId: artistId, previewURL: previewURL, previewURLSong: previewURLSong, collectionName: collectionName, trackName: trackName))
                } else {
                    errorMessage += "Problem parsing trackDictionary\n"
                }
            }
        }
    }
}
