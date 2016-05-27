//
//  XMAPICollectionViewCell.swift
//  API
//
//  Created by 郭建斌 on 16/5/16.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

protocol XMAPICollectionViewCellDelegate:NSObjectProtocol
{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath , cell: XMDetailCollectionViewCell)
}

class XMAPICollectionViewCell: UICollectionViewCell ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XMWaterFallFlowLayoutDelegate{
    
    weak var delegate:XMAPICollectionViewCellDelegate?
    
    var detailListArray:NSArray? = nil
        {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let detailReuseIdentifier = "detailCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        self.collectionView.backgroundColor = UIColor.clearColor()
//        self.collectionView.registerClass(XMDetailCollectionViewCell.self, forCellWithReuseIdentifier: detailReuseIdentifier)
        
        let layout:XMWaterFallFlowLayout = self.collectionView.collectionViewLayout as! XMWaterFallFlowLayout
        
        layout.delegate = self
        
//        layout.columnWidth = self.bounds.size.width
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return (detailListArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:XMDetailCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(detailReuseIdentifier, forIndexPath: indexPath) as! XMDetailCollectionViewCell

        cell.detailListLabel.text = detailListArray?.objectAtIndex(indexPath.row) as? String
        
        cell.contentView.backgroundColor = UIColor().randColor()
        

        return cell
    }
    
    func waterFlowViewLayout(waterFlowViewLayout: XMWaterFallFlowLayout, heightForWidth: CGFloat, atIndextPath: NSIndexPath) -> CGFloat {
        let b = arc4random()%80 + 80
        return CGFloat(b)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if self.delegate?.respondsToSelector(Selector("collectionView:didSelectItemAtIndexPath:cell:")) == true
        {
            self.delegate?.collectionView(collectionView, didSelectItemAtIndexPath: indexPath, cell: collectionView.cellForItemAtIndexPath(indexPath) as! XMDetailCollectionViewCell)
        }
        
    }
    

    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
////        let a = arc4random()%80
//        
//        let b = arc4random()%80 + 80
//        
//        hArr.append(CGFloat(b))
//        
//        return CGSizeMake(50, CGFloat(b))
//    }
    
}
