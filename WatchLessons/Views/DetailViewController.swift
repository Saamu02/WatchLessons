//
//  DetailViewController.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import UIKit
import SwiftUI
import AVFoundation
import AVKit

class DetailViewController: UIViewController {
    
    let videoView = UIView()
    
    let scrollView = UIScrollView()
    let scrollViewContainer = UIView()
    let videoTitleLabel = UILabel()
    let videoDetailLabel = UILabel()
    let nextLessonButton = UIButton()
    
    private var player : AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerViewController: AVPlayerViewController!
    var videoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.orientationLock = .all
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo(url: videoURL)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        DispatchQueue.main.async {
            self.player.pause()
            self.playerViewController.player?.pause()
            self.playerViewController.removeFromParent()
            self.player = nil
        }
    }
    
    func setupViews() {
        setupNavigationBarItems()
        setupVideoView()
        setupScrollView()
        setupVideoTitleLabel()
        setupVideoDetailLabel()
        setupNextLessonButton()
    }
    
    func setupNavigationBarItems() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle(" Download", for: .normal)
        button.sizeToFit()
        
        DispatchQueue.main.async {
            self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func setupVideoView() {
        view.addSubview(videoView)
        
        videoView.backgroundColor = .black
        videoView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = view.bounds.height * 0.30
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.heightAnchor.constraint(equalToConstant: heightConstraint)
        ])
    }
    
    func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func setupVideoTitleLabel() {
        scrollViewContainer.addSubview(videoTitleLabel)
        
        videoTitleLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        videoTitleLabel.text = "Video Title"
        videoTitleLabel.textColor = .white
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoTitleLabel.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor, constant: -20),
            videoTitleLabel.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 20),
            videoTitleLabel.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor, constant: 20)
        ])
    }
    
    func setupVideoDetailLabel() {
        scrollViewContainer.addSubview(videoDetailLabel)
        
        videoDetailLabel.font = UIFont.systemFont(ofSize: 17)
        videoDetailLabel.text = "Video details goes here"
        videoDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        videoDetailLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            videoDetailLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 20),
            videoDetailLabel.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor, constant: -20),
            videoDetailLabel.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 20)
        ])
    }
    
    func setupNextLessonButton() {
        scrollViewContainer.addSubview(nextLessonButton)
        
        nextLessonButton.translatesAutoresizingMaskIntoConstraints = false
        nextLessonButton.setTitleColor(#colorLiteral(red: 0.04547598958, green: 0.5179845095, blue: 1, alpha: 1), for: .normal)
        nextLessonButton.setTitle("Next lesson ", for: .normal)
        nextLessonButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        nextLessonButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        NSLayoutConstraint.activate([
            nextLessonButton.topAnchor.constraint(equalTo: videoDetailLabel.bottomAnchor, constant: 20),
            nextLessonButton.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor, constant: -20),
            nextLessonButton.bottomAnchor.constraint(equalTo: scrollViewContainer.bottomAnchor)
        ])
    }
    
    func playVideo(url: String) {
        
        if player != nil {
            player.play()
            return
        }
        
        //        guard let path = Bundle.main.path(forResource: url, ofType: "mp4") else { return }
        
        playerViewController = AVPlayerViewController()
        player = AVPlayer(url: URL(string: url)!)
        player.actionAtItemEnd = .none
        
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.videoView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = self.videoView.frame
        playerViewController.player!.play()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("change orientation")
    }
}

struct DetailViewControllerRepresentable: UIViewControllerRepresentable {
    
    var videoURL = ""
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = DetailViewController()
        controller.videoURL = self.videoURL
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("update")
    }
}

