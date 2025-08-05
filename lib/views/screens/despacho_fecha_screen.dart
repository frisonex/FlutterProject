import 'package:asegensa/routes/navigation_service.dart';
import 'package:asegensa/themes/app_theme.dart';
import 'package:asegensa/views/dialogs/full_image_dialog.dart';
import 'package:asegensa/widgets/custom_data_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asegensa/services/restcall.dart';
import 'package:asegensa/models/product_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

import '../../widgets/custom_top_buttom.dart';

class DespachoFechaScreen extends StatefulWidget {
  const DespachoFechaScreen({super.key});

  @override
  State<DespachoFechaScreen> createState() => _DespachoFechaScreenState();
}

class _DespachoFechaScreenState extends State<DespachoFechaScreen> with SingleTickerProviderStateMixin {
  List<Productos> products = [];

  final _dateStartController = TextEditingController();
  late NavigationService navigationService;

  late AnimationController _controller;

  // NEW: estado para controlar animación y loading
  bool _showTable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 60), vsync: this)..repeat(reverse: false);

    // Escucha cambios del datepicker
    _dateStartController.addListener(_onDateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateStartController.dispose();
    super.dispose();
  }

  Future<void> loadProducts(String fechaModificada) async {
    final response = await getProducts(fechaDespacho: fechaModificada);
    setState(() {
      products = (response.response as List).map((json) => Productos.fromJson(json)).toList();
    });
  }

  void _showDetallePopup(BuildContext context, List<Detalle> detalles) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalles de artículo'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detalles.map((d) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Código: ${d.codigoArticulo}'),
                    Text('Descripción: ${d.descripcionArticulo}'),
                    Text('Cantidad: ${d.cantidad}'),
                    Text('Almacén: ${d.almacen}'),
                    const SizedBox(height: 8),
                    Center(
                      child: SizedBox(
                        height: 240,
                        child: (d.imagen != null && d.imagen!.isNotEmpty)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FullscreenImagePage(imageBytes: base64Decode(d.imagen!), heroTag: d.codigoArticulo),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: d.codigoArticulo,
                                  child: Image.memory(base64Decode(d.imagen!), fit: BoxFit.contain, filterQuality: FilterQuality.high),
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

  // NEW: manejar el cambio de fecha (apto para listener)
  void _onDateChanged() {
    final startText = _dateStartController.text.trim();
    if (startText.length == 10) {
      // formato esperado YYYY-MM-DD (10 chars)
      final dateModified = startText.replaceAll('-', '');
      _runQuery(dateModified);
    }
  }

  // NEW: ejecuta consulta con loading + muestra la tabla

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
                // Fondo
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(gradient: AppTheme().animatedRadialGradient(_controller)),
                ),

                // Título
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Despacho por fecha',
                        style: TextStyle(color: Colors.white, fontSize: size.width * 0.0225, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),

                // DatePicker que sube
                AnimatedAlign(
                  alignment: _showTable ? const Alignment(0, -0.65) : Alignment.center,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * 0.85, minWidth: size.width * 0.5),
                    child: Material(
                      color: Colors.transparent,
                      child: CustomDatePicker(
                          controller: _dateStartController,
                          labelText: 'Selecciona una fecha de despacho',
                          hintText: 'Fecha de despacho',
                          onValidationChanged: (_) {}),
                    ),
                  ),
                ),

                // TABLA: solo se muestra cuando _showTable == true y NO esté cargando
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
                                // Si quieres un progress lineal cuando VUELVE a cargar,
                                // no lo mostramos porque ya ocultamos la tabla durante carga.
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: _buildDataTable(), // <<<<<<<< usa el helper
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Botones top
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

                // OVERLAY de carga (bloquea y oculta visualmente el resto)
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

  Future<void> _runQuery(String dateModified) async {
    setState(() {
      // Oculta la tabla y muestra solo el loading mientras consulta
      _showTable = false;
      _isLoading = true;
    });
    try {
      await loadProducts(dateModified);
      setState(() {
        // Al terminar de cargar, vuelve a mostrar la tabla
        _showTable = true;
      });
    } catch (e) {
      // Opcional: mostrar error
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDataTable() {
    // Si no hay registros, mostramos una fila con "Sin registros"
    final bool empty = products.isEmpty;

    return DataTable(
      columns: const [
        DataColumn(label: Text('N° Despacho', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        DataColumn(label: Text('Código Cliente', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        DataColumn(label: Text('Nombre Cliente', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        DataColumn(label: Text('Acción', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
      ],
      rows: empty
          ? [
              DataRow(
                cells: const [
                  DataCell(Text('No se han encontrado registros, por favor seleccione otra fecha', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white))),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                ],
              ),
            ]
          : products.map((p) {
              return DataRow(
                cells: [
                  DataCell(Text(p.numeroDespacho.toString(), style: const TextStyle(color: Colors.white))),
                  DataCell(Text(p.fechaDespacho.toString(), style: const TextStyle(color: Colors.white))),
                  DataCell(Text(p.codigoCliente, style: const TextStyle(color: Colors.white))),
                  DataCell(Text(p.nombreCliente, style: const TextStyle(color: Colors.white))),
                  DataCell(ElevatedButton(onPressed: () => _showDetallePopup(context, p.detalle), child: const Text('Ver Detalles'))),
                ],
              );
            }).toList(),
    );
  }
}
