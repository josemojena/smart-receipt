// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_processing_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TicketProcessingResponse {

 bool get success; TicketData? get data;
/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketProcessingResponseCopyWith<TicketProcessingResponse> get copyWith => _$TicketProcessingResponseCopyWithImpl<TicketProcessingResponse>(this as TicketProcessingResponse, _$identity);

  /// Serializes this TicketProcessingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketProcessingResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'TicketProcessingResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $TicketProcessingResponseCopyWith<$Res>  {
  factory $TicketProcessingResponseCopyWith(TicketProcessingResponse value, $Res Function(TicketProcessingResponse) _then) = _$TicketProcessingResponseCopyWithImpl;
@useResult
$Res call({
 bool success, TicketData? data
});


$TicketDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$TicketProcessingResponseCopyWithImpl<$Res>
    implements $TicketProcessingResponseCopyWith<$Res> {
  _$TicketProcessingResponseCopyWithImpl(this._self, this._then);

  final TicketProcessingResponse _self;
  final $Res Function(TicketProcessingResponse) _then;

/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TicketData?,
  ));
}
/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TicketDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketProcessingResponse].
extension TicketProcessingResponsePatterns on TicketProcessingResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketProcessingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketProcessingResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketProcessingResponse value)  $default,){
final _that = this;
switch (_that) {
case _TicketProcessingResponse():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketProcessingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TicketProcessingResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  TicketData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketProcessingResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  TicketData? data)  $default,) {final _that = this;
switch (_that) {
case _TicketProcessingResponse():
return $default(_that.success,_that.data);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  TicketData? data)?  $default,) {final _that = this;
switch (_that) {
case _TicketProcessingResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketProcessingResponse implements TicketProcessingResponse {
  const _TicketProcessingResponse({required this.success, required this.data});
  factory _TicketProcessingResponse.fromJson(Map<String, dynamic> json) => _$TicketProcessingResponseFromJson(json);

@override final  bool success;
@override final  TicketData? data;

/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketProcessingResponseCopyWith<_TicketProcessingResponse> get copyWith => __$TicketProcessingResponseCopyWithImpl<_TicketProcessingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketProcessingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketProcessingResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'TicketProcessingResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TicketProcessingResponseCopyWith<$Res> implements $TicketProcessingResponseCopyWith<$Res> {
  factory _$TicketProcessingResponseCopyWith(_TicketProcessingResponse value, $Res Function(_TicketProcessingResponse) _then) = __$TicketProcessingResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, TicketData? data
});


@override $TicketDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$TicketProcessingResponseCopyWithImpl<$Res>
    implements _$TicketProcessingResponseCopyWith<$Res> {
  __$TicketProcessingResponseCopyWithImpl(this._self, this._then);

  final _TicketProcessingResponse _self;
  final $Res Function(_TicketProcessingResponse) _then;

/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,}) {
  return _then(_TicketProcessingResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TicketData?,
  ));
}

/// Create a copy of TicketProcessingResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TicketDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
