//
//  ProfileInfoViewController.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol ProfileInfoViewInput: AnyObject {
    func setupInitialStateFriendProfile(stringFactory: ProfileStringFactoryProtocol)

    func setupInitialStateCurrentAccount(stringFactory: ProfileStringFactoryProtocol)
    
    func setupInitialStateRecievedOffer(stringFactory: ProfileStringFactoryProtocol)
    
    func setupInitialStateSendOffer(stringFactory: ProfileStringFactoryProtocol)

    func setupNavigationBar(on: Bool)

    func fillInfo(with viewModel: ProfileInfoViewModelProtocol)
}

final class ProfileInfoViewController: UIViewController {

    var output: ProfileInfoViewOutput?

    private let acceptButton = ButtonsFactory.acceptButton
    private let denyButton = ButtonsFactory.denyButton
    private var buttonsStackView = UIStackView()

    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mainApp()
        return button
    }()
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mainApp()
        return button
    }()
    private let imageView: ImageView = {
        let view =  ImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = .systemGray6
        return view
    }()
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = UIFont.avenir24()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let userInfoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.avenir17()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let countryCityLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.avenir20()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonsView = ButtonsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output?.viewWillDisappear()
    }
}

extension ProfileInfoViewController: ProfileInfoViewInput {
    
    func setupNavigationBar(on: Bool) {
        navigationController?.setNavigationBarHidden(!on, animated: true)
    }
    
    func setupInitialStateFriendProfile(stringFactory: ProfileStringFactoryProtocol) {
        setupViewsForShow(stringFactory: stringFactory)
        setupConstraints()
        constraintsForFriendProfile()
        setupActions()
    }

    func setupInitialStateCurrentAccount(stringFactory: ProfileStringFactoryProtocol) {
        setupViewsForShow(stringFactory: stringFactory)
        setupConstraints()
        constraintsForYourProfile()
        setupActions()
    }
    
    func setupInitialStateRecievedOffer(stringFactory: ProfileStringFactoryProtocol) {
        setupViewsForOffersRecieve(stringFactory: stringFactory)
        setupConstraints()
        constraintsForOffers()
        setupActions()
    }
    
    func setupInitialStateSendOffer(stringFactory: ProfileStringFactoryProtocol) {
        setupViewsForOffersSend(stringFactory: stringFactory)
        setupConstraints()
        constraintsForOffers()
        setupActions()
    }
    
    func fillInfo(with viewModel: ProfileInfoViewModelProtocol) {
        imageView.set(imageURL: viewModel.imageURL)
        nameLabel.text = viewModel.nameAndAge
        countryCityLabel.text = viewModel.countryCity
        userInfoLabel.text = viewModel.info
        buttonsView.setupCount(count: viewModel.postsCount)
    }
}

private extension ProfileInfoViewController {
    
    func setupViewsForShow(stringFactory: ProfileStringFactoryProtocol) {
        navigationItem.title = stringFactory.currentAccountTitle
        navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .systemGray6
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(countryCityLabel)
        containerView.addSubview(userInfoLabel)
        containerView.addSubview(buttonsView)
        containerView.addSubview(settingsButton)
        containerView.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: stringFactory.menuButtonImageName, in: Bundle.module, with: nil), for: .normal)
        settingsButton.setImage(UIImage(named: stringFactory.settingsButtonImageName, in: Bundle.module, with: nil), for: .normal)
        buttonsView.setTitles(firstButtonTitle: stringFactory.postsButtonTitle,
                              secondButtonTitle: stringFactory.showButtonTitle)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViewsForOffersSend(stringFactory: ProfileStringFactoryProtocol) {
        acceptButton.setTitle(stringFactory.acceptSendedButtonTitle, for: .normal)
        denyButton.setTitle(stringFactory.denySendedButtonTitle, for: .normal)
        setupViewsForShow(stringFactory: stringFactory)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView = UIStackView(arrangedSubviews: [acceptButton,denyButton], spacing: 8, axis: .horizontal)
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)
    }
    
    func setupViewsForOffersRecieve(stringFactory: ProfileStringFactoryProtocol) {
        acceptButton.setTitle(stringFactory.acceptRecievedButtonTitle, for: .normal)
        denyButton.setTitle(stringFactory.denyRecievedButtonTitle, for: .normal)
        setupViewsForShow(stringFactory: stringFactory)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView = UIStackView(arrangedSubviews: [acceptButton,denyButton], spacing: 8, axis: .horizontal)
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)
    }
    
    func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.font.lineHeight).isActive = true
        
        menuButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        
        settingsButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        
        countryCityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        countryCityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        countryCityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        countryCityLabel.heightAnchor.constraint(equalToConstant: countryCityLabel.font.lineHeight).isActive = true
        
        userInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        userInfoLabel.topAnchor.constraint(equalTo: countryCityLabel.bottomAnchor, constant: 15).isActive = true
        userInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        //userInfoLabel.heightAnchor.constraint(equalToConstant: userInfoLabel.font.lineHeight).isActive = true
        
        buttonsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        buttonsView.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 20).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: Constants.buttonFont.lineHeight).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 100).isActive = true
        buttonsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28).isActive = true
        
    }
    
    func constraintsForYourProfile() {
        menuButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    func constraintsForFriendProfile() {
        settingsButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func constraintsForOffers() {
        buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20).isActive = true
        buttonsStackView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor,constant: 15).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func setupActions() {
        buttonsView.firstButton.addTarget(self, action: #selector(showPostsTapped), for: .touchUpInside)
        buttonsView.secondButton.addTarget(self, action: #selector(showPostsTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(setupProfileTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuOpenTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyTapped), for: .touchUpInside)
    }
    
    @objc func showPostsTapped() {
        output?.showPosts()
    }

    @objc func setupProfileTapped() {
        output?.showAccountSettings()
    }

    @objc func menuOpenTapped() {
        output?.showMenu()
    }
    
    @objc func denyTapped() {
        output?.denyAction()
    }
    
    @objc func acceptTapped() {
        output?.acceptAction()
    }
}
