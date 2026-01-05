//
//  LoginViewController.swift
//  DoDoTravel
//
//  로그인 화면
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onLoginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        usernameTextField.placeholder = "아이디"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.delegate = self
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        findAccountButton.setTitle("아이디/비밀번호 찾기", for: .normal)
        findAccountButton.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        
        activityIndicator.hidesWhenStopped = true
        
        // 키보드 닫기 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(title: "알림", message: "아이디를 입력해주세요.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "알림", message: "비밀번호를 입력해주세요.")
            return
        }
        
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        
        UserManager.shared.login(username: username, password: password) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.loginButton.isEnabled = true
                
                if success {
                    self?.onLoginSuccess?()
                    self?.dismiss(animated: true)
                } else {
                    self?.showAlert(title: "로그인 실패", message: errorMessage ?? "로그인에 실패했습니다.")
                }
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.onSignUpSuccess = { [weak self] in
            // 회원가입 성공 시 로그인된 상태이므로 마이페이지로 이동
            self?.onLoginSuccess?()
            self?.dismiss(animated: true)
        }
        let navController = UINavigationController(rootViewController: signUpVC)
        present(navController, animated: true)
    }
    
    @objc private func findAccountButtonTapped() {
        let alert = UIAlertController(title: "아이디/비밀번호 찾기", message: "아이디/비밀번호 찾기 기능은 구현 예정입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
}

