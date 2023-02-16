import UIKit

class ClimaView: UIView {
    private let buttonSizeSmall = 44.0
    private let buttonSizelarge = 120.0
    
    private lazy var locationButton: UIButton = {
        $0.setImage( UIImage(systemName: "location.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIButton(type: .system))
    
    private lazy var searchButton: UIButton = {
        $0.setImage( UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        $0.addTarget(self, action: #selector(searchPressed), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))
    
    private let searchField: UITextField = {
        $0.placeholder = "Search"
        $0.textAlignment = .right
        $0.autocapitalizationType = .words
        $0.returnKeyType = .go
        $0.font = .systemFont(ofSize: 25)
        $0.backgroundColor = .systemFill
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())
    
    private let conditionImageView: UIImageView = {
        $0.tintColor = UIColor(named: "wheatherColor")
        return $0
    }(UIImageView(image: UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))))
    
    private let temperatureLabel: UILabel = {
        $0.text = "21°C"
        $0.font = .systemFont(ofSize: 80, weight: .bold)
        $0.textColor = UIColor(named: "wheatherColor")
        return $0
    }(UILabel())
    
    private let cityLabel: UILabel = {
        $0.text = "London"
        $0.font = .systemFont(ofSize: 30)
        $0.textColor = UIColor(named: "wheatherColor")
        return $0
    }(UILabel())
    
    private lazy var searchStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [locationButton, searchField, searchButton]))
    
    private lazy var stack: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
        $0.spacing = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [
        searchStack,
        conditionImageView,
        temperatureLabel,
        cityLabel]))
    

    func configure(_ target: Any?,
                   action: Selector,
                   delegate: UITextFieldDelegate?) {
        locationButton.addTarget(self, action: action, for: .touchUpInside)
        searchField.delegate = delegate
    }
    func setCityLabel(_ text: String?) {
        cityLabel.text = text
    }
    
    func setTemperature(_ text: String?) {
        temperatureLabel.text = text
    }
    
    func setContionImage(_ name: String) {
        conditionImageView.image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))
    }
    @objc func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
        configureAppearance()
    }
}

extension ClimaView {
    func setupViews() {
        addSubview(stack)
    }
    
    func layoutViews() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            searchStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor),

            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureAppearance() {
    }
}
