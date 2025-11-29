// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ticket {

 String get id; String get storeName; DateTime get date; List<Product> get products; String? get transactionId; String? get time; double? get finalTotal; Map<String, double> get taxBreakdown;
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCopyWith<Ticket> get copyWith => _$TicketCopyWithImpl<Ticket>(this as Ticket, _$identity);

  /// Serializes this Ticket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.time, time) || other.time == time)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&const DeepCollectionEquality().equals(other.taxBreakdown, taxBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeName,date,const DeepCollectionEquality().hash(products),transactionId,time,finalTotal,const DeepCollectionEquality().hash(taxBreakdown));

@override
String toString() {
  return 'Ticket(id: $id, storeName: $storeName, date: $date, products: $products, transactionId: $transactionId, time: $time, finalTotal: $finalTotal, taxBreakdown: $taxBreakdown)';
}


}

/// @nodoc
abstract mixin class $TicketCopyWith<$Res>  {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) _then) = _$TicketCopyWithImpl;
@useResult
$Res call({
 String id, String storeName, DateTime date, List<Product> products, String? transactionId, String? time, double? finalTotal, Map<String, double> taxBreakdown
});




}
/// @nodoc
class _$TicketCopyWithImpl<$Res>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._self, this._then);

  final Ticket _self;
  final $Res Function(Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeName = null,Object? date = null,Object? products = null,Object? transactionId = freezed,Object? time = freezed,Object? finalTotal = freezed,Object? taxBreakdown = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,finalTotal: freezed == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double?,taxBreakdown: null == taxBreakdown ? _self.taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Ticket].
extension TicketPatterns on Ticket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ticket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ticket value)  $default,){
final _that = this;
switch (_that) {
case _Ticket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ticket value)?  $default,){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeName,  DateTime date,  List<Product> products,  String? transactionId,  String? time,  double? finalTotal,  Map<String, double> taxBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.storeName,_that.date,_that.products,_that.transactionId,_that.time,_that.finalTotal,_that.taxBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeName,  DateTime date,  List<Product> products,  String? transactionId,  String? time,  double? finalTotal,  Map<String, double> taxBreakdown)  $default,) {final _that = this;
switch (_that) {
case _Ticket():
return $default(_that.id,_that.storeName,_that.date,_that.products,_that.transactionId,_that.time,_that.finalTotal,_that.taxBreakdown);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeName,  DateTime date,  List<Product> products,  String? transactionId,  String? time,  double? finalTotal,  Map<String, double> taxBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.storeName,_that.date,_that.products,_that.transactionId,_that.time,_that.finalTotal,_that.taxBreakdown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ticket implements Ticket {
  const _Ticket({required this.id, required this.storeName, required this.date, required final  List<Product> products, this.transactionId, this.time, this.finalTotal, final  Map<String, double> taxBreakdown = const {}}): _products = products,_taxBreakdown = taxBreakdown;
  factory _Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

@override final  String id;
@override final  String storeName;
@override final  DateTime date;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override final  String? transactionId;
@override final  String? time;
@override final  double? finalTotal;
 final  Map<String, double> _taxBreakdown;
@override@JsonKey() Map<String, double> get taxBreakdown {
  if (_taxBreakdown is EqualUnmodifiableMapView) return _taxBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_taxBreakdown);
}


/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCopyWith<_Ticket> get copyWith => __$TicketCopyWithImpl<_Ticket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.time, time) || other.time == time)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&const DeepCollectionEquality().equals(other._taxBreakdown, _taxBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeName,date,const DeepCollectionEquality().hash(_products),transactionId,time,finalTotal,const DeepCollectionEquality().hash(_taxBreakdown));

@override
String toString() {
  return 'Ticket(id: $id, storeName: $storeName, date: $date, products: $products, transactionId: $transactionId, time: $time, finalTotal: $finalTotal, taxBreakdown: $taxBreakdown)';
}


}

/// @nodoc
abstract mixin class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) _then) = __$TicketCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeName, DateTime date, List<Product> products, String? transactionId, String? time, double? finalTotal, Map<String, double> taxBreakdown
});




}
/// @nodoc
class __$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(this._self, this._then);

  final _Ticket _self;
  final $Res Function(_Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeName = null,Object? date = null,Object? products = null,Object? transactionId = freezed,Object? time = freezed,Object? finalTotal = freezed,Object? taxBreakdown = null,}) {
  return _then(_Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,finalTotal: freezed == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double?,taxBreakdown: null == taxBreakdown ? _self._taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
