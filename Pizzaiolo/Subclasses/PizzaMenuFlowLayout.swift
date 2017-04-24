//
//  PizzaMenuFlowLayout.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 13/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

/*
 Implemented from Karmadust
 http://blog.karmadust.com/centered-paging-with-preview-cells-on-uicollectionview/
 */

class PizzaMenuFlowLayout: UICollectionViewFlowLayout {
    
    var mostRecentOffset: CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if velocity.x == 0 {
            return mostRecentOffset
        }
        
        if let cv = self.collectionView {
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if (attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0) {
                        continue
                    }
                    
                    candidateAttributes = attributes
                }
                
                if proposedContentOffset.x == -(cv.contentInset.left) {
                    return proposedContentOffset
                }
                
                guard let _ = candidateAttributes else {
                    return mostRecentOffset
                }
                
                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                
                return mostRecentOffset
            }
        }
        
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        
        return mostRecentOffset
    }
    
}
