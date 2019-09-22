

import Foundation

class Download {

  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: JsonDataImage

    
  init(track: JsonDataImage) {
    self.track = track
  }
}
