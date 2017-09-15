//
//  MoviesViewController.swift
//  Flixter
//
//  Created by Lia Zadoyan on 9/12/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var viewTab: UISegmentedControl!
    
    var movies: [Movie]?
    
    var filteredMovies: [Movie]?
    
    var endpoint: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.titleView = self.searchBar;
        collectionView.isHidden = true
        
        fetchMovies(refreshControl)
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies(refreshControl)
    }
    
    func fetchMovies(_ refreshControl: UIRefreshControl) {
        self.alertView.isHidden = true
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let results = responseDictionary["results"] as? NSArray {
                        var allMovies: [Movie] = []
                        for movieResponse in results as! [NSDictionary] {
                            allMovies.append(Movie(data: movieResponse))
                        }
                        self.movies = allMovies
                        self.filteredMovies = self.movies
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                }
            } else if error != nil {
                self.alertView.isHidden = false
                self.tableView.bringSubview(toFront: self.alertView)
                
            }
            refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie.title
        let overview = movie.overview
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.selectionStyle = .none
        
        if let posterPath = movie.highResPoster {
            let imageUrl = URL(string: posterPath)
            let imageRequest = URLRequest(url: (imageUrl)!)
            cell.posterView.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    if imageResponse != nil {
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        cell.posterView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie.title
        
        cell.title.text = title
        
        if let posterPath = movie.highResPoster {
            let imageUrl = URL(string: posterPath)
            let imageRequest = URLRequest(url: (imageUrl)!)
            cell.posterImage.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    if imageResponse != nil {
                        cell.posterImage.alpha = 0.0
                        cell.posterImage.image = image
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            cell.posterImage.alpha = 1.0
                        })
                    } else {
                        cell.posterImage.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        return cell
        
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        search(searchText: "")
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var indexPath: IndexPath?
        var movie: Movie?
        if viewTab.selectedSegmentIndex == 0 {
            let cell = sender as! UITableViewCell
            indexPath = tableView.indexPath(for: cell)
            movie = filteredMovies![indexPath!.row]
        } else {
            let cell = sender as! UICollectionViewCell
            indexPath = collectionView.indexPath(for: cell)
            movie = filteredMovies![indexPath!.row]
        }
        let detailVieWController = segue.destination as! DetailViewController
        detailVieWController.movie = movie

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText);
    }
    
    func search(searchText: String) {
        self.filteredMovies = searchText.isEmpty ? movies : movies?.filter { (item: Movie) -> Bool in
            if let title = item.title {
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            return false
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    @IBAction func viewTypeChosen(_ sender: Any) {
        if (viewTab.selectedSegmentIndex == 0) {
            collectionView.isHidden = true
            tableView.isHidden = false
        } else {
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }

}
