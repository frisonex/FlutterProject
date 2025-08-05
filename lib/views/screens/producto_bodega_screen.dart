import 'dart:convert';

import 'package:asegensa/models/bodega_model.dart';
import 'package:asegensa/models/producto_por_bodega.dart';
import 'package:asegensa/routes/navigation_service.dart';
import 'package:asegensa/themes/app_theme.dart';
import 'package:asegensa/views/dialogs/full_image_dialog.dart';
import 'package:asegensa/widgets/custom_buttom.dart';
import 'package:asegensa/widgets/custom_single_selection_dropbox.dart';
import 'package:asegensa/widgets/custom_text_field.dart';
import 'package:asegensa/widgets/custom_top_buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asegensa/services/restcall.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductoBodegaScreen extends StatefulWidget {
  const ProductoBodegaScreen({super.key});

  @override
  State<ProductoBodegaScreen> createState() => _ProductoBodegaScreenState();
}

class _ProductoBodegaScreenState extends State<ProductoBodegaScreen> with SingleTickerProviderStateMixin {
  List<BodegaModel> bodegas = [];
  List<ProductoPorBodega> productsPorBodega = [];

  late AnimationController _controller;
  late NavigationService navigationService;
  final TextEditingController productoInputController = TextEditingController();

  // NUEVO: control de UI
  bool _showTable = false; // muestra la tabla (cuando ya hay selección y terminó de cargar)
  bool _isLoading = false; // overlay de carga
  // BodegaModel? _selectedBodega; // para mantener selección actual

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 60), vsync: this)..repeat(reverse: false);
    loadBodegas();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  Future<void> loadBodegas() async {
    final response = await getBodegas();
    setState(() {
      bodegas = (response.response as List).map((json) => BodegaModel.fromJson(json)).toList();
    });
  }

  void _handleButtom() {
    //   final loginViewModel = Provider.of<ILoginViewModel>(context, listen: false);
    //   loginViewModel.login(context, adminClient.text, passwordClient.text).then((_) {
    //     adminClient.clear();
    //     passwordClient.clear();
    //   }).catchError((e) {
    //     if (!mounted) return;
    //     _showPopup(context, false, e.toString());
    //     adminClient.clear();
    //     passwordClient.clear();
    //   });
    this._runQuery(this.bodegas.first.whsCode);
  }

  // NUEVO: consulta con control de loading/tabla
  Future<void> _runQuery(String whsCode) async {
    setState(() {
      _isLoading = true;
      _showTable = false; // ocultar tabla mientras carga
      productsPorBodega = []; // opcional: limpiar datos previos
    });

    try {
      final response = await getProductosPorBodega(bodega: whsCode, producto: productoInputController.text);
      final list = (response.response as List).map((json) => ProductoPorBodega.fromJson(json)).toList();
      setState(() {
        productsPorBodega = list;
        _showTable = true; // mostrar tabla al terminar
      });
    } catch (e) {
      // Puedes notificar el error si lo deseas
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // dejar de mostrar overlay
        });
      }
    }
  }

  void _onBodegaChanged(BodegaModel? bodega) {
    if (bodega == null) return;
    // setState(() => _selectedBodega = bodega);
    _runQuery(bodega.whsCode);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              children: [
                // Fondo con gradient animado
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(gradient: AppTheme().animatedRadialGradient(_controller)),
                ),

                // Título superior
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Producto por bodega',
                        style: TextStyle(color: Colors.white, fontSize: size.width * 0.0225, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),

                // Dropdown que sube con animación
                AnimatedAlign(
                  alignment: _showTable ? const Alignment(0, -0.65) : Alignment.center,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * 0.85, minWidth: size.width * 0.5),
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.175,
                            child: Padding(
                              padding: EdgeInsets.only(right: size.height * 0.02),
                              child: CustomTextField(mainColor: const Color.fromRGBO(255, 255, 255, 1.0), controller: productoInputController, labelText: 'Producto', hintText: 'Ingrese el producto'),
                            ),
                          ),
                          Expanded(
                            child: CustomSingleSelectionDropBox(items: bodegas, onChanged: _onBodegaChanged, labelText: 'Seleccione una bodega', hintText: 'Buscar bodega...', displayValue: (bodega) => bodega.whsName),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.05),
                            child: InkWell(
                              onTap: _handleButtom,
                              child: CustomAnimatedContainer(
                                width: size.width * 0.175,
                                decoration: BoxDecoration(color: const Color.fromRGBO(91, 179, 32, 1.0), borderRadius: BorderRadius.circular(size.width * 0.008)),
                                child: Center(
                                  child: Text(
                                    'Buscar',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: size.height * 0.022),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tabla que aparece solo cuando terminó de cargar (_showTable && !_isLoading)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: (_showTable && !_isLoading)
                      ? Padding(
                          key: const ValueKey('table'),
                          padding: EdgeInsets.only(top: size.height * 0.25),
                          child: SizedBox(
                            height: size.height,
                            width: size.width,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(scrollDirection: Axis.vertical, child: _buildDataTable(context)), // helper con "Sin registros"
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Botones top (logout / back)
                CustomTopButton(
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  iconColor: Colors.white,
                  positionRight: true,
                  onPressed: () async {
                    navigationService.navigateToLogin(context);
                    await FirebaseAuth.instance.signOut();
                  },
                ),
                CustomTopButton(
                  icon: Icons.arrow_back_ios_new,
                  iconColor: Colors.white,
                  positionRight: false,
                  onPressed: () async {
                    navigationService.navigateToMenu(context);
                  },
                ),

                // Overlay de carga
                if (_isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Tabla con fallback "Sin registros"
  Widget _buildDataTable(BuildContext context) {
    final bool empty = productsPorBodega.isEmpty;

    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            'Código producto',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'Producto',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'Marca',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'Modelo',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'Acción',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
      rows: empty
          ? [
              const DataRow(
                cells: [
                  DataCell(
                    Text(
                      'No se han encontrado registros, por favor seleccione otra fecha',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                    ),
                  ),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                ],
              ),
            ]
          : productsPorBodega.map((p) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      p.codigoProducto.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      p.producto.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      p.marca,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      p.modelo,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  DataCell(ElevatedButton(onPressed: () => _showDetallePopup(context, productsPorBodega), child: const Text('Ver Detalles'))),
                ],
              );
            }).toList(),
    );
  }

  void _showDetallePopup(BuildContext context, List<ProductoPorBodega> productoPorBodega) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(child: Text('Detalles de artículo')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: productoPorBodega.first.bodega.map((d) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Código bodega: ${d.codBodega}'),
                    Text('Bodega: ${d.bodega}'),
                    Text('Cantidad: ${d.cantidad}'),
                    Text('Fecha de fabricación: ${d.fechamft}'),
                    Text('Fecha de vencimiento: ${d.fechavcto}'),
                    const SizedBox(height: 8),

                    // Si luego tu JSON trae imagen, descomenta y ajusta:
                    Center(
                      child: SizedBox(
                        height: 240,
                        child: (productoPorBodega.first.imagen != null && productoPorBodega.first.bodega.isNotEmpty)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FullscreenImagePage(imageBytes: base64Decode(productoPorBodega.first.imagen), heroTag: productoPorBodega.first.codigoProducto),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: productoPorBodega.first.codigoProducto,
                                  child: Image.memory(base64Decode(productoPorBodega.first.imagen), fit: BoxFit.contain, filterQuality: FilterQuality.high),
                                ),
                              )
                            : const Center(child: Text('No hay imagen disponible')),
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Text('Lotes:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...d.lotes.map((l) => Text('- ${l.ubicacionExacta} (Serie: ${l.loteSerie})')),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))],
      ),
    );
  }
}
