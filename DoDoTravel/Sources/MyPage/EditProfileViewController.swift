//
//  EditProfileViewController.swift
//  DoDoTravel
//
//  회원 정보 수정 화면
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserInfo()
    }
    
    private func setupUI() {
        title = "회원 정보 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        profileImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        usernameTextField.placeholder = "아이디"
        usernameTextField.isEnabled = false // 아이디는 수정 불가
        usernameTextField.backgroundColor = .systemGray6
        
        emailTextField.placeholder = "이메일 주소"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        nicknameTextField.placeholder = "닉네임"
        
        phoneNumberTextField.placeholder = "전화번호"
        phoneNumberTextField.keyboardType = .phonePad
        
        saveButton.setTitle("저장", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func loadUserInfo() {
        guard let user = UserManager.shared.currentUser else {
            return
        }
        
        usernameTextField.text = user.username
        emailTextField.text = user.email
        nicknameTextField.text = user.nickname
        phoneNumberTextField.text = user.phoneNumber
        
        if let imageURL = user.profileImageURL, !imageURL.isEmpty {
            // TODO: 이미지 로드
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray
        }
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "프로필 사진 설정", message: "사진을 선택하세요", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "사진 라이브러리", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = profileImageView
            popover.sourceRect = profileImageView.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let user = UserManager.shared.currentUser else {
            return
        }
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            showAlert(title: "알림", message: "이메일 주소를 입력해주세요.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "알림", message: "올바른 이메일 형식이 아닙니다.")
            return
        }
        
        var updatedUser = user
        updatedUser.email = email
        updatedUser.nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespaces)
        updatedUser.phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        
        UserManager.shared.updateUser(updatedUser)
        
        showAlert(title: "완료", message: "회원 정보가 수정되었습니다.") { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            
            if var user = UserManager.shared.currentUser {
                user.profileImageURL = "local_image_\(UUID().uuidString)"
                UserManager.shared.updateUser(user)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

