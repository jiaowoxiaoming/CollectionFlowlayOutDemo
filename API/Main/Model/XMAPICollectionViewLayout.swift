//
//  XMAPICollectionViewLayout.swift
//  API
//
//  Created by 郭建斌 on 16/5/16.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

protocol XMAPICollectionViewLayoutDelegate {
    func targetContentOffsetForProposedContentOffsetCaluEnd(index:Int) -> Void
}

class XMAPICollectionViewLayout: UICollectionViewFlowLayout {

    
    
    var itemWidth: CGFloat = 0.0
    
    var itemHeight: CGFloat = 0.0
    
    var delegate:XMAPICollectionViewLayoutDelegate?
    
    lazy var inset: CGFloat = {
        //这样设置，inset就只会被计算一次，减少了prepareLayout的计算步骤
        return  (self.collectionView?.bounds.width ?? 0)  * 0.5 - self.itemSize.width * 0.5
    }()
    
    override func prepareLayout() {
        
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    func initWithItemSize(size:CGSize,direction:UICollectionViewScrollDirection,minimumLineSpacing:CGFloat,delegate:XMAPICollectionViewLayoutDelegate) -> XMAPICollectionViewLayout {
        
        self.delegate = delegate
        
        self.itemWidth = size.width
        
        self.itemHeight = size.height
        
        self.itemSize = size
        
        self.scrollDirection = direction
        
        self.minimumLineSpacing = minimumLineSpacing
        
        return self
    }
    
    /**
     返回true只要显示的边界发生改变就重新布局:(默认是false)
     内部会重新调用prepareLayout和调用
     layoutAttributesForElementsInRect方法获得部分cell的布局属性
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        if elementKind == UICollectionElementKindSectionHeader {
            print(layoutAttributes?.frame)
        }
        return layoutAttributes
    }
    
    /**
     用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
     并返回。
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //取出rect范围内所有的UICollectionViewLayoutAttributes，然而
        //我们并不关心这个范围内所有的cell的布局，我们做动画是做给人看的，
        //所以我们只需要取出屏幕上可见的那些cell的rect即可
        let array = super.layoutAttributesForElementsInRect(rect)
        
        //可见矩阵
        let visiableRect = CGRectMake(self.collectionView!.contentOffset.x, self.collectionView!.contentOffset.y, self.collectionView!.frame.width, self.collectionView!.frame.height)
        
        //接下来的计算是为了动画效果
        let maxCenterMargin = self.collectionView!.bounds.width * 0.5 + itemWidth * 0.5;
        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5;
        for attributes in array! {
            //如果不在屏幕上，直接跳过
            if !CGRectIntersectsRect(visiableRect, attributes.frame) {continue}
           
            let scale = 1 + (0.2 - abs(centerX - attributes.center.x) / maxCenterMargin)
            
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
        }
        
        return array
    }
    
    /**
     用来设置collectionView停止滚动那一刻的位置
     
     - parameter proposedContentOffset: 原本collectionView停止滚动那一刻的位置
     - parameter velocity:              滚动速度
     
     - returns: 最终停留的位置
     */
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //实现这个方法的目的是：当停止滑动，时刻有一张图片是位于屏幕最中央的。
        
        let lastRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView!.frame.width, self.collectionView!.frame.height)
        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
        let centerX = proposedContentOffset.x + self.collectionView!.frame.width * 0.5;
        //这个范围内所有的属性
        let array = self.layoutAttributesForElementsInRect(lastRect)
        
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            if abs(attri.center.x - centerX) < abs(adjustOffsetX) {
                adjustOffsetX = attri.center.x - centerX;
            }
        }
    
        self.delegate?.targetContentOffsetForProposedContentOffsetCaluEnd(Int(( proposedContentOffset.x + adjustOffsetX ) * 2 / (self.collectionView?.bounds.size.width)!))
        
        return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y)
    }



}
