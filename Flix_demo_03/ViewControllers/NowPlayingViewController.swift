//
//  NowPlayingViewController.swift
//  Flix_demo_03
//
//  Created by Jetry Dumont on 9/17/18.
//  Copyright © 2018 Wendy Jean. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movies:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 170
        tableView.estimatedRowHeight = 220
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (NowPlayingViewController.didPullToRefresh(_:)), for:. valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self 
        fecthMovies()
        
        }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fecthMovies()
    }
    
    func  fecthMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .
            reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default,
                                 delegate:nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization .jsonObject(with: data,options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.tableView.reloadData()
                
            }
            
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
        return movies.count
    }
        func tableView(_ tableView: UITableView,
cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
      let cell = tableView
            .dequeueReusableCell(withIdentifier:
            "MovieCell",  for: indexPath) as! MovieCell
            
      let movie = movies[indexPath.row]
      let title = movie["title"] as! String
      let overview = movie["overview"] as! String
      cell.titlelLabel.text = title
      cell.overview_Label.text = overview
            
      let posterPathString = movie["poster_path"] as! String
      let baseURLString = "https://image.tmdb.org/t/p/w500"
            
      let posterURL = URL(string: baseURLString + posterPathString)!
      cell.posterImageView.af_setImage(withURL : posterURL)
      return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
        let movie = movies[indexPath.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
