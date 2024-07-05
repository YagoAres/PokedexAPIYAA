import UIKit

class PokemonListController: UIViewController {

    let containerView = UIView() // Vista contenedora
    let tablePokedex = UITableView() // Tabla
    
    var pokemonNames: [String] = []
    var pokemonSprites: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupComponents()
        setupConstraints()
        
        fetchPokemonData()
    }
    
    func setupComponents() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 2.0
        containerView.layer.cornerRadius = 10  // Añadir esquinas redondeadas
        containerView.clipsToBounds = true  // Asegurar que los subviews no se salgan del contenedor
        view.addSubview(containerView)
        
        tablePokedex.translatesAutoresizingMaskIntoConstraints = false
        tablePokedex.dataSource = self
        tablePokedex.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellIdentifier)
        containerView.addSubview(tablePokedex)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tablePokedex.topAnchor.constraint(equalTo: containerView.topAnchor),
            tablePokedex.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tablePokedex.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tablePokedex.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func fetchPokemonData() {
        PokemonAPI.shared.fetchPokemonNames { pokemonNames in
            guard let pokemonNames = pokemonNames else { return }
            
            self.pokemonNames = pokemonNames
            self.pokemonSprites = Array(repeating: nil, count: pokemonNames.count)
            
            DispatchQueue.main.async {
                self.tablePokedex.reloadData()
            }
            
            for (index, pokemonName) in pokemonNames.enumerated() {
                PokemonAPI.shared.fetchPokemonImageURL(for: pokemonName) { sprite in
                    self.pokemonSprites[index] = sprite

                    DispatchQueue.main.async {
                        self.tablePokedex.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            }
        }
    }
}

extension PokemonListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellIdentifier, for: indexPath) as! CustomCell
        
        cell.additionalImageView.image = UIImage(named: "PixelPokeball")
        cell.pokedexNumberLabel.text = "No. 00\(indexPath.row + 1)"
        cell.pokemonNameLabel.text = pokemonNames[indexPath.row]

        if let sprite = pokemonSprites[indexPath.row] {
            cell.pokemonImageView.image = sprite
        } else {
            cell.pokemonImageView.image = UIImage(named: "placeholder_image") // Opcional: imagen de relleno mientras se carga
        }
        
        return cell
    }
}

