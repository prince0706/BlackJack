//
//  Constants+Enums.swift
//  BlackJack
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import UIKit

enum Card: String, CaseIterable {
//    case blankCard = "BlankCard"
    
    case aceSpade = "Ace-Spade"
    case twoSpade = "Two-Spade"
    case threeSpade = "Three-Spade"
    case fourSpade = "Four-Spade"
    case fiveSpade = "Five-Spade"
    case sixSpade = "Six-Spade"
    case sevenSpade = "Seven-Spade"
    case eightSpade = "Eight-Spade"
    case nineSpade = "Nine-Spade"
    case tenSpade = "Ten-Spade"
    case jackSpade = "Jack-Spade"
    case queenSpade = "Queen-Spade"
    case kingSpade = "King-Spade"
    
    case aceDiamond = "Ace-Diamond"
    case twoDiamond = "Two-Diamond"
    case threeDiamond = "Three-Diamond"
    case fourDiamond = "Four-Diamond"
    case fiveDiamond = "Five-Diamond"
    case sixDiamond = "Six-Diamond"
    case sevenDiamond = "Seven-Diamond"
    case eightDiamond = "Eight-Diamond"
    case nineDiamond = "Nine-Diamond"
    case tenDiamond = "Ten-Diamond"
    case jackDiamond = "Jack-Diamond"
    case queenDiamond = "Queen-Diamond"
    case kingDiamond = "King-Diamond"

    case aceClub = "Ace-Club"
    case twoClub = "Two-Club"
    case threeClub = "Three-Club"
    case fourClub = "Four-Club"
    case fiveClub = "Five-Club"
    case sixClub = "Six-Club"
    case sevenClub = "Seven-Club"
    case eightClub = "Eight-Club"
    case nineClub = "Nine-Club"
    case tenClub = "Ten-Club"
    case jackClub = "Jack-Club"
    case queenClub = "Queen-Club"
    case kingClub = "King-Club"
    
    case aceHeart = "Ace-Heart"
    case twoHeart = "Two-Heart"
    case threeHeart = "Three-Heart"
    case fourHeart = "Four-Heart"
    case fiveHeart = "Five-Heart"
    case sixHeart = "Six-Heart"
    case sevenHeart = "Seven-Heart"
    case eightHeart = "Eight-Heart"
    case nineHeart = "Nine-Heart"
    case tenHeart = "Ten-Heart"
    case jackHeart = "Jack-Heart"
    case queenHeart = "Queen-Heart"
    case kingHeart = "King-Heart"
    
    func image() -> UIImage? {
        return UIImage(named: rawValue)
    }
    
}

enum CollectionType {
    case player
    case dealer
    case split
}

enum PlayerAction {
    case none
    case hit
    case split
    case stand
    case surrender
}
