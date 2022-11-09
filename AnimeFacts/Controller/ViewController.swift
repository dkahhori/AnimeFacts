//
//  ViewController.swift
//  AnimeFacts
//
//  Created by Dilshodi Kahori on 04/11/22.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - Property
    private var animes: [Anime.AnimeDetail] = []
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(AnimeCollectionViewItem.self, forCellWithReuseIdentifier: "animeCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        //        collectionView.backgroundColor = .green
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        fetchData()
    }
    
    private func setupView() {
        title = "Аниме"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Fetch JSON
    private func fetchData() {
        NetworkManager.shared.fetch(Anime.self, fromURL: Link.animeURL.rawValue) { [weak self] result in
            switch result {
            case .success(let anime):
                guard let self = self else { return }
                self.animes = anime.animeDetails
                self.collectionView.reloadData()
                print(self.animes)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "animeCell", for: indexPath)
        
        guard let item = item as? AnimeCollectionViewItem else { return UICollectionViewCell() }
        let anime = animes[indexPath.row]
        item.configure(with: anime)
        return item
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 140, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

