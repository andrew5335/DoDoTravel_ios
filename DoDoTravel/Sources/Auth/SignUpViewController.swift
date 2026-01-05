//
//  SignUpViewController.swift
//  DoDoTravel
//
//  회원가입 화면
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onSignUpSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "회원가입"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        usernameTextField.placeholder = "아이디"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.delegate = self
        
        emailTextField.placeholder = "이메일 주소"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        confirmPasswordTextField.placeholder = "비밀번호 확인"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        activityIndicator.hidesWhenStopped = true
        
        // 키보드 닫기 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces), !username.isEmpty else {
            showAlert(title: "알림", message: "아이디를 입력해주세요.")
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
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "알림", message: "비밀번호를 입력해주세요.")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "알림", message: "비밀번호는 최소 6자 이상이어야 합니다.")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "알림", message: "비밀번호 확인을 입력해주세요.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "알림", message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
        activityIndicator.startAnimating()
        signUpButton.isEnabled = false
        
        UserManager.shared.signUp(username: username, email: email, password: password) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.signUpButton.isEnabled = true
                
                if success {
                    // 회원가입 성공 시 로그인된 상태로 메인 화면으로 이동
                    self?.onSignUpSuccess?()
                    self?.dismiss(animated: true)
                } else {
                    self?.showAlert(title: "회원가입 실패", message: errorMessage ?? "회원가입에 실패했습니다.")
                }
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            signUpButtonTapped()
        }
        return true
    }
}

