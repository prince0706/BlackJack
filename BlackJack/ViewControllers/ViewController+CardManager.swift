//
//  ViewController+CardManager.swift
//  BlackJack
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import Foundation

extension ViewController: CardManagerDelegate {
    
    func disableActions(collectionType: CollectionType) {
        DispatchQueue.main.async {
            switch collectionType {
            case .player:
                self.PlayerActions.isUserInteractionEnabled = false
            case .split:
                self.splittedPlayerActions.isUserInteractionEnabled = false
            default:
                break
            }
        }
    }
    
    func reloadGame() {
        DispatchQueue.main.async {
            self.splitButton.isEnabled = true
            self.playerSplitHandCollectionView.isHidden = true
            self.playerSplittedHandLabel.isHidden = true
            self.splittedPlayerActions.isHidden = true
            self.PlayerActions.isUserInteractionEnabled = true
            self.splittedPlayerActions.isUserInteractionEnabled = true
            self.standButton.isEnabled = true
        }
    }
    
    func unhideSplit() {
        DispatchQueue.main.async {
            self.playerSplitHandCollectionView.isHidden = false
            self.playerSplittedHandLabel.isHidden = false
            self.splittedPlayerActions.isHidden = false
        }
    }
    
    func reloadCollection(collectionType: CollectionType) {
        DispatchQueue.main.async {
            switch collectionType {
            case .dealer:
                self.dealerHandCollectionView.reloadData()
            case .player:
                self.playerHandCollectionView.reloadData()
            case .split:
                self.playerSplitHandCollectionView.reloadData()
            }
        }
    }
    
}
