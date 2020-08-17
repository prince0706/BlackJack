//
//  ViewController+CollectionView.swift
//  BlackJack
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == playerHandCollectionView {
            return CardManager.shared.playerCards.count
        } else if collectionView == dealerHandCollectionView {
            return CardManager.shared.dealerCards.count
        } else if collectionView == playerSplitHandCollectionView {
            return CardManager.shared.splittedCards.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.cardCell, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == playerHandCollectionView {
            cell.cardImageView.image = CardManager.shared.playerCards[indexPath.item].image()
        } else if collectionView == dealerHandCollectionView {
            cell.cardImageView.image = CardManager.shared.dealerCards[indexPath.item].image()
        } else if collectionView == playerSplitHandCollectionView {
            cell.cardImageView.image = CardManager.shared.splittedCards[indexPath.item].image()
        }
        
        return cell
    }
    
}
