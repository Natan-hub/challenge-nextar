import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:challange_nextar/core/widgets/shimmer_loading_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/viewmodels/client_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientView extends StatefulWidget {
  const ClientView({super.key});

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientViewModel>(context, listen: false).listClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);

    return Scaffold(
      body: clientViewModel.clients.isEmpty
          ? Center(
              child: shimerColor(context),
            )
          : AlphabetScrollView(
              list: clientViewModel.clients
                  .map((client) => AlphaModel(client.name))
                  .toList(),
              alignment: LetterAlignment.right,
              itemExtent: 80, // Define a altura de cada item
              unselectedTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              selectedTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              overlayWidget: (value) => Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 50,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      value.toUpperCase(),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              itemBuilder: (context, index, id) {
                final cliente = clientViewModel.clients[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: cliente.perfil,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: AppColors.primary,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: AppColors.vermelhoPadrao,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cliente.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: normalTextStyleDefault(Colors.black),
                      ),
                      subtitle: Text(
                        cliente.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: subTextStyle(),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
