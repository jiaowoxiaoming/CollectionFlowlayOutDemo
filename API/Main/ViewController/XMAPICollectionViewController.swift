//
//  XMAPICollectionViewController.swift
//  API
//
//  Created by 郭建斌 on 16/5/16.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

private let reuseIdentifier = "XMAPICollectionViewCell"

class XMAPICollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,XMAPICollectionViewLayoutDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning,XMAPICollectionViewCellDelegate {

    var collectionViewInCell:UICollectionView?
    
    var indexPath: NSIndexPath?
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    var navigationOperation: UINavigationControllerOperation?
    var transitioningContext:UIViewControllerContextTransitioning?
    var transitioningView: UIView?
    var apiLayout:XMAPICollectionViewLayout!
    lazy var listDictionary: NSDictionary? = {
        var string = NSBundle.pathForResource("MobApiCategory", ofType: "plist", inDirectory: NSBundle.mainBundle().bundlePath)
       var dictionary = NSDictionary.init(contentsOfFile: string!)
        
       return dictionary
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "通用接口"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let layout:XMAPICollectionViewLayout = XMAPICollectionViewLayout()
        layout.delegate = self
        layout.initWithItemSize(CGSizeMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height - 64 + 49) / 2), direction: .Horizontal, minimumLineSpacing: 0, delegate: self)
        
        self.collectionView?.collectionViewLayout = layout
        self.apiLayout = layout
        // Do any additional setup after loading the view.
        
        self.navigationController?.delegate = self
        
        let  screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("handlePopRecognizer:"))
        
        screenEdgePanGestureRecognizer.edges = UIRectEdge.Left
        
        self.navigationController!.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    func handlePopRecognizer(screenEdgePanGestureRecognizer:UIScreenEdgePanGestureRecognizer) -> Void {
        
        let point = screenEdgePanGestureRecognizer.translationInView(self.navigationController?.view).x
        var progress:CGFloat!
        
        let width = self.view.bounds.size.width
        
        progress = point / width
        
        
        progress = min(1.0, max(0.0, progress))
        
        if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Began {

            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Changed
        {
            self.interactivePopTransition.updateInteractiveTransition(progress)
            //            updateInteractiveTransition(progress)
        }
        else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Ended || screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Cancelled
        {
            if progress > 0.5 {
                self.interactivePopTransition.finishInteractiveTransition()
                self.interactivePopTransition = nil
            }
            else
            {
                self.interactivePopTransition.cancelInteractiveTransition()
                self.interactivePopTransition = nil
            }
            self.interactivePopTransition = nil
            //            finishBy(progress < 0.5)
            //            isTransiting = false
        }
        
        
    }
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //
        //        if !self.isTransiting {
        //            return nil
        //        }
        //
        //        return self
        
        if  self.interactivePopTransition == nil {
            return nil
        }
        return self.interactivePopTransition
    }
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitioningContext = transitionContext
        
        let containerView = transitioningContext!.containerView()
        
        let toViewController = transitioningContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromViewController = transitioningContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        containerView?.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
        
        self.transitioningView = fromViewController?.view
    }
    
    
    func updateInteractiveTransition(percentComplete: CGFloat)
    {
        let scale = CGFloat(fabs(percentComplete - CGFloat(1.0)))
        //        print(scale)
        self.transitioningView?.transform = CGAffineTransformMakeScale(scale, scale)
        transitioningContext?.updateInteractiveTransition(percentComplete)
    }
    
    func finishBy(cancelled:Bool) -> Void {
        if cancelled {
            UIView.animateWithDuration(0.5, animations: {
                self.transitioningView!.transform = CGAffineTransformIdentity
                }, completion: ({
                    completed in
                    self.transitioningContext!.cancelInteractiveTransition()
                    self.transitioningContext!.completeTransition(false)
                }))
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.transitioningView!.transform = CGAffineTransformMakeScale(0, 0)
                }, completion: ({
                    completed in
                    self.transitioningContext!.finishInteractiveTransition()
                    self.transitioningContext!.completeTransition(true)
                    
                }))
        }
        
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        navigationOperation = operation
        
        return self
        
    }
//    MARK:-
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var detailVC: XMAPIDetailViewController!
        var fromView: UIView!
        var alpha: CGFloat = 1.0
        var destTransform: CGAffineTransform!
        
        var snapshotImageView: UIView!
        //获取到当前选择的Cell
        let originalView = (self.collectionViewInCell!.cellForItemAtIndexPath(self.indexPath!) as! XMDetailCollectionViewCell).detailListLabel
        
        if navigationOperation == UINavigationControllerOperation.Push {
            containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            snapshotImageView = originalView.snapshotViewAfterScreenUpdates(false)
            detailVC = toViewController as! XMAPIDetailViewController
            fromView = fromViewController.view
            alpha = 0
            detailVC.view.transform = CGAffineTransformMakeScale(0.99, 0.99)
            destTransform = CGAffineTransformMakeScale(1, 1)
            
            snapshotImageView.frame = self.view!.convertRect(originalView!.frame, fromView: self.collectionViewInCell?.cellForItemAtIndexPath(self.indexPath!))
            
            print(snapshotImageView.frame)
            
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            detailVC = fromViewController as! XMAPIDetailViewController
            
            snapshotImageView = detailVC.navigationItem.titleView?.snapshotViewAfterScreenUpdates(false)
            
            fromView = toViewController.view
            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将会不被执行(不确定是哪里的Bug)
            destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            
            snapshotImageView.frame = detailVC.navigationItem.titleView!.frame
            
        }
        originalView?.hidden = true
        detailVC.navigationItem.titleView?.hidden = true
        
        containerView.addSubview(snapshotImageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            detailVC.view.transform = destTransform
            if CGAffineTransformIsIdentity(detailVC.view.transform)
            {
                detailVC.view.alpha = 1;
            }
            else
            {
                detailVC.view.transform = CGAffineTransformIdentity
                detailVC.view.alpha = 0;
            }
            fromView.alpha = alpha
            
            if self.navigationOperation == UINavigationControllerOperation.Push {
                
//                UIView.animateWithDuration(0.35, animations: {
//                    detailVC.view.layoutIfNeeded()
//                })
                
//                snapshotImageView.frame = CGRectMake(0, 64 - snapshotImageView.bounds.size.height / 2, snapshotImageView.bounds.size.width, snapshotImageView.bounds.size.height)
                detailVC.navigationItem.titleView = snapshotImageView
                
            } else if self.navigationOperation == UINavigationControllerOperation.Pop {
                snapshotImageView.frame = self.view!.convertRect(originalView!.frame, fromView: self.collectionViewInCell?.cellForItemAtIndexPath(self.indexPath!))
            }
            }, completion: ({completed in
                originalView?.hidden = false
                detailVC.navigationItem.titleView?.hidden = false
                

                
                if self.navigationOperation == UINavigationControllerOperation.Push{
                    let titleView = UILabel.init()
                    titleView.center = (detailVC.navigationController?.navigationBar.center)!
                    titleView.text = originalView.text
                    titleView.sizeToFit()
                    
                    detailVC.navigationItem.titleView = titleView
                    
                }
                snapshotImageView.removeFromSuperview()
                //告诉系统你的动画过程已经结束，这是非常重要的方法，必须调用。
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func targetContentOffsetForProposedContentOffsetCaluEnd(index:Int) -> Void{
        
        self.navigationItem.title = listDictionary!["ApiCategory"]!["SectionTitlesArray"]!!.objectAtIndex(index) as? String
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

//        cell.backgroundColor = UIColor().randColor();
        // Configure the cell
        cell.delegate = self
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var view: XMAPICollectionReusableHeaderView?
        if kind == UICollectionElementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "XMAPICollectionReusableHeaderView", forIndexPath: indexPath) as? XMAPICollectionReusableHeaderView
        }
        return view!
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath , cell: XMDetailCollectionViewCell)
    {
        collectionViewInCell = collectionView
        
        self.indexPath = indexPath;
        
        self.navigationController?.pushViewController(XMAPIDetailViewController(), animated: true);
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
