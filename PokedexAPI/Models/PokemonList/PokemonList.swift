import UIKit

class PokemonList: UIViewController {
    
    let containerView = UIView() // Vista contenedora
    let tablePokedex = UITableView() // Tabla
    var pokemonEntries: [PokemonEntry] = []
    var pokemonSprites: [String: UIImage] = [:]
    
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
        tablePokedex.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
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
        PokemonApi().getData { [weak self] pokemonEntries in
            self?.pokemonEntries = pokemonEntries
            self?.tablePokedex.reloadData()
            
            
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

extension PokemonList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let pokemon = pokemonEntries[indexPath.row]
        cell.additionalImageView.image = UIImage(named: "PixelPokeball")
        cell.pokedexNumberLabel.text = "No. 00\(indexPath.row + 1)"
        cell.pokemonNameLabel.text = pokemon.name.capitalized

        PokemonSelectedApi().getData(url: pokemon.url) { sprites, weight in
                  if let url = URL(string: sprites.front_default) {
                      cell.pokemonImageView.load(url: url)
                      print(weight)
                  }
         
              }
        
        return cell
    }
}


