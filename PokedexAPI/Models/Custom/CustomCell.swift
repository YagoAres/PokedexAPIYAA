import UIKit

class CustomCell: UITableViewCell {

    static let cellIdentifier: String = "CustomCell"

    let additionalImageView = UIImageView() // Nuevo imageView añadido
    let pokemonImageView = UIImageView()
    let pokedexNumberLabel = UILabel()
    let pokemonNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupComponents() {
        additionalImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(additionalImageView)
        
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonImageView)
        
        pokedexNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokedexNumberLabel)
        
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonNameLabel)
        
        // Opcional: Configurar estilos iniciales
        pokedexNumberLabel.textAlignment = .left
        pokemonNameLabel.textAlignment = .left
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            additionalImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            additionalImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            additionalImageView.widthAnchor.constraint(equalToConstant: 30),
            additionalImageView.heightAnchor.constraint(equalToConstant: 30),
            
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.leadingAnchor.constraint(equalTo: additionalImageView.trailingAnchor, constant: 25),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50), //
            
            pokedexNumberLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            pokedexNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokedexNumberLabel.widthAnchor.constraint(equalToConstant: 100), // Ancho label
            
            pokemonNameLabel.leadingAnchor.constraint(equalTo: pokedexNumberLabel.trailingAnchor, constant: 10),
            pokemonNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}

