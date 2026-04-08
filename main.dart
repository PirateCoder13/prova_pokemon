// ======================================================
// PROVA PRÁTICA - POKÉDEX EM DART
// ======================================================

// ====================== PARTE DO JOÃO ======================
// Interface da questão 9 + classe Pokemon base

abstract class RegistravelNaPokedex {
  void marcarComoVisto();
  void marcarComoCapturado();
  void favoritar();
  void desfavoritar();
}

class Pokemon implements RegistravelNaPokedex {
  int numero;
  String nome;
  String tipo;

  int _nivel;
  int _hpAtual;
  int _hpMaximo;

  bool capturado;
  String? proximaEvolucao;
  int nivelEvolucao;

  int energia;
  bool visto;
  bool favorito;

  Pokemon({
    required this.numero,
    required this.nome,
    required this.tipo,
    required int nivel,
    required int hpAtual,
    required int hpMaximo,
    this.capturado = false,
    this.proximaEvolucao,
    this.nivelEvolucao = 0,
    this.energia = 100,
    this.visto = false,
    this.favorito = false,
  }) : _nivel = nivel,
       _hpAtual = hpAtual,
       _hpMaximo = hpMaximo {
    if (_nivel < 1) _nivel = 1;
    if (_nivel > 100) _nivel = 100;

    if (_hpMaximo <= 0) _hpMaximo = 1;

    if (_hpAtual > _hpMaximo) _hpAtual = _hpMaximo;
    if (_hpAtual < 0) _hpAtual = 0;
  }

  int get nivel => _nivel;
  int get hpAtual => _hpAtual;
  int get hpMaximo => _hpMaximo;

  void exibirFicha() {
    print('----------------------------');
    print('Número: $numero');
    print('Nome: $nome');
    print('Tipo: $tipo');
    print('Nível: $_nivel');
    print('HP: $_hpAtual / $_hpMaximo');
    print('Energia: $energia');
    print('Visto: ${visto ? "Sim" : "Não"}');
    print('Capturado: ${capturado ? "Sim" : "Não"}');
    print('Favorito: ${favorito ? "Sim" : "Não"}');

    if (proximaEvolucao != null) {
      print('Próxima evolução: $proximaEvolucao');
      print('Nível para evoluir: $nivelEvolucao');
    }

    print('----------------------------');
  }

  void subirNivel(int quantidade) {
    if (quantidade < 0) {
      print('Não é permitido subir nível com valor negativo.');
      return;
    }

    _nivel += quantidade;

    if (_nivel > 100) {
      _nivel = 100;
    }

    if (_nivel < 1) {
      _nivel = 1;
    }
  }

  void receberDano(int dano) {
    if (dano < 0) {
      print('Não é permitido receber dano negativo.');
      return;
    }

    _hpAtual -= dano;

    if (_hpAtual < 0) {
      _hpAtual = 0;
    }
  }

  void curar(int valor) {
    if (valor < 0) {
      print('Não é permitido curar valor negativo.');
      return;
    }

    _hpAtual += valor;

    if (_hpAtual > _hpMaximo) {
      _hpAtual = _hpMaximo;
    }
  }

  void evoluir() {
    if (proximaEvolucao == null) {
      print('$nome não possui evolução configurada.');
      return;
    }

    if (_nivel < nivelEvolucao) {
      print('$nome ainda não pode evoluir.');
      return;
    }

    print('$nome evoluiu para $proximaEvolucao!');
    nome = proximaEvolucao!;
    proximaEvolucao = null;
    _hpMaximo += 20;
    _hpAtual = _hpMaximo;
  }

  int calcularAtaqueBase() {
    return _nivel * 2;
  }

  @override
  void marcarComoVisto() {
    visto = true;
  }

  @override
  void marcarComoCapturado() {
    capturado = true;
    visto = true;
  }

  @override
  void favoritar() {
    if (!capturado) {
      print('$nome não pode ser favoritado porque ainda não foi capturado.');
      return;
    }

    favorito = true;
  }

  @override
  void desfavoritar() {
    favorito = false;
  }
}

// ====================== PARTE DA EDUARDA ======================
// Classe Pokedex, filtros, consultas e estatísticas

class Pokedex {
  final List<Pokemon> _pokemons = [];

  void adicionarPokemon(Pokemon p) {
    bool existe = _pokemons.any((pokemon) => pokemon.numero == p.numero);

    if (existe) {
      print('Já existe um pokémon com o número ${p.numero}.');
      return;
    }

    _pokemons.add(p);
    print('${p.nome} foi adicionado à Pokédex.');
  }

  bool removerPokemonPorNumero(int numero) {
    int tamanhoAntes = _pokemons.length;
    _pokemons.removeWhere((p) => p.numero == numero);
    return _pokemons.length < tamanhoAntes;
  }

  Pokemon? buscarPorNumero(int numero) {
    for (var p in _pokemons) {
      if (p.numero == numero) {
        return p;
      }
    }
    return null;
  }

  void listarTodos() {
    if (_pokemons.isEmpty) {
      print('A Pokédex está vazia.');
      return;
    }

    for (var p in _pokemons) {
      p.exibirFicha();
    }
  }

  List<Pokemon> listarCapturados() {
    return _pokemons.where((p) => p.capturado).toList();
  }

  List<Pokemon> listarPorTipo(String tipo) {
    return _pokemons
        .where((p) => p.tipo.toLowerCase() == tipo.toLowerCase())
        .toList();
  }

  List<Pokemon> listarAcimaDoNivel(int nivelMinimo) {
    return _pokemons.where((p) => p.nivel > nivelMinimo).toList();
  }

  List<Pokemon> listarQuePodemEvoluir() {
    return _pokemons.where((p) {
      return p.proximaEvolucao != null && p.nivel >= p.nivelEvolucao;
    }).toList();
  }

  List<Pokemon> get listaPokemons => _pokemons;

  int totalPokemons() {
    return _pokemons.length;
  }

  Map<String, int> quantidadePorTipo() {
    Map<String, int> tipos = {};

    for (var p in _pokemons) {
      tipos[p.tipo] = (tipos[p.tipo] ?? 0) + 1;
    }

    return tipos;
  }

  double mediaDeNivel() {
    if (_pokemons.isEmpty) return 0;

    int soma = 0;
    for (var p in _pokemons) {
      soma += p.nivel;
    }

    return soma / _pokemons.length;
  }

  double percentualCapturados() {
    if (_pokemons.isEmpty) return 0;

    int capturados = _pokemons.where((p) => p.capturado).length;
    return (capturados / _pokemons.length) * 100;
  }
}

// ====================== PARTE DA YASMIN ======================
// Herança e habilidades

class PokemonFogo extends Pokemon {
  PokemonFogo({
    required int numero,
    required String nome,
    required int nivel,
    required int hpAtual,
    required int hpMaximo,
    bool capturado = false,
    String? proximaEvolucao,
    int nivelEvolucao = 0,
    int energia = 100,
    bool visto = false,
    bool favorito = false,
  }) : super(
         numero: numero,
         nome: nome,
         tipo: 'Fogo',
         nivel: nivel,
         hpAtual: hpAtual,
         hpMaximo: hpMaximo,
         capturado: capturado,
         proximaEvolucao: proximaEvolucao,
         nivelEvolucao: nivelEvolucao,
         energia: energia,
         visto: visto,
         favorito: favorito,
       );

  @override
  int calcularAtaqueBase() {
    return nivel * 3;
  }

  @override
  void exibirFicha() {
    super.exibirFicha();
    print('Categoria: Pokémon de Fogo');
    print('============================');
  }
}

class PokemonAgua extends Pokemon {
  PokemonAgua({
    required int numero,
    required String nome,
    required int nivel,
    required int hpAtual,
    required int hpMaximo,
    bool capturado = false,
    String? proximaEvolucao,
    int nivelEvolucao = 0,
    int energia = 100,
    bool visto = false,
    bool favorito = false,
  }) : super(
         numero: numero,
         nome: nome,
         tipo: 'Água',
         nivel: nivel,
         hpAtual: hpAtual,
         hpMaximo: hpMaximo,
         capturado: capturado,
         proximaEvolucao: proximaEvolucao,
         nivelEvolucao: nivelEvolucao,
         energia: energia,
         visto: visto,
         favorito: favorito,
       );

  @override
  int calcularAtaqueBase() {
    return nivel * 2 + 10;
  }

  @override
  void exibirFicha() {
    super.exibirFicha();
    print('Categoria: Pokémon de Água');
    print('============================');
  }
}

class PokemonEletrico extends Pokemon {
  PokemonEletrico({
    required int numero,
    required String nome,
    required int nivel,
    required int hpAtual,
    required int hpMaximo,
    bool capturado = false,
    String? proximaEvolucao,
    int nivelEvolucao = 0,
    int energia = 100,
    bool visto = false,
    bool favorito = false,
  }) : super(
         numero: numero,
         nome: nome,
         tipo: 'Elétrico',
         nivel: nivel,
         hpAtual: hpAtual,
         hpMaximo: hpMaximo,
         capturado: capturado,
         proximaEvolucao: proximaEvolucao,
         nivelEvolucao: nivelEvolucao,
         energia: energia,
         visto: visto,
         favorito: favorito,
       );

  @override
  int calcularAtaqueBase() {
    return nivel * 2 + 15;
  }

  @override
  void exibirFicha() {
    super.exibirFicha();
    print('Categoria: Pokémon Elétrico');
    print('============================');
  }
}

abstract class Habilidade {
  String nome;
  int custoEnergia;

  Habilidade(this.nome, this.custoEnergia);

  void usar(Pokemon usuario, Pokemon alvo);
}

class ChoqueDoTrovao extends Habilidade {
  ChoqueDoTrovao() : super('Choque do Trovão', 15);

  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    if (usuario.energia < custoEnergia) {
      print('${usuario.nome} não tem energia suficiente para usar $nome.');
      return;
    }

    usuario.energia -= custoEnergia;
    int dano = usuario.calcularAtaqueBase() + 5;
    alvo.receberDano(dano);
  }
}

class JatoDAgua extends Habilidade {
  JatoDAgua() : super('Jato D\'Água', 10);

  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    if (usuario.energia < custoEnergia) {
      print('${usuario.nome} não tem energia suficiente para usar $nome.');
      return;
    }

    usuario.energia -= custoEnergia;
    int dano = usuario.calcularAtaqueBase() + 3;
    alvo.receberDano(dano);
  }
}

class LancaChamas extends Habilidade {
  LancaChamas() : super('Lança-Chamas', 20);

  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    if (usuario.energia < custoEnergia) {
      print('${usuario.nome} não tem energia suficiente para usar $nome.');
      return;
    }

    usuario.energia -= custoEnergia;
    int dano = usuario.calcularAtaqueBase() + 7;
    alvo.receberDano(dano);
  }
}

// ====================== PARTE DO JOSÉ ======================
// Polimorfismo em batalha + main com simulação geral

void executarTurnoBatalha(
  Pokemon atacante,
  Pokemon defensor,
  Habilidade habilidade,
) {
  habilidade.usar(atacante, defensor);

  print(
    '${atacante.nome} usou ${habilidade.nome}. HP restante de ${defensor.nome}: ${defensor.hpAtual}',
  );

  if (defensor.hpAtual == 0) {
    print('${defensor.nome} foi derrotado!');
  }
}

void exibirListaSimples(String titulo, List<Pokemon> lista) {
  print('\n$titulo');
  if (lista.isEmpty) {
    print('Nenhum pokémon encontrado.');
    return;
  }

  for (var p in lista) {
    print('- ${p.nome} (${p.tipo})');
  }
}

void main() {
  Pokemon pikachu = PokemonEletrico(
    numero: 25,
    nome: 'Pikachu',
    nivel: 12,
    hpAtual: 35,
    hpMaximo: 35,
    proximaEvolucao: 'Raichu',
    nivelEvolucao: 20,
  );

  Pokemon charmander = PokemonFogo(
    numero: 4,
    nome: 'Charmander',
    nivel: 15,
    hpAtual: 39,
    hpMaximo: 39,
    proximaEvolucao: 'Charmeleon',
    nivelEvolucao: 16,
  );

  Pokemon squirtle = PokemonAgua(
    numero: 7,
    nome: 'Squirtle',
    nivel: 10,
    hpAtual: 44,
    hpMaximo: 44,
    proximaEvolucao: 'Wartortle',
    nivelEvolucao: 16,
  );

  print('========== QUESTÃO 1 ==========');
  pikachu.exibirFicha();
  charmander.exibirFicha();
  squirtle.exibirFicha();

  // demonstrar métodos
  print('\n========== QUESTÃO 2 ==========');
  pikachu.subirNivel(5);
  pikachu.receberDano(12);
  pikachu.curar(6);
  pikachu.exibirFicha();

  squirtle.subirNivel(2);
  squirtle.receberDano(20);
  squirtle.curar(10);
  squirtle.exibirFicha();

  // evolui e outro não
  print('\n========== QUESTÃO 3 ==========');
  charmander.subirNivel(1);
  charmander.evoluir();

  pikachu.evoluir();

  // outras partes
  Pokedex pokedex = Pokedex();

  pokedex.adicionarPokemon(pikachu);
  pokedex.adicionarPokemon(charmander);
  pokedex.adicionarPokemon(squirtle);

  Pokemon bulbasaur = Pokemon(
    numero: 1,
    nome: 'Bulbasaur',
    tipo: 'Planta',
    nivel: 9,
    hpAtual: 45,
    hpMaximo: 45,
    proximaEvolucao: 'Ivysaur',
    nivelEvolucao: 16,
  );

  Pokemon eevee = Pokemon(
    numero: 133,
    nome: 'Eevee',
    tipo: 'Normal',
    nivel: 18,
    hpAtual: 55,
    hpMaximo: 55,
    proximaEvolucao: 'Vaporeon',
    nivelEvolucao: 20,
  );

  Pokemon magikarp = PokemonAgua(
    numero: 129,
    nome: 'Magikarp',
    nivel: 20,
    hpAtual: 20,
    hpMaximo: 20,
    proximaEvolucao: 'Gyarados',
    nivelEvolucao: 20,
  );

  Pokemon vulpix = PokemonFogo(
    numero: 37,
    nome: 'Vulpix',
    nivel: 18,
    hpAtual: 38,
    hpMaximo: 38,
    proximaEvolucao: 'Ninetales',
    nivelEvolucao: 25,
  );

  Pokemon mareep = PokemonEletrico(
    numero: 179,
    nome: 'Mareep',
    nivel: 14,
    hpAtual: 40,
    hpMaximo: 40,
    proximaEvolucao: 'Flaaffy',
    nivelEvolucao: 15,
  );

  pokedex.adicionarPokemon(bulbasaur);
  pokedex.adicionarPokemon(eevee);
  pokedex.adicionarPokemon(magikarp);
  pokedex.adicionarPokemon(vulpix);
  pokedex.adicionarPokemon(mareep);

  // teste de métodos
  print('\n========== QUESTÃO 4 ==========');
  print('Listando todos os pokémons:');
  pokedex.listarTodos();

  Pokemon? encontrado = pokedex.buscarPorNumero(25);
  if (encontrado != null) {
    print('Pokémon encontrado pelo número 25: ${encontrado.nome}');
  } else {
    print('Pokémon não encontrado.');
  }

  bool removeu = pokedex.removerPokemonPorNumero(179);
  print(
    removeu
        ? 'Pokémon número 179 removido com sucesso.'
        : 'Pokémon número 179 não foi removido.',
  );

  pokedex.adicionarPokemon(mareep);

  // vistos, capturados e favoritos
  print('\n========== QUESTÃO 9 ==========');
  pikachu.marcarComoVisto();
  bulbasaur.marcarComoCapturado();
  eevee.marcarComoCapturado();
  charmander.marcarComoCapturado();
  squirtle.marcarComoCapturado();
  mareep.marcarComoVisto();

  bulbasaur.favoritar();
  eevee.favoritar();

  vulpix.favoritar();

  print(
    '${bulbasaur.nome} - visto: ${bulbasaur.visto}, capturado: ${bulbasaur.capturado}, favorito: ${bulbasaur.favorito}',
  );
  print(
    '${eevee.nome} - visto: ${eevee.visto}, capturado: ${eevee.capturado}, favorito: ${eevee.favorito}',
  );
  print(
    '${vulpix.nome} - visto: ${vulpix.visto}, capturado: ${vulpix.capturado}, favorito: ${vulpix.favorito}',
  );

  // filtros
  print('\n========== QUESTÃO 5 ==========');
  exibirListaSimples('Capturados:', pokedex.listarCapturados());
  exibirListaSimples('Tipo Água:', pokedex.listarPorTipo('água'));
  exibirListaSimples('Acima do nível 10:', pokedex.listarAcimaDoNivel(10));
  exibirListaSimples('Que podem evoluir:', pokedex.listarQuePodemEvoluir());

  // funções anônimas
  print('\n========== QUESTÃO 10 ==========');

  var hpBaixo = pokedex.listaPokemons.where((p) => p.hpAtual < 30).toList();

  var porNome = List<Pokemon>.from(pokedex.listaPokemons);
  porNome.sort((a, b) => a.nome.compareTo(b.nome));

  var porNivel = List<Pokemon>.from(pokedex.listaPokemons);
  porNivel.sort((a, b) => b.nivel.compareTo(a.nivel));

  var favoritos = pokedex.listaPokemons.where((p) => p.favorito).toList();

  exibirListaSimples('HP abaixo de 30:', hpBaixo);
  exibirListaSimples('Ordenados por nome:', porNome);
  exibirListaSimples('Ordenados por nível decrescente:', porNivel);
  exibirListaSimples('Favoritos:', favoritos);

  // fichas das subclasses
  print('\n========== QUESTÃO 6 ==========');
  pikachu.exibirFicha();
  squirtle.exibirFicha();
  charmander.exibirFicha();

  // habilidades e batalha
  print('\n========== QUESTÕES 7 E 8 ==========');

  Habilidade choque = ChoqueDoTrovao();
  Habilidade agua = JatoDAgua();
  Habilidade fogo = LancaChamas();

  executarTurnoBatalha(pikachu, squirtle, choque);
  executarTurnoBatalha(squirtle, pikachu, agua);
  executarTurnoBatalha(charmander, bulbasaur, fogo);

  // desafio final
  print('\n========== QUESTÃO 12 ==========');

  // marcar mais alguns
  magikarp.marcarComoCapturado();
  pikachu.marcarComoCapturado();

  // favoritar mais um se quiser
  pikachu.favoritar();

  // evolução obrigatória
  magikarp.evoluir();
  mareep.subirNivel(1);
  mareep.evoluir();

  // 2 batalhas
  print('\n--- Batalha 1 ---');
  executarTurnoBatalha(pikachu, charmander, choque);
  executarTurnoBatalha(charmander, pikachu, fogo);

  print('\n--- Batalha 2 ---');
  executarTurnoBatalha(squirtle, magikarp, agua);
  executarTurnoBatalha(magikarp, squirtle, agua);

  // filtros novamente
  exibirListaSimples('\nFiltro - Capturados:', pokedex.listarCapturados());
  exibirListaSimples('Filtro - Tipo Fogo:', pokedex.listarPorTipo('FOGO'));
  exibirListaSimples(
    'Filtro - Acima do nível 15:',
    pokedex.listarAcimaDoNivel(15),
  );
  exibirListaSimples(
    'Filtro - Podem evoluir:',
    pokedex.listarQuePodemEvoluir(),
  );

  // estatísticas finais
  print('\n========== QUESTÃO 11 ==========');
  print('Total de pokémons: ${pokedex.totalPokemons()}');
  print('Quantidade por tipo: ${pokedex.quantidadePorTipo()}');
  print('Média de nível: ${pokedex.mediaDeNivel().toStringAsFixed(2)}');
  print(
    'Percentual capturados: ${pokedex.percentualCapturados().toStringAsFixed(2)}%',
  );
}
