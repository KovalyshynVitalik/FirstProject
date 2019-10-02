//
//  DetailViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/16/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import AVKit




class DetailViewController: UIViewController, UITextViewDelegate, URLSessionDelegate {
    
    
    
    var eventImageNames: ConcertDetails? {
        didSet {
            
        }
    }
    var artistDescription: JsonDataImage?
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var eventCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    
    var imgArray: [UIImage] = []
    
    var timer = Timer()
    var counter = 0
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var searchResults: [JsonDataImage] = []
    let downloadService = DownloadService()
    var isDownloadPressed = false
    var isDeletePressed = false
    var isPlayPressed = false
    let progress = Progress(totalUnitCount: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.isHidden = true
        
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "com.raywenderlich.HalfTunes.bgSession")
        let downloadsSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        downloadService.downloadsSession = downloadsSession
        populateUIWithModel()
        textSetup()
        setUpLayout()
//        pageView.numberOfPages = imgArray.count
//        pageView.currentPage = 0
        
        
    }
    
    
    @IBAction func showButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let track = self.artistDescription else {
            return
        }
        
        let url = self.localFilePath(for: track.previewURLSong)
        
        let action = UIAlertAction(title: "Download", style: .default) { (action) in
            self.downloadService.startDownload(track)
            self.isDownloadPressed = true
            self.progress.completedUnitCount += 1
            let progressFloat = Float(self.progress.fractionCompleted)
            self.progressView.setProgress(progressFloat, animated: true)
            self.isDeletePressed = false
            self.isPlayPressed = false
            self.progressView.isHidden = false
        }
        
        let action1 = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.removeTrack(track: url)
            self.isDownloadPressed = false
            self.progressLabel.text = "Deleted"
            self.progressView.progress = 0
        }
        
        let action2 = UIAlertAction(title: "Play", style: .default) { (action) in
            self.playDownload(track)
            
        }
        
        if !self.isDownloadPressed {
            alertController.addAction(action)
            self.isDeletePressed = true
            self.isPlayPressed = true
            self.progressView.isHidden = true
        }
        
        if !self.isDeletePressed {
            alertController.addAction(action1)
        }
        
        if !self.isPlayPressed {
            alertController.addAction(action2)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func removeProgressView() {
        DispatchQueue.main.async{
            self.progressView.isHidden = true
            self.progressLabel.isHidden = true
        }
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [imgArray, lbl.text as Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true,completion: nil)
    }
    

    
    
    func populateUIWithModel() {
        if let unwrappedArtistInfo = self.artistDescription {
            self.lbl.text = unwrappedArtistInfo.imageTitle
            
            if !unwrappedArtistInfo.previewURL.isEmpty {
                self.eventCollectionView.reloadData()
            }
        }
    }
    
    
    @objc func changeImage() {
        
        if counter == imgArray.count {
            counter = 0
        }
        if counter < imgArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
            
        } else {
            counter = 1
            let index = IndexPath.init(item: counter, section: 0)
            self.eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
            
        }
        
    }
    
    func removeTrack(track: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: track)
        }
        catch let error as NSError {
            print("errror\(error)")
        }
    }
    
    
    func setUpLayout() {
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: eventCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 0.5
        flowLayout.spacingMode = .fixed(spacing: 42)
        self.eventCollectionView.collectionViewLayout = flowLayout
    }
    
    func textSetup() {
        self.trackName.text = "Track name - \(self.artistDescription?.trackName ?? "" )"
        self.collectionName.text = "Collection name - \(self.artistDescription?.collectionName ?? "" )"
    }
    
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func playDownload(_ track: JsonDataImage) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        
        let url = localFilePath(for: track.previewURLSong)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
}

extension DetailViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewEventCell
        //        let track = searchResults[indexPath.row]
        if let url = self.artistDescription?.previewURL[indexPath.row] {
            RequestsManager.downloadImage(from: url) { (data) in
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artistDescription?.previewURL.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fullScreenView = storyBoard.instantiateViewController(withIdentifier: "FullScreenView") as! FullScreenView
        fullScreenView.artistDescription = artistDescription!
        self.navigationController?.pushViewController(fullScreenView, animated: true)
    }
    
    
    
}

extension DetailViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else {
                print(downloadTask.originalRequest?.url?.absoluteString)
                print(downloadService.activeDownloads.map({ $0.value.track.previewURLSong }))
                return
        }
        
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        DispatchQueue.main.async {
            self.updateDisplay(progress: download.progress, totalSize: totalSize)
        }
    }
}


