class Productos {
  int numeroDespacho;
  DateTime fechaDespacho;
  String codigoCliente;
  String nombreCliente;
  List<Detalle> detalle;

  Productos({
    required this.numeroDespacho,
    required this.fechaDespacho,
    required this.codigoCliente,
    required this.nombreCliente,
    required this.detalle,
  });

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      numeroDespacho: json['numeroDespacho'],
      fechaDespacho: DateTime.parse(json['fechaDespacho']),
      codigoCliente: json['codigoCliente'],
      nombreCliente: json['nombreCliente'],
      detalle: (json['detalle'] as List)
          .map((d) => Detalle.fromJson(d))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroDespacho': numeroDespacho,
      'fechaDespacho': fechaDespacho.toIso8601String(),
      'codigoCliente': codigoCliente,
      'nombreCliente': nombreCliente,
      'detalle': detalle.map((d) => d.toJson()).toList(),
    };
  }
}

class Detalle {
  String codigoArticulo;
  String descripcionArticulo;
  double cantidad;
  String almacen;
  String? imagen;
  List<Lote> lotes;

  Detalle({
    required this.codigoArticulo,
    required this.descripcionArticulo,
    required this.cantidad,
    required this.almacen,
    this.imagen,
    required this.lotes,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) {
    return Detalle(
      codigoArticulo: json['codigoArticulo'],
      descripcionArticulo: json['descripcionArticulo'],
      cantidad: json['cantidad'],
      almacen: json['almacen'],
      imagen: json['imagen'],
      lotes: (json['lotes'] as List)
          .map((l) => Lote.fromJson(l))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoArticulo': codigoArticulo,
      'descripcionArticulo': descripcionArticulo,
      'cantidad': cantidad,
      'almacen': almacen,
      'imagen': imagen,
      'lotes': lotes.map((l) => l.toJson()).toList(),
    };
  }
}

class Lote {
  String ubicacionExacta;
  String loteSerie;

  Lote({
    required this.ubicacionExacta,
    required this.loteSerie,
  });

  factory Lote.fromJson(Map<String, dynamic> json) {
    return Lote(
      ubicacionExacta: json['ubicacionExacta'],
      loteSerie: json['loteSerie'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ubicacionExacta': ubicacionExacta,
      'loteSerie': loteSerie,
    };
  }
}
