// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TicketData {

 String? get store;@JsonKey(name: 'transaction_id') String? get transactionId; String? get date; String? get time;@JsonKey(name: 'final_total') double? get finalTotal;@JsonKey(name: 'tax_breakdown') Map<String, double> get taxBreakdown; List<ReceiptItem> get items;
/// Create a copy of TicketData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketDataCopyWith<TicketData> get copyWith => _$TicketDataCopyWithImpl<TicketData>(this as TicketData, _$identity);

  /// Serializes this TicketData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketData&&(identical(other.store, store) || other.store == store)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&const DeepCollectionEquality().equals(other.taxBreakdown, taxBreakdown)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,store,transactionId,date,time,finalTotal,const DeepCollectionEquality().hash(taxBreakdown),const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TicketData(store: $store, transactionId: $transactionId, date: $date, time: $time, finalTotal: $finalTotal, taxBreakdown: $taxBreakdown, items: $items)';
}


}

/// @nodoc
abstract mixin class $TicketDataCopyWith<$Res>  {
  factory $TicketDataCopyWith(TicketData value, $Res Function(TicketData) _then) = _$TicketDataCopyWithImpl;
@useResult
$Res call({
 String? store,@JsonKey(name: 'transaction_id') String? transactionId, String? date, String? time,@JsonKey(name: 'final_total') double? finalTotal,@JsonKey(name: 'tax_breakdown') Map<String, double> taxBreakdown, List<ReceiptItem> items
});




}
/// @nodoc
class _$TicketDataCopyWithImpl<$Res>
    implements $TicketDataCopyWith<$Res> {
  _$TicketDataCopyWithImpl(this._self, this._then);

  final TicketData _self;
  final $Res Function(TicketData) _then;

/// Create a copy of TicketData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? store = freezed,Object? transactionId = freezed,Object? date = freezed,Object? time = freezed,Object? finalTotal = freezed,Object? taxBreakdown = null,Object? items = null,}) {
  return _then(_self.copyWith(
store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,finalTotal: freezed == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double?,taxBreakdown: null == taxBreakdown ? _self.taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketData].
extension TicketDataPatterns on TicketData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketData value)  $default,){
final _that = this;
switch (_that) {
case _TicketData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketData value)?  $default,){
final _that = this;
switch (_that) {
case _TicketData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? store, @JsonKey(name: 'transaction_id')  String? transactionId,  String? date,  String? time, @JsonKey(name: 'final_total')  double? finalTotal, @JsonKey(name: 'tax_breakdown')  Map<String, double> taxBreakdown,  List<ReceiptItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketData() when $default != null:
return $default(_that.store,_that.transactionId,_that.date,_that.time,_that.finalTotal,_that.taxBreakdown,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? store, @JsonKey(name: 'transaction_id')  String? transactionId,  String? date,  String? time, @JsonKey(name: 'final_total')  double? finalTotal, @JsonKey(name: 'tax_breakdown')  Map<String, double> taxBreakdown,  List<ReceiptItem> items)  $default,) {final _that = this;
switch (_that) {
case _TicketData():
return $default(_that.store,_that.transactionId,_that.date,_that.time,_that.finalTotal,_that.taxBreakdown,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? store, @JsonKey(name: 'transaction_id')  String? transactionId,  String? date,  String? time, @JsonKey(name: 'final_total')  double? finalTotal, @JsonKey(name: 'tax_breakdown')  Map<String, double> taxBreakdown,  List<ReceiptItem> items)?  $default,) {final _that = this;
switch (_that) {
case _TicketData() when $default != null:
return $default(_that.store,_that.transactionId,_that.date,_that.time,_that.finalTotal,_that.taxBreakdown,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketData implements TicketData {
  const _TicketData({required this.store, @JsonKey(name: 'transaction_id') required this.transactionId, required this.date, required this.time, @JsonKey(name: 'final_total') required this.finalTotal, @JsonKey(name: 'tax_breakdown') final  Map<String, double> taxBreakdown = const {}, required final  List<ReceiptItem> items}): _taxBreakdown = taxBreakdown,_items = items;
  factory _TicketData.fromJson(Map<String, dynamic> json) => _$TicketDataFromJson(json);

@override final  String? store;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override final  String? date;
@override final  String? time;
@override@JsonKey(name: 'final_total') final  double? finalTotal;
 final  Map<String, double> _taxBreakdown;
@override@JsonKey(name: 'tax_breakdown') Map<String, double> get taxBreakdown {
  if (_taxBreakdown is EqualUnmodifiableMapView) return _taxBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_taxBreakdown);
}

 final  List<ReceiptItem> _items;
@override List<ReceiptItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TicketData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketDataCopyWith<_TicketData> get copyWith => __$TicketDataCopyWithImpl<_TicketData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketData&&(identical(other.store, store) || other.store == store)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.finalTotal, finalTotal) || other.finalTotal == finalTotal)&&const DeepCollectionEquality().equals(other._taxBreakdown, _taxBreakdown)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,store,transactionId,date,time,finalTotal,const DeepCollectionEquality().hash(_taxBreakdown),const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TicketData(store: $store, transactionId: $transactionId, date: $date, time: $time, finalTotal: $finalTotal, taxBreakdown: $taxBreakdown, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TicketDataCopyWith<$Res> implements $TicketDataCopyWith<$Res> {
  factory _$TicketDataCopyWith(_TicketData value, $Res Function(_TicketData) _then) = __$TicketDataCopyWithImpl;
@override @useResult
$Res call({
 String? store,@JsonKey(name: 'transaction_id') String? transactionId, String? date, String? time,@JsonKey(name: 'final_total') double? finalTotal,@JsonKey(name: 'tax_breakdown') Map<String, double> taxBreakdown, List<ReceiptItem> items
});




}
/// @nodoc
class __$TicketDataCopyWithImpl<$Res>
    implements _$TicketDataCopyWith<$Res> {
  __$TicketDataCopyWithImpl(this._self, this._then);

  final _TicketData _self;
  final $Res Function(_TicketData) _then;

/// Create a copy of TicketData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = freezed,Object? transactionId = freezed,Object? date = freezed,Object? time = freezed,Object? finalTotal = freezed,Object? taxBreakdown = null,Object? items = null,}) {
  return _then(_TicketData(
store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,finalTotal: freezed == finalTotal ? _self.finalTotal : finalTotal // ignore: cast_nullable_to_non_nullable
as double?,taxBreakdown: null == taxBreakdown ? _self._taxBreakdown : taxBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}


}

// dart format on
