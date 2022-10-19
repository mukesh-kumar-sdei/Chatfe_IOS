//
//  OnboardingCollectionViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    @IBOutlet weak var slideImageView: UIImageView!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
    }
    
}
