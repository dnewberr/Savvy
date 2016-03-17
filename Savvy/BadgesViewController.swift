//
//  BadgesViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
}

class BadgesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var badgesCollectionView: UICollectionView!
    var user: UserModel!
    var badges: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBadges()
        // Do any additional setup after loading the view.
    }
    
    func getBadges() {
        badges = user.getBadges()
        badgesCollectionView.dataSource = self
        badgesCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    // Sets up the cells. The terms are shown initially.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeCell", forIndexPath: indexPath) as! BadgeCollectionViewCell
        cell.badgeName.text = badges[indexPath.row]
        cell.badgeImage.image = UIImage(named: badges[indexPath.row])
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
