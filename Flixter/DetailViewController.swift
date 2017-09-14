//
//  DetailViewController.swift
//  Flixter
//
//  Created by Lia Zadoyan on 9/12/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
      
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            let imageRequest = URLRequest(url: (imageUrl)!)
            self.posterImageView.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    } else {
                        self.posterImageView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
