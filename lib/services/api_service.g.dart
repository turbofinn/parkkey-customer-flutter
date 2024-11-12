// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://xkzd75f5kd.execute-api.ap-south-1.amazonaws.com/prod';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SendOtpResponse> getOtp(SendOtpRequest sendOtpRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendOtpRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SendOtpResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/login-service/send-otp',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SendOtpResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(verifyOtpRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<VerifyOtpResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/login-service/verify-otp/customer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VerifyOtpResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreateTicketResponse> generateQR(
      CreateTicketRequest createTicketRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createTicketRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CreateTicketResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket-handler/create-ticket',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CreateTicketResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MyResponse> updateCustomerDetails(
      UpdateCustomerDetailsRequest updateCustomerDetailsRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateCustomerDetailsRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<MyResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/update-customer-details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = MyResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ParkedVehicleHistoryResponse> getVehicleParkingHistory(
      String param1) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'vehicleID': param1};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ParkedVehicleHistoryResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-vehicle-parking-history',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ParkedVehicleHistoryResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CustomerVehicleDetailsResponse> getCustomerVehicleDetails(
      String userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomerVehicleDetailsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-customer-vehicle-details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CustomerVehicleDetailsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ParkedVehicleResponse> getCustomerParkingHistory(String userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ParkedVehicleResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-customer-parking-history',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ParkedVehicleResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CustomerDetailsResponse> getCustomerDetails(String userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomerDetailsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-customer-details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CustomerDetailsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ParkingSpaceInfoResponse> getParkingSpaceInfo(
      String parkingSpaceID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ParkingSpaceInfoResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-management/parking-space/fetch-parking-space-info/${parkingSpaceID}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ParkingSpaceInfoResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetTicketResponse> getTicket(String parkingTicketID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'parkingTicketID': parkingTicketID
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GetTicketResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket-handler/get-ticket',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GetTicketResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<ParkingLocationResponse>> getParkingSpaceList(String city) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'city': city};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ParkingLocationResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-parking-space-by-city',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    var value = _result.data!
        .map((dynamic i) =>
            ParkingLocationResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<AddVehicleResponse> addVehicle(
      AddVehicleRequest addVehicleRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(addVehicleRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AddVehicleResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/add-vehicle',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AddVehicleResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleDetailsResponse> getVehicleDetails(String vehicleNo) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'vehicleNo': vehicleNo};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleDetailsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-vehicle-details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VehicleDetailsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WalletBalanceResponse> getWalletDetails(String userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userID': userID};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WalletBalanceResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/get-wallet-details',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WalletBalanceResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DeleteVehicleResponse> deleteVehicle(String vehicleNo) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'vehicleNo': vehicleNo};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DeleteVehicleResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customer-flow-handler/delete-vehilcle',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DeleteVehicleResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
