//
//  ViewController.swift
//  TesteWarren
//
//  Created by Adriano Soares on 16/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import UIKit

class SuitabilityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let inputContainer = UIView()
    let textField = UITextField()
    let sendMessageButton = UIButton()

    var textFieldBottomConstraint: NSLayoutConstraint?
    var keyboardOpen = false
    var showInputField = false

    var buttonBottomConstraint: NSLayoutConstraint?
    var button1 = UIButton()
    var button2 = UIButton()


    var responseId: String?

    var answers = [String:Any]()
    var messages = [Message]()
    var buttons: [Button]?


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension


        tableView.dataSource = self
        tableView.delegate   = self

        tableView.register(BotTableViewCell.self, forCellReuseIdentifier: "botCell")
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false

        sendMessageButton.addTarget(self, action: #selector(sendResponse), for: .touchUpInside)

        button1.addTarget(self, action: #selector(answerButtonClicked(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(answerButtonClicked(_:)), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SuitabilityApi().message(id: nil, answers: answers, completion: handleResponse)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

        self.configureLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillAppear (_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            animateInputField(keyboardHeight: keyboardRect.height)

        }

    }

    @objc func keyboardWillDisappear (_ notification: NSNotification) {
        animateInputField()
    }

    func dismissKeyboard () {
        textField.endEditing(false)
    }

    @objc func sendResponse() {
        let message = Message(value: textField.text ?? "" , isUserMessage: true)
        appendMessage(message)
        if let responseId = responseId {
            answers[responseId] = textField.text
            SuitabilityApi().message(id: responseId, answers: answers, completion: handleResponse)
            showInputField = false
            dismissKeyboard()
        }


    }

    @objc func answerButtonClicked (_ sender: UIButton) {
        var message: Message!
        var answer: String!
        if sender.isEqual(button1) {
            answer = buttons?[0].value
            message = Message(value: buttons?[0].label ?? "" , isUserMessage: true)
        } else if sender.isEqual(button2) {
            answer = buttons?[1].value
            message = Message(value: buttons?[1].label ?? "" , isUserMessage: true)
        }

        appendMessage(message)
        if let responseId = responseId {
            answers[responseId] = answer
            SuitabilityApi().message(id: responseId, answers: answers, completion: handleResponse)
            hideButtons()
        }

    }

    func appendMessage(_ message: Message) {
        self.messages.append(message)
        UIView.animate(withDuration: 0.1, animations: {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .bottom)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom , animated: true)

        })
    }

    func animateInputField (keyboardHeight: CGFloat = 0) {
        var inputConstraintConstant:CGFloat = 50
        if (showInputField) {
            inputConstraintConstant -= 50
        }
        inputConstraintConstant -= keyboardHeight
        textFieldBottomConstraint?.constant = inputConstraintConstant
        UIView.animate(withDuration: 0.2) {
            if (self.showInputField) {
                self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y - inputConstraintConstant + 50 )
            }
            self.view.layoutIfNeeded()
        }
    }

    func showButtons () {
        UIView.animate(withDuration: 0.2) {
            self.buttonBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func hideButtons () {
        UIView.animate(withDuration: 0.2) {
            self.buttonBottomConstraint?.constant = 100
            self.view.layoutIfNeeded()
        }
    }

    func handleResponse(response: ResponseModel) {
        responseId = response.id
        for (index, message) in response.messages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.7){
                self.appendMessage(message)
            }
        }
        if (response.inputs.count > 0) {
            let input = response.inputs[0]
            textField.keyboardType = input.keyboardType
            textField.text = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(response.messages.count) * 0.7){
                self.showInputField = true
                self.animateInputField()
            }

        } else if (response.buttons.count >= 2) {
            button1.setTitle(response.buttons[0].label, for: .normal)
            button2.setTitle(response.buttons[1].label, for: .normal)
            buttons = response.buttons
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(response.messages.count) * 0.7){
                self.showButtons()
            }
        }
    }



    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let identifier = message.isUserMessage ? "userCell" : "botCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if (message.isUserMessage) {
            (cell as! UserTableViewCell).message = message
            if let name = answers["question_name"] as! String? {
                (cell as! UserTableViewCell).avatarLetter = name.prefix(1).uppercased()
            }
        } else {
            (cell as! BotTableViewCell).message = message
        }


        return cell
    }

    func configureLayout() {
        view.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        view.addSubview(tableView)

        let marginGuide = view.layoutMarginsGuide
        tableView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true


        inputContainer.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.00)
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainer)

        inputContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        inputContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textFieldBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 50)
        textFieldBottomConstraint?.isActive = true


        textField.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(textField)
        textField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 20) .isActive = true
        textField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor).isActive = true


        sendMessageButton.backgroundColor = UIColor(red:0.93, green:0.20, blue:0.37, alpha:1.00)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(sendMessageButton)

        let sendMessageImage = UIImage(named: "send_message")
        sendMessageButton.setImage(sendMessageImage?.maskWithColor(color: UIColor.white), for: .normal)
        sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
        sendMessageButton.imageView?.contentMode = .scaleAspectFit
        sendMessageButton.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 5).isActive = true
        sendMessageButton.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: -10).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -5).isActive = true
        sendMessageButton.heightAnchor.constraint(equalTo: sendMessageButton.widthAnchor, multiplier: 1).isActive = true
        sendMessageButton.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 10).isActive = true

        inputContainer.layoutSubviews()

        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.00)

        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)

        buttonContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        buttonContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true

        buttonBottomConstraint = buttonContainer.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 100)
        buttonBottomConstraint?.isActive = true

        button1.backgroundColor = UIColor(red:0.93, green:0.20, blue:0.37, alpha:1.00)
        button2.backgroundColor = UIColor(red:0.93, green:0.20, blue:0.37, alpha:1.00)

        button1.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(button1)

        button1.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        button1.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
        button1.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true


        button2.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(button2)

        button2.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        button2.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
        button2.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true

        button1.bottomAnchor.constraint(equalTo: button2.topAnchor, constant: -1).isActive = true
        button1.heightAnchor.constraint(equalTo: button2.heightAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendMessageButton.layer.cornerRadius = sendMessageButton.bounds.size.width/2
        sendMessageButton.clipsToBounds = true

    }

}

