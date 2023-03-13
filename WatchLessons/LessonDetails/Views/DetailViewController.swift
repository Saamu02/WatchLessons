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
import Combine

class DetailViewController: UIViewController {
    
    private let videoView = UIView()
    private let scrollView = UIScrollView()
    private let scrollViewContainer = UIView()
    private let videoTitleLabel = UILabel()
    private let videoDetailLabel = UILabel()
    private let nextLessonButton = UIButton()
    private let progressView = UIProgressView()
    private let progressViewContainerView = UIView()
    private let progressLabel = UILabel()
    
    private var player : AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerViewController: AVPlayerViewController!

    var lessonsList = [Lesson]()
    var currrentLesson = Lesson()
    var currentIndex = -1
    var videoURL = ""
    
    private var lessonDetailViewModel = LessonDetailViewModel()
    
    private var progressStatus = ""
    private var fileName = ""
    
    private var task : URLSessionTask!
    
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    
    private var percentageWritten:Float = 0.0
    private var taskTotalBytesWritten = 0
    private var taskTotalBytesExpectedToWrite = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentIndex = lessonsList.firstIndex(of: currrentLesson)!
        setupViewsConstraints()
        confiugureDataSourceForViews()
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
        removePlayer()
    }
    
    func setupViewsConstraints() {
        
        setupNavigationBarItems()
        setupVideoView()
        setupScrollView()
        setupVideoTitleLabel()
        setupVideoDetailLabel()
        setupNextLessonButton()
        setupProgressView()
    }
    
    func confiugureDataSourceForViews() {
        
        fileName = "\(currrentLesson.name)_\(currrentLesson.id!)"
        
        if lessonDetailViewModel.ifFileExist(fileName: fileName) {
            self.parent?.navigationItem.rightBarButtonItem?.isHidden = true
            
        } else {
            self.parent?.navigationItem.rightBarButtonItem?.isHidden = false
        }
        videoTitleLabel.text = currrentLesson.name
        videoDetailLabel.text = currrentLesson.description
        videoURL = currrentLesson.videoUrl
    }
    
    func setupNavigationBarItems() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle(" Download", for: .normal)
        button.sizeToFit()
        
        DispatchQueue.main.async {
            self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        button.addTarget(self, action:  #selector(downloadVideo), for: .touchUpInside)
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
        
        nextLessonButton.addTarget(self, action:  #selector(nextButtonAction), for: .touchUpInside)
    }
    
    func setupProgressView() {
        view.addSubview(progressViewContainerView)
        
        progressViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressViewContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        progressViewContainerView.addSubview(progressView)
        progressViewContainerView.addSubview(progressLabel)
        
        progressLabel.textColor = .white
        progressLabel.text = "Please wait while we are downloading your file"
        progressLabel.numberOfLines = 0
        progressLabel.textAlignment = .center
        
        let progressViewWidth = view.bounds.width * 0.75
        
        NSLayoutConstraint.activate([
            progressViewContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            progressViewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressViewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressViewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.widthAnchor.constraint(equalToConstant: progressViewWidth),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
        
        progressView.setProgress(0.0, animated: true)
        progressViewContainerView.isHidden = true
    }
    
    func showProgressView(show: Bool) {
        progressViewContainerView.isHidden = !show
    }
    
    @objc func nextButtonAction() {
        
        if lessonsList.indices.contains(currentIndex + 1) {
            self.playerViewController.player?.pause()
            self.playerViewController.player = nil
            self.player.pause()
            self.player = nil
            
            currentIndex += 1
            currrentLesson = lessonsList[currentIndex]
            confiugureDataSourceForViews()
            playVideo(url: videoURL)
        }
    }
    
    func removePlayer() {
        
        if player == nil {
            return
        }
        
        DispatchQueue.main.async {
            self.player.pause()
            self.player = nil
            self.playerViewController.player?.pause()
            self.playerViewController.removeFromParent()
        }
    }
    
    func playVideo(url: String) {
        
        if player != nil {
            player.play()
            return
        }
        
        playerViewController = AVPlayerViewController()
        
        if lessonDetailViewModel.ifFileExist(fileName: fileName) {
            let fileManager = FileManager.default
            let docsurl = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let path = docsurl.appendingPathComponent("\(fileName).mp4")
            
            player = AVPlayer(url: path)

        } else {
            player = AVPlayer(url: URL(string: url)!)
        }
        
        player.actionAtItemEnd = .none
        
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.videoView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = self.videoView.frame
        playerViewController.player!.play()
    }
    
    @objc func downloadVideo() {
        self.parent?.navigationItem.leftBarButtonItem?.isHidden = true
        self.parent?.navigationItem.rightBarButtonItem?.isHidden = true
        
        playerViewController.player?.pause()
        progressStatus = "0%"
        
        if self.task != nil {
            return
        }
        
        let url =  URL(string: currrentLesson.videoUrl)
        let req = URLRequest(url: url!)
        let task = self.session.downloadTask(with: req)
        self.task = task
        
        showProgressView(show: true)
        task.resume()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("change orientation")
    }
}

extension DetailViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        showProgressView(show: false)
        lessonDetailViewModel.saveFileAtDocumentDir(at: location, fileName: fileName)
        self.parent?.navigationItem.leftBarButtonItem?.isHidden = false
        print("Finished downloading!")
        
        if lessonDetailViewModel.ifFileExist(fileName: fileName) {
            self.parent?.navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)")
        
        taskTotalBytesWritten = Int(writ)
        taskTotalBytesExpectedToWrite = Int(exp)
        percentageWritten = Float(taskTotalBytesWritten) / Float(taskTotalBytesExpectedToWrite)
        progressView.progress = percentageWritten
        progressStatus = String(format: "%.01f", percentageWritten*100) + "%"
        progressLabel.text = "Please wait while we are downloading file \n (\(progressStatus))"
        print(progressStatus)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }

    private func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        print("completed: error: \(String(describing: error))")
    }
}

struct DetailViewControllerRepresentable: UIViewControllerRepresentable {
    
    var lessonList = [Lesson]()
    var currrentLesson = Lesson()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = DetailViewController()
        controller.lessonsList = self.lessonList
        controller.currrentLesson = self.currrentLesson
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("update")
    }
}

