//
//  AnimeCollectionViewCell.swift
//  AnimeFacts
//
//  Created by Dilshodi Kahori on 08/11/22.
//

import UIKit

class AnimeCollectionViewItem: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var animeTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureCell
    /// Эта функция с входным параметром "content" с типом модели, которые парсится.
    func configure(with content: Anime.AnimeDetail) {
        activityIndicator.startAnimating()
        animeTitle.text = content.name
        
        NetworkManager.shared.fetchImage(from: content.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(imageView)
        contentView.addSubview(animeTitle)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(180)
        }
        
        animeTitle.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.leading).inset(4)
            make.width.equalTo(100)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        animeTitle.text = nil
    }
}
