import 'package:flutter/material.dart'; // Importa o pacote flutter/material para utilizar widgets do Flutter
import 'package:shared_preferences/shared_preferences.dart'; // Importa o pacote shared_preferences para armazenamento local

// Define um modelo de dados para uma compra
class Purchase {
  final String date; // Data da compra
  final double price; // Preço da compra
  final String description; // Descrição da compra

  // Construtor da classe Purchase
  Purchase({required this.date, required this.price, required this.description});
}

void main() {
  runApp(const MyApp()); // Inicia a aplicação Flutter
}

// Classe principal da aplicação
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Projeto - Login', // Título da aplicação
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Define o esquema de cores da aplicação
        useMaterial3: true, // Utiliza o Material Design 3
      ),
      home: const MyHomePage(title: 'App Registo - Login'), // Define a página inicial da aplicação
      routes: {
        '/home': (context) => const HomePage(), // Define a rota para a página inicial
        '/register_purchase': (context) => const RegisterPurchasePage(), // Define a rota para a página de registo de compra
        '/list_purchases': (context) => const ListPurchasesPage(), // Define a rota para a página de listagem de compras
      },
    );
  }
}

// Página inicial da aplicação
class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  final String title; // Título da página

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor de fundo da app bar
          title: Text(widget.title), // Título da app bar
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Login'), // Aba de login
              Tab(text: 'Registo'), // Aba de registo
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoginScreen(), // Conteúdo da aba de login
            _buildRegisterScreen(), // Conteúdo da aba de registo
          ],
        ),
      ),
    );
  }

  // Constrói o ecrã de login
  Widget _buildLoginScreen() {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campos de input para username e password
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome de utilizador';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(Icons.lock)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await _login(_usernameController.text, _passwordController.text)) {
                    Navigator.pushNamed(context, '/home');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Login Falhou'),
                          content: const Text('Nome de utilizador ou password inválidos.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Função para efetuar o login
  Future<bool> _login(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedUsername = prefs.getString('username');
    final String? storedPassword = prefs.getString('password');

    return storedUsername == username && storedPassword == password;
  }

  // Constrói o ecrã de registo
  Widget _buildRegisterScreen() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome de utilizador';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(Icons.lock)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Confirmar Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(Icons.lock_outline)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme a password';
                    }
                    if (value != _passwordController.text) {
                      return 'As passwords não coincidem';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String username = _usernameController.text;
                    final String password = _passwordController.text;

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('username', username);
                    await prefs.setString('password', password);

                    // Navega de volta para a página de login
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                child: const Text('Registar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para registo de compras
class RegisterPurchasePage extends StatefulWidget {
  const RegisterPurchasePage({Key? key}) : super(key: key);

  @override
  _RegisterPurchasePageState createState() => _RegisterPurchasePageState();
}

class _RegisterPurchasePageState extends State<RegisterPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _purchaseDateController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _purchaseDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registar Compra'), // Título da app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _purchaseDateController,
                decoration: const InputDecoration(
                  labelText: 'Inserir a data de compra',
                  hintText: 'dd/mm/yyyy',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a data de compra no formato dd/mm/yyyy';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _purchasePriceController,
                decoration: const InputDecoration(
                  labelText: 'Inserir Preço de compra',
                  hintText: '€ 0.00',
                  prefixIcon: Icon(Icons.euro_symbol),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o preço da compra';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _purchaseDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição da compra',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira descrição da compra';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPurchase = Purchase(
                      date: _purchaseDateController.text,
                      price: double.parse(_purchasePriceController.text),
                      description: _purchaseDescriptionController.text,
                    );
                    _savePurchase(newPurchase);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Registar Compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para guardar uma nova compra
  void _savePurchase(Purchase purchase) {
    purchases.add(purchase);
  }
}

// Lista fictícia para armazenar compras
List<Purchase> purchases = [];

// Página para listar compras
class ListPurchasesPage extends StatefulWidget {
  const ListPurchasesPage({Key? key}) : super(key: key);

  @override
  _ListPurchasesPageState createState() => _ListPurchasesPageState();
}

class _ListPurchasesPageState extends State<ListPurchasesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Compras'), // Título da app bar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Para eliminar uma compra indesejada, dê swipe para a esquerda.', // Instruções para eliminar compras
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return Dismissible(
                  key: Key(purchase.date), // Chave única para cada compra
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      // Remove a compra da lista
                      purchases.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data: ${purchase.date}'),
                        Text('Valor: ${purchase.price.toString()}€'),
                        Text('Descrição: ${purchase.description}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Página inicial após o login
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Utiliza a mesma cor roxa
        title: const Text('Página Inicial'), // Título da app bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterPurchasePage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: const Text('Registar Compras'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/list_purchases');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: const Text('Listar Compras'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
