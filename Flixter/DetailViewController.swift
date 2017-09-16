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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie.title
        titleLabel.text = title
        
        let overview = movie.overview
        overviewLabel.text = overview
        
        let smallImageRequest = URLRequest(url: URL(string: movie.lowResPoster!)! as URL)
        let largeImageRequest = URLRequest(url: URL(string: movie.highResPoster!)! as URL)
        
        self.posterImageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage;
                
                UIView.animate(withDuration:0.3, animations: { () -> Void in
                    
                    self.posterImageView.alpha = 1.0
                    
                }, completion: { (success) -> Void in
                    self.posterImageView.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.posterImageView.image = largeImage;
                            
                        }
                    )}
                )
        })
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
