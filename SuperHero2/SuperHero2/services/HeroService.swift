import Foundation
import Alamofire

struct HeroService {
    
    var delegate: HeroServiceDelegate?
    
    func getHeroList() {
        let URL = "https://akabab.github.io/superhero-api/api/all.json"
        AF.request(URL)
            .responseDecodable(of: [HeroModel].self) { response in
                switch(response.result) {
                    
                    case.success(let heroes):
                    guard let randomHero = heroes.randomElement() else { return }
                    delegate?.onHeroDidUpdate(hero: randomHero)
                    
                    case.failure(let error):
                    delegate?.errorHappened(message: error.localizedDescription)
                    
                }
            }
    }
    
}

protocol HeroServiceDelegate {
    func onHeroDidUpdate(hero: HeroModel)
    func errorHappened(message: String)
}
