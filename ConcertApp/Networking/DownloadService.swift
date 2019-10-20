

import Foundation

class DownloadService {
    static let shared = DownloadService()
    var activeDownloads: [URL: Download] = [ : ]
    weak var delegate: URLSessionDelegate?
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: nil)
    }()
    private init() {
        
    }
    func startDownload(_ track: JsonDataImage) {
        let download = Download(track: track)
        download.task = DownloadService.shared.downloadsSession.downloadTask(with: track.previewURLSong)
        download.task?.resume()
        download.isDownloading = true
        DownloadService.shared.activeDownloads[download.track.previewURLSong] = download
    }
}
