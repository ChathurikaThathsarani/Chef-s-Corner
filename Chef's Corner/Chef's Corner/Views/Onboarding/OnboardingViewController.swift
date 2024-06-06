//
//  OnboardingViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-01.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
    // Create UIImage instances using UIImage(named:) initializer
    let image1 = UIImage(named: "image1")
    let image2 = UIImage(named: "image2")
    let image3 = UIImage(named: "image3")
    
    var slidesForOnborading: [OnboardingObject] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slidesForOnborading.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slidesForOnborading = [
            OnboardingObject(title: "Welcome to Chef's Corner", description: "Explore diverse cuisines, master culinary skills, and savor delightful flavors", image: image1!),
            OnboardingObject(title: "Try out our new recipes", description: "Unlock a world of gastronomic delights, hone your cooking prowess, and delight your taste buds.", image:image2!),
            OnboardingObject(title: "Share your cooking skills", description: "Embark on a culinary journey, perfect your kitchen craft, and enjoy your life", image:image3!)
            
        ]
        
        pageControl.numberOfPages = slidesForOnborading.count
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Invalidate collection view layout on device rotation
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if currentPage == slidesForOnborading.count - 1 {
            if let controller = storyboard?.instantiateViewController(identifier: "loginViewController") {
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                present(controller, animated: true, completion: nil)
            }
        } else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section:0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated:true)
        }
    }
}

extension OnboardingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slidesForOnborading.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.slideSetup(slidesForOnborading[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}
