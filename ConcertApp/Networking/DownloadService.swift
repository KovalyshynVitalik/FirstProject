

import Foundation

class DownloadService {

  var activeDownloads: [URL: Download] = [ : ]
  
  
  var downloadsSession: URLSession!

  func startDownload(_ track: JsonDataImage) {
    let download = Download(track: track)
    download.task = downloadsSession.downloadTask(with: track.previewURLSong)
    download.task?.resume()
    download.isDownloading = true
    activeDownloads[download.track.previewURLSong] = download
  }
}
