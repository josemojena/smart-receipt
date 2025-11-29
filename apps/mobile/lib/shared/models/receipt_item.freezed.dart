// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptItem {

@JsonKey(name: 'original_name') String? get originalName;@JsonKey(name: 'normalized_name') String? get normalizedName; String? get category; double? get quantity;@JsonKey(name: 'unit_of_measure') String? get unitOfMeasure;@JsonKey(name: 'base_quantity') double? get baseQuantity;@JsonKey(name: 'base_unit_name') String? get baseUnitName;@JsonKey(name: 'paid_price') double? get paidPrice;@JsonKey(name: 'real_unit_price') double? get realUnitPrice;@JsonKey(name: 'original_quantity_raw') String? get originalQuantityRaw;@JsonKey(name: 'original_unit_of_measure_raw') String? get originalUnitOfMeasureRaw;@JsonKey(name: 'original_price_raw') double? get originalPriceRaw;
/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemCopyWith<ReceiptItem> get copyWith => _$ReceiptItemCopyWithImpl<ReceiptItem>(this as ReceiptItem, _$identity);

  /// Serializes this ReceiptItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItem&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitOfMeasure, unitOfMeasure) || other.unitOfMeasure == unitOfMeasure)&&(identical(other.baseQuantity, baseQuantity) || other.baseQuantity == baseQuantity)&&(identical(other.baseUnitName, baseUnitName) || other.baseUnitName == baseUnitName)&&(identical(other.paidPrice, paidPrice) || other.paidPrice == paidPrice)&&(identical(other.realUnitPrice, realUnitPrice) || other.realUnitPrice == realUnitPrice)&&(identical(other.originalQuantityRaw, originalQuantityRaw) || other.originalQuantityRaw == originalQuantityRaw)&&(identical(other.originalUnitOfMeasureRaw, originalUnitOfMeasureRaw) || other.originalUnitOfMeasureRaw == originalUnitOfMeasureRaw)&&(identical(other.originalPriceRaw, originalPriceRaw) || other.originalPriceRaw == originalPriceRaw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalName,normalizedName,category,quantity,unitOfMeasure,baseQuantity,baseUnitName,paidPrice,realUnitPrice,originalQuantityRaw,originalUnitOfMeasureRaw,originalPriceRaw);

@override
String toString() {
  return 'ReceiptItem(originalName: $originalName, normalizedName: $normalizedName, category: $category, quantity: $quantity, unitOfMeasure: $unitOfMeasure, baseQuantity: $baseQuantity, baseUnitName: $baseUnitName, paidPrice: $paidPrice, realUnitPrice: $realUnitPrice, originalQuantityRaw: $originalQuantityRaw, originalUnitOfMeasureRaw: $originalUnitOfMeasureRaw, originalPriceRaw: $originalPriceRaw)';
}


}

/// @nodoc
abstract mixin class $ReceiptItemCopyWith<$Res>  {
  factory $ReceiptItemCopyWith(ReceiptItem value, $Res Function(ReceiptItem) _then) = _$ReceiptItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'original_name') String? originalName,@JsonKey(name: 'normalized_name') String? normalizedName, String? category, double? quantity,@JsonKey(name: 'unit_of_measure') String? unitOfMeasure,@JsonKey(name: 'base_quantity') double? baseQuantity,@JsonKey(name: 'base_unit_name') String? baseUnitName,@JsonKey(name: 'paid_price') double? paidPrice,@JsonKey(name: 'real_unit_price') double? realUnitPrice,@JsonKey(name: 'original_quantity_raw') String? originalQuantityRaw,@JsonKey(name: 'original_unit_of_measure_raw') String? originalUnitOfMeasureRaw,@JsonKey(name: 'original_price_raw') double? originalPriceRaw
});




}
/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._self, this._then);

  final ReceiptItem _self;
  final $Res Function(ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalName = freezed,Object? normalizedName = freezed,Object? category = freezed,Object? quantity = freezed,Object? unitOfMeasure = freezed,Object? baseQuantity = freezed,Object? baseUnitName = freezed,Object? paidPrice = freezed,Object? realUnitPrice = freezed,Object? originalQuantityRaw = freezed,Object? originalUnitOfMeasureRaw = freezed,Object? originalPriceRaw = freezed,}) {
  return _then(_self.copyWith(
originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,normalizedName: freezed == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unitOfMeasure: freezed == unitOfMeasure ? _self.unitOfMeasure : unitOfMeasure // ignore: cast_nullable_to_non_nullable
as String?,baseQuantity: freezed == baseQuantity ? _self.baseQuantity : baseQuantity // ignore: cast_nullable_to_non_nullable
as double?,baseUnitName: freezed == baseUnitName ? _self.baseUnitName : baseUnitName // ignore: cast_nullable_to_non_nullable
as String?,paidPrice: freezed == paidPrice ? _self.paidPrice : paidPrice // ignore: cast_nullable_to_non_nullable
as double?,realUnitPrice: freezed == realUnitPrice ? _self.realUnitPrice : realUnitPrice // ignore: cast_nullable_to_non_nullable
as double?,originalQuantityRaw: freezed == originalQuantityRaw ? _self.originalQuantityRaw : originalQuantityRaw // ignore: cast_nullable_to_non_nullable
as String?,originalUnitOfMeasureRaw: freezed == originalUnitOfMeasureRaw ? _self.originalUnitOfMeasureRaw : originalUnitOfMeasureRaw // ignore: cast_nullable_to_non_nullable
as String?,originalPriceRaw: freezed == originalPriceRaw ? _self.originalPriceRaw : originalPriceRaw // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItem].
extension ReceiptItemPatterns on ReceiptItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'original_name')  String? originalName, @JsonKey(name: 'normalized_name')  String? normalizedName,  String? category,  double? quantity, @JsonKey(name: 'unit_of_measure')  String? unitOfMeasure, @JsonKey(name: 'base_quantity')  double? baseQuantity, @JsonKey(name: 'base_unit_name')  String? baseUnitName, @JsonKey(name: 'paid_price')  double? paidPrice, @JsonKey(name: 'real_unit_price')  double? realUnitPrice, @JsonKey(name: 'original_quantity_raw')  String? originalQuantityRaw, @JsonKey(name: 'original_unit_of_measure_raw')  String? originalUnitOfMeasureRaw, @JsonKey(name: 'original_price_raw')  double? originalPriceRaw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.originalName,_that.normalizedName,_that.category,_that.quantity,_that.unitOfMeasure,_that.baseQuantity,_that.baseUnitName,_that.paidPrice,_that.realUnitPrice,_that.originalQuantityRaw,_that.originalUnitOfMeasureRaw,_that.originalPriceRaw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'original_name')  String? originalName, @JsonKey(name: 'normalized_name')  String? normalizedName,  String? category,  double? quantity, @JsonKey(name: 'unit_of_measure')  String? unitOfMeasure, @JsonKey(name: 'base_quantity')  double? baseQuantity, @JsonKey(name: 'base_unit_name')  String? baseUnitName, @JsonKey(name: 'paid_price')  double? paidPrice, @JsonKey(name: 'real_unit_price')  double? realUnitPrice, @JsonKey(name: 'original_quantity_raw')  String? originalQuantityRaw, @JsonKey(name: 'original_unit_of_measure_raw')  String? originalUnitOfMeasureRaw, @JsonKey(name: 'original_price_raw')  double? originalPriceRaw)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem():
return $default(_that.originalName,_that.normalizedName,_that.category,_that.quantity,_that.unitOfMeasure,_that.baseQuantity,_that.baseUnitName,_that.paidPrice,_that.realUnitPrice,_that.originalQuantityRaw,_that.originalUnitOfMeasureRaw,_that.originalPriceRaw);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'original_name')  String? originalName, @JsonKey(name: 'normalized_name')  String? normalizedName,  String? category,  double? quantity, @JsonKey(name: 'unit_of_measure')  String? unitOfMeasure, @JsonKey(name: 'base_quantity')  double? baseQuantity, @JsonKey(name: 'base_unit_name')  String? baseUnitName, @JsonKey(name: 'paid_price')  double? paidPrice, @JsonKey(name: 'real_unit_price')  double? realUnitPrice, @JsonKey(name: 'original_quantity_raw')  String? originalQuantityRaw, @JsonKey(name: 'original_unit_of_measure_raw')  String? originalUnitOfMeasureRaw, @JsonKey(name: 'original_price_raw')  double? originalPriceRaw)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.originalName,_that.normalizedName,_that.category,_that.quantity,_that.unitOfMeasure,_that.baseQuantity,_that.baseUnitName,_that.paidPrice,_that.realUnitPrice,_that.originalQuantityRaw,_that.originalUnitOfMeasureRaw,_that.originalPriceRaw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItem implements ReceiptItem {
  const _ReceiptItem({@JsonKey(name: 'original_name') required this.originalName, @JsonKey(name: 'normalized_name') required this.normalizedName, required this.category, required this.quantity, @JsonKey(name: 'unit_of_measure') required this.unitOfMeasure, @JsonKey(name: 'base_quantity') required this.baseQuantity, @JsonKey(name: 'base_unit_name') required this.baseUnitName, @JsonKey(name: 'paid_price') required this.paidPrice, @JsonKey(name: 'real_unit_price') required this.realUnitPrice, @JsonKey(name: 'original_quantity_raw') this.originalQuantityRaw, @JsonKey(name: 'original_unit_of_measure_raw') this.originalUnitOfMeasureRaw, @JsonKey(name: 'original_price_raw') this.originalPriceRaw});
  factory _ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);

@override@JsonKey(name: 'original_name') final  String? originalName;
@override@JsonKey(name: 'normalized_name') final  String? normalizedName;
@override final  String? category;
@override final  double? quantity;
@override@JsonKey(name: 'unit_of_measure') final  String? unitOfMeasure;
@override@JsonKey(name: 'base_quantity') final  double? baseQuantity;
@override@JsonKey(name: 'base_unit_name') final  String? baseUnitName;
@override@JsonKey(name: 'paid_price') final  double? paidPrice;
@override@JsonKey(name: 'real_unit_price') final  double? realUnitPrice;
@override@JsonKey(name: 'original_quantity_raw') final  String? originalQuantityRaw;
@override@JsonKey(name: 'original_unit_of_measure_raw') final  String? originalUnitOfMeasureRaw;
@override@JsonKey(name: 'original_price_raw') final  double? originalPriceRaw;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemCopyWith<_ReceiptItem> get copyWith => __$ReceiptItemCopyWithImpl<_ReceiptItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItem&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitOfMeasure, unitOfMeasure) || other.unitOfMeasure == unitOfMeasure)&&(identical(other.baseQuantity, baseQuantity) || other.baseQuantity == baseQuantity)&&(identical(other.baseUnitName, baseUnitName) || other.baseUnitName == baseUnitName)&&(identical(other.paidPrice, paidPrice) || other.paidPrice == paidPrice)&&(identical(other.realUnitPrice, realUnitPrice) || other.realUnitPrice == realUnitPrice)&&(identical(other.originalQuantityRaw, originalQuantityRaw) || other.originalQuantityRaw == originalQuantityRaw)&&(identical(other.originalUnitOfMeasureRaw, originalUnitOfMeasureRaw) || other.originalUnitOfMeasureRaw == originalUnitOfMeasureRaw)&&(identical(other.originalPriceRaw, originalPriceRaw) || other.originalPriceRaw == originalPriceRaw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalName,normalizedName,category,quantity,unitOfMeasure,baseQuantity,baseUnitName,paidPrice,realUnitPrice,originalQuantityRaw,originalUnitOfMeasureRaw,originalPriceRaw);

@override
String toString() {
  return 'ReceiptItem(originalName: $originalName, normalizedName: $normalizedName, category: $category, quantity: $quantity, unitOfMeasure: $unitOfMeasure, baseQuantity: $baseQuantity, baseUnitName: $baseUnitName, paidPrice: $paidPrice, realUnitPrice: $realUnitPrice, originalQuantityRaw: $originalQuantityRaw, originalUnitOfMeasureRaw: $originalUnitOfMeasureRaw, originalPriceRaw: $originalPriceRaw)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemCopyWith<$Res> implements $ReceiptItemCopyWith<$Res> {
  factory _$ReceiptItemCopyWith(_ReceiptItem value, $Res Function(_ReceiptItem) _then) = __$ReceiptItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'original_name') String? originalName,@JsonKey(name: 'normalized_name') String? normalizedName, String? category, double? quantity,@JsonKey(name: 'unit_of_measure') String? unitOfMeasure,@JsonKey(name: 'base_quantity') double? baseQuantity,@JsonKey(name: 'base_unit_name') String? baseUnitName,@JsonKey(name: 'paid_price') double? paidPrice,@JsonKey(name: 'real_unit_price') double? realUnitPrice,@JsonKey(name: 'original_quantity_raw') String? originalQuantityRaw,@JsonKey(name: 'original_unit_of_measure_raw') String? originalUnitOfMeasureRaw,@JsonKey(name: 'original_price_raw') double? originalPriceRaw
});




}
/// @nodoc
class __$ReceiptItemCopyWithImpl<$Res>
    implements _$ReceiptItemCopyWith<$Res> {
  __$ReceiptItemCopyWithImpl(this._self, this._then);

  final _ReceiptItem _self;
  final $Res Function(_ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalName = freezed,Object? normalizedName = freezed,Object? category = freezed,Object? quantity = freezed,Object? unitOfMeasure = freezed,Object? baseQuantity = freezed,Object? baseUnitName = freezed,Object? paidPrice = freezed,Object? realUnitPrice = freezed,Object? originalQuantityRaw = freezed,Object? originalUnitOfMeasureRaw = freezed,Object? originalPriceRaw = freezed,}) {
  return _then(_ReceiptItem(
originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,normalizedName: freezed == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unitOfMeasure: freezed == unitOfMeasure ? _self.unitOfMeasure : unitOfMeasure // ignore: cast_nullable_to_non_nullable
as String?,baseQuantity: freezed == baseQuantity ? _self.baseQuantity : baseQuantity // ignore: cast_nullable_to_non_nullable
as double?,baseUnitName: freezed == baseUnitName ? _self.baseUnitName : baseUnitName // ignore: cast_nullable_to_non_nullable
as String?,paidPrice: freezed == paidPrice ? _self.paidPrice : paidPrice // ignore: cast_nullable_to_non_nullable
as double?,realUnitPrice: freezed == realUnitPrice ? _self.realUnitPrice : realUnitPrice // ignore: cast_nullable_to_non_nullable
as double?,originalQuantityRaw: freezed == originalQuantityRaw ? _self.originalQuantityRaw : originalQuantityRaw // ignore: cast_nullable_to_non_nullable
as String?,originalUnitOfMeasureRaw: freezed == originalUnitOfMeasureRaw ? _self.originalUnitOfMeasureRaw : originalUnitOfMeasureRaw // ignore: cast_nullable_to_non_nullable
as String?,originalPriceRaw: freezed == originalPriceRaw ? _self.originalPriceRaw : originalPriceRaw // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
