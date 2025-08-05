class ProductoPorBodega {
  String codigoProducto;
  String producto;
  String marca;
  String modelo;
  dynamic imagen;
  List<Bodega> bodega;

  ProductoPorBodega({
    required this.codigoProducto,
    required this.producto,
    required this.marca,
    required this.modelo,
    this.imagen,
    required this.bodega,
  });

  factory ProductoPorBodega.fromJson(Map<String, dynamic> json) {
    return ProductoPorBodega(
      codigoProducto: json['codigoProducto'] ?? '',
      producto: json['producto'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      imagen: json['imagen'],
      bodega: (json['bodega'] as List)
          .map((b) => Bodega.fromJson(b))
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'codigoProducto': codigoProducto,
      'producto': producto,
      'marca': marca,
      'modelo': modelo,
      'imagen': imagen,
      'bodega': bodega.map((b) => b.toJson()).toList(),
    };
  }

}

class Bodega {
  String codBodega;
  String bodega;
  int cantidad;
  DateTime fechavcto;
  DateTime fechamft;
  List<Lote> lotes;

  Bodega({
    required this.codBodega,
    required this.bodega,
    required this.cantidad,
    required this.fechavcto,
    required this.fechamft,
    required this.lotes,
  });

  factory Bodega.fromJson(Map<String, dynamic> json) {
    return Bodega(
      codBodega: json['codBodega'] ?? '',
      bodega: json['bodega'] ?? '',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
      fechavcto: DateTime.parse(json['fechavcto']),
      fechamft: DateTime.parse(json['fechamft']),
      lotes: (json['lotes'] as List)
          .map((l) => Lote.fromJson(l))
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'codBodega': codBodega,
      'bodega': bodega,
      'cantidad': cantidad,
      'fechavcto': fechavcto.toIso8601String(),
      'fechamft': fechamft.toIso8601String(),
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
      ubicacionExacta: json['ubicacionExacta'] ?? '',
      loteSerie: json['loteSerie'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'ubicacionExacta': ubicacionExacta,
      'loteSerie': loteSerie,
    };
  }

}
