//
//  IventListTableTableViewController.swift
//  ConcertApp
//
//  Created by Misha on 8/5/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit



struct Event {
    var name: String
    var imageName: String
    var textName: String
    
}

class EventListTableViewController: UIViewController {
    
    var eventsList = [Event(name: "Beyoncé", imageName: "Beyoncé", textName: "Beyoncé Giselle Knowles-Carter  born September 4, 1981) is an American singer, songwriter and actress. Born and raised in Houston, Texas, Beyoncé performed in various singing and dancing competitions as a child. She rose to fame in the late 1990s as lead singer of the R&B girl-group Destiny's Child, one of the best-selling girl groups in history. Their hiatus saw the release of her first solo album, Dangerously in Love (2003), which debuted at number one on the US Billboard 200 chart and earned her five Grammy Awards. The album also featured the US Billboard Hot 100 number-one singles Crazy in Love and Baby Boy."), Event(name: "David guetta", imageName: "David guetta", textName: "lol"),Event(name: "Ariana Grande", imageName: "Ariana Grande", textName: "lol"), Event(name: "Drake", imageName: "Drake", textName: "lol"), Event(name: "eminem", imageName: "eminem", textName: "lol")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension EventListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectio: Int) -> Int {
        return eventsList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            EventTableViewCell else { return UITableViewCell() }
        
        cell.lbl.text = eventsList[indexPath.row].name
        cell.img.image = UIImage(named: eventsList[indexPath.row].imageName)
        
        return cell
    }
    
    

           
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.event = eventsList[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
