//
//  XMAPICollectionViewCell.swift
//  API
//
//  Created by 郭建斌 on 16/5/16.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit



class XMAPICollectionViewCell: UICollectionViewCell ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XMWaterFallFlowLayoutDelegate {
    

    var detailListArray:NSArray? = nil
        {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let detailReuseIdentifier = "detailCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        self.collectionView.backgroundColor = UIColor.brownColor()
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
//        print(cell)
        cell.detailListLabel.text = detailListArray?.objectAtIndex(indexPath.row) as? String
//        let remainder :Int = indexPath.row%colletionCell
//        
//        let currentRow :Int = indexPath.row/colletionCell
//        
//        let currentHeight :CGFloat = hArr[indexPath.row]
//        
//        let positonX = CGFloat( (Int(wd) / colletionCell - 10) * remainder + 5 * (remainder + 1) )
//        
//        var positionY = CGFloat((currentRow+1)*5)
//        
//        for i in 0..<currentRow{
//            
//            let position = remainder + i * colletionCell
//            
//            positionY += hArr[position]
//            
//        }
//        
//        cell.frame=CGRectMake(positonX, positionY,CGFloat(Int(wd)/colletionCell - 10),currentHeight) //重新定义cell位置、宽高
        

        return cell
    }
    
    func waterFlowViewLayout(waterFlowViewLayout: XMWaterFallFlowLayout, heightForWidth: CGFloat, atIndextPath: NSIndexPath) -> CGFloat {
        let b = arc4random()%80 + 80
        return CGFloat(b)
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
