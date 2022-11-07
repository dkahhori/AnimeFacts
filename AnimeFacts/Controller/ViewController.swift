//
//  ViewController.swift
//  AnimeFacts
//
//  Created by Dilshodi Kahori on 04/11/22.
//

import UIKit

class ViewController: UIViewController { 
    
    // MARK: - Property
    var animes: [Anime.AnimeDetail] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Fetch JSON
    private func fetchData() {
        guard let url = URL(string: Link.animeURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let anime = try decoder.decode(Anime.self, from: data)
                
                DispatchQueue.main.async {
                    self?.animes = anime.animeDetails
                    print(anime)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

