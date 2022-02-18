//
//  ClimaViewController.swift
//  Clima
//
//  Created by Vladimir Fibe on 18.02.2022.
//

import UIKit

class ClimaViewController: UIViewController {
  let c = "21°C"
  let backgroundView = UIImageView(image: UIImage(named: "background"))
  let locationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage( UIImage(systemName: "location.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 40).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    return button
  }()
  
  let searchButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage( UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 40).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    return button
  }()
  
  let searchField: UITextField = {
    let text = UITextField()
    text.placeholder = "Search"
    text.textAlignment = .right
    text.font = .systemFont(ofSize: 25)
    text.backgroundColor = .systemFill
    text.borderStyle = .roundedRect
    return text
  }()
  
  let conditionImageView: UIImageView = {
    let imageview = UIImageView(image: UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120)))
    return imageview
  }()
  
  let temperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 80, weight: .bold)
    return label
  }()
  
  let cityLabel: UILabel = {
    let label = UILabel()
    label.text = "London"
    label.font = .systemFont(ofSize: 30)
    return label
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    conditionImageView.image = UIImage(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))
    temperatureLabel.text = c
  }
  func setupUI() {
    view.addSubview(backgroundView)
    backgroundView.contentMode = .scaleAspectFill
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    let searchStack = UIStackView(arrangedSubviews: [locationButton, searchField, searchButton])
    searchStack.axis = .horizontal
    searchStack.alignment = .fill
    searchStack.distribution = .fill
    searchStack.spacing = 10
    let emptyView = UIView()
    let stack = UIStackView(arrangedSubviews: [
      searchStack,
      conditionImageView,
      temperatureLabel,
      cityLabel,
      emptyView])
    stack.axis = .vertical
    stack.alignment = .trailing
    stack.distribution = .fill
    stack.spacing = 10
    
    view.addSubview(stack)
    let margins = view.layoutMarginsGuide
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    stack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    stack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    stack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    searchStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
    searchStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
  }
}
