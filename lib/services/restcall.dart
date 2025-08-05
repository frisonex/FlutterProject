import 'package:asegensa/services/types.dart';
import 'package:dio/dio.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

Future<ApiResponse> getProducts({required String fechaDespacho}) async {
  return await makeRequest("GET", "/despachosPorFecha", queryParams: {"fechaDespacho": fechaDespacho});
}

Future<ApiResponse> getBodegas() async {
  return await makeRequest("GET", "/bodegas");
}

Future<ApiResponse> getProductosPorBodega({required String bodega, required String producto}) async {
  return await makeRequest("GET", "/productosPorBodega", queryParams: {"bodega": bodega, "producto": producto});
}

Future<ApiResponse> makeRequest(String method, String path, {Map<String, dynamic>? queryParams, Object? body}) async {
  ApiResponse responseApi = ApiResponse();
  try {
    late Response apiResponse;

    switch (method) {
      case "GET":
        apiResponse = await dio.get(path, queryParameters: queryParams);
        break;
      case "POST":
        apiResponse = await dio.post(path, data: body);
        break;
      case "PUT":
        apiResponse = await dio.put(path, data: body);
        break;
      case "PATCH":
        apiResponse = await dio.patch(path, data: body);
        break;
      case "DELETE":
        apiResponse = await dio.delete(path, data: body);
        break;
      default:
        throw UnsupportedError("Método $method no soportado");
    }

    responseApi.statusCode = apiResponse.statusCode!;
    responseApi.response = apiResponse.data;
    return responseApi;
  } on DioException catch (e) {
    responseApi.statusCode = e.response?.statusCode ?? 500;
    responseApi.error = e.response?.data;
    return responseApi;
  }
}
