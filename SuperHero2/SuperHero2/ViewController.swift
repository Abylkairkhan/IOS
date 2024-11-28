import UIKit
import Kingfisher

class ViewController: UIViewController, HeroServiceDelegate {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroGender: UILabel!
    @IBOutlet weak var heroPower: UILabel!
    @IBOutlet weak var heroSpeed: UILabel!
    @IBOutlet weak var heroWeight: UILabel!
    @IBOutlet weak var heroEyeColor: UILabel!
    @IBOutlet weak var heroHairColor: UILabel!
    @IBOutlet weak var heroRace: UILabel!
    @IBOutlet weak var heroPlace: UILabel!
    
    private var shimmerLayers: [CALayer] = []
    
    var heroService = HeroService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroService.delegate = self
        startShimmerAnimation()
        heroService.getHeroList()
    }

    @IBAction func getHeroClick(_ sender: Any) {
        startShimmerAnimation()
        heroService.getHeroList()
    }
    
    func onHeroDidUpdate(hero: HeroModel) {
        configure(hero: hero)
        stopShimmerAnimation()
    }
    
    func errorHappened(message: String) {
        heroName.text = message
    }
    
    private func configure(hero: HeroModel) {
        guard let imageUrl = URL(string: hero.images?.sm ?? "") else { return }
        heroImage.kf.setImage(with: imageUrl)
        heroName.text = "Name: " + (hero.name ?? "Unknown Hero")
        heroGender.text = "Gender: " + (hero.appearance?.gender ?? "Unknown")
        heroPower.text = "Power: " + (hero.powerstats?.power?.description ?? "Unknown")
        heroSpeed.text = "Speed: " + (hero.powerstats?.speed?.description ?? "Unknown")
        heroWeight.text = "Weight: " + (hero.appearance?.weight?.joined(separator: ", ") ?? "Unknown")
        heroEyeColor.text = "Eye Color: " + (hero.appearance?.eyeColor ?? "-")
        heroHairColor.text = "Hair Color: " + (hero.appearance?.hairColor ?? "Unknown")
        heroRace.text = "Race: " + (hero.appearance?.race ?? "Unknown")
        heroPlace.text = "Place of Birth: " + (hero.biography?.placeOfBirth ?? "Unknown")
    }
    
    private func clearHeroData() {
        heroImage.image = nil
        heroName.text = "   "
        heroGender.text = "   "
        heroPower.text = "   "
        heroSpeed.text = "   "
        heroWeight.text = "   "
        heroEyeColor.text = "   "
        heroHairColor.text = "   "
        heroRace.text = "   "
        heroPlace.text = "   "
    }
    
    // MARK: - Shimmer Animation
    private func startShimmerAnimation() {
        clearHeroData()
        
        let shimmerColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            shimmerColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            shimmerColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = heroImage.bounds
        
        // Add animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        
        // Add shimmer to all views
        addShimmer(to: heroImage, with: gradientLayer)
        addShimmer(to: heroName)
        addShimmer(to: heroGender)
        addShimmer(to: heroPower)
        addShimmer(to: heroSpeed)
        addShimmer(to: heroWeight)
        addShimmer(to: heroEyeColor)
        addShimmer(to: heroHairColor)
        addShimmer(to: heroRace)
        addShimmer(to: heroPlace)
    }
    
    private func stopShimmerAnimation() {
        shimmerLayers.forEach { $0.removeFromSuperlayer() }
        shimmerLayers.removeAll()
    }
    
    private func addShimmer(to view: UIView, with layer: CALayer? = nil) {
        let shimmerLayer = layer ?? {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor.lightGray.withAlphaComponent(0.4).cgColor,
                UIColor.white.withAlphaComponent(0.2).cgColor,
                UIColor.lightGray.withAlphaComponent(0.4).cgColor
            ]
            layer.locations = [0, 0.5, 1]
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            return layer
        }()
        
        view.layoutIfNeeded()
        shimmerLayer.frame = view.bounds
        view.layer.addSublayer(shimmerLayer)
        shimmerLayers.append(shimmerLayer)
    }

}

