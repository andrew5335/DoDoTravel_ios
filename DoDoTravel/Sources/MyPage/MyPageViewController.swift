//
//  MyPageViewController.swift
//  DoDoTravel
//
//  마이페이지 화면
//

import UIKit
import PhotosUI

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var reviewManagementButton: UIButton!
    @IBOutlet weak var searchHistoryButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var menuItems: [(title: String, icon: String)] = []
    private var bannerAdView: BannerAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBannerAd()
        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 로그인 상태 확인
        if !UserManager.shared.isLoggedIn {
            showLoginScreen()
            return
        }
        
        loadUserInfo()
    }
    
    private func setupUI() {
        title = "마이페이지"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 프로필 이미지 설정
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        profileImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        // 버튼 설정
        editProfileButton.setTitle("회원 정보 수정", for: .normal)
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        
        reviewManagementButton.setTitle("리뷰 관리", for: .normal)
        reviewManagementButton.addTarget(self, action: #selector(reviewManagementButtonTapped), for: .touchUpInside)
        
        searchHistoryButton.setTitle("검색 결과 관리", for: .normal)
        searchHistoryButton.addTarget(self, action: #selector(searchHistoryButtonTapped), for: .touchUpInside)
        
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        
        // 메뉴 아이템
        menuItems = [
            (title: "회원 정보 수정", icon: "person.circle"),
            (title: "리뷰 관리", icon: "text.bubble"),
            (title: "검색 결과 관리", icon: "magnifyingglass")
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupBannerAd() {
        bannerAdView = BannerAdView()
        view.addSubview(bannerAdView)
        bannerAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint: NSLayoutConstraint
        if let tabBarController = tabBarController {
            bottomConstraint = bannerAdView.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor)
        } else {
            bottomConstraint = bannerAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
        
        NSLayoutConstraint.activate([
            bannerAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            bannerAdView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tableView.contentInset.bottom = 50
        tableView.scrollIndicatorInsets.bottom = 50
        
        bannerAdView.updateRootViewController(self)
    }
    
    private func loadUserInfo() {
        guard let user = UserManager.shared.currentUser else {
            return
        }
        
        usernameLabel.text = user.nickname?.isEmpty == false ? user.nickname : user.username
        emailLabel.text = user.email
        
        // 프로필 이미지 로드 (URL이 있는 경우)
        if let imageURL = user.profileImageURL, !imageURL.isEmpty {
            // TODO: 이미지 URL에서 로드
            // 현재는 기본 이미지 사용
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray
        }
    }
    
    @objc private func profileImageTapped() {
        showImagePickerOptions()
    }
    
    @objc private func editProfileButtonTapped() {
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func reviewManagementButtonTapped() {
        let reviewManagementVC = ReviewManagementViewController()
        navigationController?.pushViewController(reviewManagementVC, animated: true)
    }
    
    @objc private func searchHistoryButtonTapped() {
        let searchHistoryVC = SearchHistoryViewController()
        navigationController?.pushViewController(searchHistoryVC, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            UserManager.shared.logout()
            self?.showLoginScreen()
        })
        present(alert, animated: true)
    }
    
    private func showImagePickerOptions() {
        let alert = UIAlertController(title: "프로필 사진 설정", message: "사진을 선택하세요", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "사진 라이브러리", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        })
        
        if profileImageView.image != nil {
            alert.addAction(UIAlertAction(title: "사진 삭제", style: .destructive) { [weak self] _ in
                self?.removeProfileImage()
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        // iPad 지원
        if let popover = alert.popoverPresentationController {
            popover.sourceView = profileImageView
            popover.sourceRect = profileImageView.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            showAlert(title: "알림", message: "이 기능을 사용할 수 없습니다.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func removeProfileImage() {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemGray
        
        // 사용자 정보 업데이트
        if var user = UserManager.shared.currentUser {
            user.profileImageURL = nil
            UserManager.shared.updateUser(user)
        }
    }
    
    private func showLoginScreen() {
        // 탭바 컨트롤러에서 로그인 화면 표시
        if let tabBarController = tabBarController as? MainViewController {
            tabBarController.showLoginIfNeeded()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            
            // TODO: 이미지를 서버에 업로드하고 URL을 받아서 저장
            // 현재는 로컬에만 저장
            if var user = UserManager.shared.currentUser {
                // 이미지를 Data로 변환하여 저장 (실제로는 서버에 업로드)
                user.profileImageURL = "local_image_\(UUID().uuidString)"
                UserManager.shared.updateUser(user)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = menuItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.imageView?.image = UIImage(systemName: item.icon)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            editProfileButtonTapped()
        case 1:
            reviewManagementButtonTapped()
        case 2:
            searchHistoryButtonTapped()
        default:
            break
        }
    }
}

