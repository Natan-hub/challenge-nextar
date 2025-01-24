import 'package:challange_nextar/models/client_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ClientViewModel extends ChangeNotifier {
  List<ClientModel> clients = [];

  void listClients() {
    _listenToClients();
  }

  void _listenToClients() {
    final faker = Faker();

    for (int i = 0; i < 50; i++) {
      clients.add(ClientModel(
        name: faker.person.name(),
        email: faker.internet.email(),
        perfil: faker.image.loremPicsum(
          width: 150, // Largura da imagem
          height: 150, // Altura da imagem
          seed: i.toString(), // Semente para gerar URLs únicas
        ),
      ));
    }

    clients
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  List<String> get names => clients.map((e) => e.name).toList();
}
