

import Foundation.NSURL

struct JsonDataImage {
    let artistId: Int
    let imageTitle: String
    var previewURL: [URL?]
    var previewURLSong: URL
    let collectionName: String
    let trackName: String
    
    var downloaded = false
    
    init(artistName: String, artistId: Int, previewURL: [URL?], previewURLSong: URL, collectionName: String, trackName: String) {
        self.imageTitle = artistName
        self.artistId = artistId
        self.previewURL = previewURL
        self.previewURLSong = previewURLSong
        self.collectionName = collectionName
        self.trackName = trackName
}
}



