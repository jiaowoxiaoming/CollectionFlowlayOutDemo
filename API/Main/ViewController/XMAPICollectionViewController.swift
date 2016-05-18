//
//  XMAPICollectionViewController.swift
//  API
//
//  Created by 郭建斌 on 16/5/16.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

private let reuseIdentifier = "XMAPICollectionViewCell"

class XMAPICollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,XMAPICollectionViewLayoutDelegate {

    var apiLayout:XMAPICollectionViewLayout!
    lazy var listDictionary: NSDictionary? = {
        var string = NSBundle.pathForResource("MobApiCategory", ofType: "plist", inDirectory: NSBundle.mainBundle().bundlePath)
       var dictionary = NSDictionary.init(contentsOfFile: string!)
        
       return dictionary
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let layout:XMAPICollectionViewLayout = XMAPICollectionViewLayout()
        
        layout.initWithItemSize(CGSizeMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height - 64 + 49) / 2), direction: .Horizontal, minimumLineSpacing: 0, delegate: self)
        
        self.collectionView?.collectionViewLayout = layout
        self.apiLayout = layout
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listDictionary!["ApiCategory"]!["SectionTitlesArray"]!!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:XMAPICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! XMAPICollectionViewCell
    
        cell.detailListArray = listDictionary!["ApiCategory"]!["CellTitlesArray"]!!.objectAtIndex(indexPath.row) as? NSArray
        
        
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var view: XMAPICollectionReusableHeaderView?
        if kind == UICollectionElementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "XMAPICollectionReusableHeaderView", forIndexPath: indexPath) as? XMAPICollectionReusableHeaderView
        }
        return view!
    }

//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        if self.collectionView!.collectionViewLayout.isKindOfClass(XMAPICollectionViewLayout.self) {
//            self.collectionView!.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
//        }else {
//            self.collectionView!.setCollectionViewLayout(self.apiLayout, animated: true)
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//
//        
//    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
