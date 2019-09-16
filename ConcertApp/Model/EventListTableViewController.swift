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
    
    var eventList: [ArtistModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
     let defaultSession = URLSession(configuration: .default)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateModels()
        
    }
    

    
    func populateModels() {
        let firstConcertDetail = ConcertDetails(concertName: "Beyonce", concertInfo: "Beyoncé Giselle Knowles-Carter  born September 4, 1981) is an American singer, songwriter and actress. Born and raised in Houston, Texas, Beyoncé performed in various singing and dancing competitions as a child. She rose to fame in the late 1990s as lead singer of the R&B girl-group Destiny's Child, one of the best-selling girl groups in history. Their hiatus saw the release of her first solo album, Dangerously in Love (2003), which debuted at number one on the US Billboard 200 chart and earned her five Grammy Awards. The album also featured the US Billboard Hot 100 number-one singles Crazy in Love and Baby Boy.", concertImageNames: ["Beyoncé","beyonce1","beyonce2"])
        let first = ArtistModel(artistName: "Beyonce", imageName: "Beyoncé", concertDetails: firstConcertDetail, imageURLString: nil)
        
        let secondConcertDatail = ConcertDetails(concertName: "David Guetta", concertInfo: "Pierre David Guetta (French pronunciation born 7 November 1967) is a French DJ, music programmer, record producer and songwriter. He has sold over nine million albums and thirty million singles worldwide. In 2011, Guetta was voted as the number one DJ in the DJ Mag Top 100 DJs poll. In 2013, Billboard crowned When Love Takes Over as the number one dance-pop collaboration of all time.", concertImageNames: ["David guetta", "david", "david1"])
        let second = ArtistModel(artistName: "DavidGuetta", imageName: "David guetta", concertDetails: secondConcertDatail, imageURLString: nil)
        
        
        let thirdConcertDetail = ConcertDetails(concertName: "eminem", concertInfo: "Marshall Bruce Mathers III (born October 17, 1972), known professionally as Eminem , is an American rapper, songwriter, record producer, record executive, film producer, and actor. He is consistently cited as one of the greatest and most influential rappers of all time and was labeled the King of Hip Hop by Rolling Stone magazine. In addition to his solo career, Eminem was a member of the hip hop group D12. He is also known for his collaborations with fellow Detroit-based rapper Royce the two are collectively known as Bad Meets Evil.", concertImageNames: ["eminem", "eminem1", "eminem2"])
        let third = ArtistModel(artistName: "Eminem", imageName: "eminem", concertDetails: thirdConcertDetail, imageURLString: nil)
        
        let fourthConcertDetail = ConcertDetails(concertName: "Drake", concertInfo: "Aubrey Drake Graham (born October 24, 1986) is a Canadian rapper, singer, songwriter, record producer, actor, and entrepreneur. As an entrepreneur, Drake has founded the OVO Sound record label with longtime collaborator 40. Drake gained recognition as an actor on the teen drama television series Degrassi: The Next Generation in the early 2000s. Intent on pursuing a career in music, he left the series in 2007 after releasing his debut mixtape, Room for Improvement. He released two further independent projects, Comeback Season and So Far Gone, before signing to Lil Wayne's Young Money Entertainment in June 2009.", concertImageNames:["Drake","drake1", "drake2"])
        let fourth = ArtistModel(artistName: "Drake", imageName: "Drake", concertDetails: fourthConcertDetail, imageURLString: nil)
        
        let fifthConcertDetail = ConcertDetails(concertName: "Ariana Grande", concertInfo: "Ariana Grande-Butera is an American singer, songwriter, and actress. A multi-platinum, Grammy Award-winning recording artist, she is known for her wide vocal range, which critics have often compared to that of Mariah Carey. Born in Boca Raton, Florida, Grande began her career in 2008 in the Broadway musical, 13. She rose to prominence for her role as Cat Valentine in the Nickelodeon television series, Victorious (2010–2013) and in its spin-off, Sam & Cat (2013–2014). As she grew interested in pursuing a music career, Grande recorded songs for the soundtrack of Victorious and signed with Republic Records in 2011 after the label's executives discovered videos of her covering songs that she uploaded onto YouTube. She released her debut album, Yours Truly, in 2013. A 1950s doo-wop-influenced pop and R&B album, it debuted atop the US Billboard 200 and spawned her first US top-ten single, The Way, featuring rapper Mac Miller.", concertImageNames: ["Ariana Grande","ariana", "ariana1"])
        let fifth = ArtistModel(artistName: "ArianaGrande", imageName: "Ariana Grande", concertDetails: fifthConcertDetail, imageURLString: nil)
        
        let artistArray = [first,second,third,fourth,fifth]
        self.eventList = artistArray
        artistArray.enumerated().forEach { (index, artist) in
            RequestsManager.shared.getImageURLString(with: artist.artistName, completion: { (artistImageURLString) in
                self.eventList?[index].imageURLString = artistImageURLString
    
            })
        }
    
        self.eventList = artistArray
    }
    
    func getImagesFromBackend() {
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=Beyonce"
            // 3
            guard let url = urlComponents.url else {
                return
            }
            defaultSession.dataTask(with: url) { (data, response, error) in
                print()
            }
        }
    }
    
}


extension EventListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectio: Int) -> Int {
        return self.eventList?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            EventTableViewCell else { return UITableViewCell() }
        
        if let list = eventList {
            cell.lbl.text = list[indexPath.row].artistName
            cell.img.image = UIImage(named:list[indexPath.row].imageName)
            if let imageUnwrapped = list[indexPath.row].imageURLString, let imageURL = URL(string: imageUnwrapped) {
            SDWebImageManager.shared.loadImage(with: imageURL, options: .highPriority, progress: nil, completed: { (image, _, _, _, _, _) in
                DispatchQueue.main.async {
                cell.img.image = image
                    
                }
                })
            }
            
        }

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        if let list = eventList {
            vc?.eventImageNames = list[indexPath.row].concertDetails
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
