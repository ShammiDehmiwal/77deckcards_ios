//
//  HomeVC+Extension.swift
//  77DeckCards
//
//  Created by Himanshu Singla on 27/05/18.
//  Copyright © 2018 Creations. All rights reserved.
//

import UIKit
import SDWebImage


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
        let card = arrCards[indexPath.item]
       // cell.imgViewCard.sd_setImage(with: URL(string: card.image ?? "https://pasteboard.co/J8iANZV.png"), placeholderImage: UIImage(named: "splash"))//UIImage(named: card.image)
        cell.imgViewCard.image = UIImage(named: card.image!)
        
        
        cell.lblCardName.text = card.name
        
        //cell.imgViewSmallCard.sd_setImage(with: URL(string: card.image ?? "https://pasteboard.co/J8iANZV.png"), placeholderImage: UIImage(named: "splash"))//UIImage(named: card.image)       //.image = UIImage(named: card.image)
        cell.imgViewSmallCard.image = UIImage(named: card.image!)
        
        
        //cell.txtViewDesc.text = card.desc
        cell.lblDesc.text = card.desc
        
       // cell.viewSmallerCard.addShadow(offset: CGSize(width: 1, height: 1), color: .lightGray, radius: 1.0, opacity: 0.5)
        

        if indexPath.item == flippedIndex {
            cell.view2.isHidden = false
            btnOptions.isHidden = false
            cell.view1.isHidden = true
        } else {
            cell.view2.isHidden = true
            btnOptions.isHidden = true
            cell.view1.isHidden = false
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: clctnViewCards.contentOffset, size: clctnViewCards.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = clctnViewCards.indexPathForItem(at: visiblePoint) {
            let card = arrCards[indexPath.item]
            selectedIndex = indexPath.item
            lblTitle.text = card.name
            
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        resetFlips()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let flippedTempIndex = flippedIndex else   {
            let cell = collectionView.cellForItem(at: indexPath) as! HomeCVC
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            
            UIView.transition(with:  cell.view1, duration: 1.0, options: transitionOptions, animations: {
                cell.view1.isHidden = true
            })
            
            UIView.transition(with:  cell.view2, duration: 1.0, options: transitionOptions, animations: {
                cell.view2.isHidden = false
                
                self.btnOptions.isHidden = false
            })
            flippedIndex = indexPath.item
            return
        }
        if flippedTempIndex == indexPath.item {
            let cell = clctnViewCards.cellForItem(at: indexPath) as! HomeCVC
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
            UIView.transition(with:  cell.view1, duration: 1.0, options: transitionOptions, animations: {
                cell.view2.isHidden = true
                
                self.btnOptions.isHidden = true
            })
            
            UIView.transition(with:  cell.view2, duration: 1.0, options: transitionOptions, animations: {
                cell.view1.isHidden = false
            })
            flippedIndex = nil
            return 
        }
      
    }
    
}
