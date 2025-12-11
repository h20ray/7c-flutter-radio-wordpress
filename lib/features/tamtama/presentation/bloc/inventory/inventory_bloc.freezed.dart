// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryEvent()';
}


}

/// @nodoc
class $InventoryEventCopyWith<$Res>  {
$InventoryEventCopyWith(InventoryEvent _, $Res Function(InventoryEvent) __);
}


/// Adds pattern-matching-related methods to [InventoryEvent].
extension InventoryEventPatterns on InventoryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadInventoryEvent value)?  load,TResult Function( AddItemEvent value)?  addItem,TResult Function( RemoveItemEvent value)?  removeItem,TResult Function( UseItemEvent value)?  useItem,TResult Function( PurchaseItemEvent value)?  purchase,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadInventoryEvent() when load != null:
return load(_that);case AddItemEvent() when addItem != null:
return addItem(_that);case RemoveItemEvent() when removeItem != null:
return removeItem(_that);case UseItemEvent() when useItem != null:
return useItem(_that);case PurchaseItemEvent() when purchase != null:
return purchase(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadInventoryEvent value)  load,required TResult Function( AddItemEvent value)  addItem,required TResult Function( RemoveItemEvent value)  removeItem,required TResult Function( UseItemEvent value)  useItem,required TResult Function( PurchaseItemEvent value)  purchase,}){
final _that = this;
switch (_that) {
case LoadInventoryEvent():
return load(_that);case AddItemEvent():
return addItem(_that);case RemoveItemEvent():
return removeItem(_that);case UseItemEvent():
return useItem(_that);case PurchaseItemEvent():
return purchase(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadInventoryEvent value)?  load,TResult? Function( AddItemEvent value)?  addItem,TResult? Function( RemoveItemEvent value)?  removeItem,TResult? Function( UseItemEvent value)?  useItem,TResult? Function( PurchaseItemEvent value)?  purchase,}){
final _that = this;
switch (_that) {
case LoadInventoryEvent() when load != null:
return load(_that);case AddItemEvent() when addItem != null:
return addItem(_that);case RemoveItemEvent() when removeItem != null:
return removeItem(_that);case UseItemEvent() when useItem != null:
return useItem(_that);case PurchaseItemEvent() when purchase != null:
return purchase(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function( String itemId,  int quantity)?  addItem,TResult Function( String itemId,  int quantity)?  removeItem,TResult Function( String itemId)?  useItem,TResult Function( String itemId,  int currentCoins,  int quantity)?  purchase,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadInventoryEvent() when load != null:
return load();case AddItemEvent() when addItem != null:
return addItem(_that.itemId,_that.quantity);case RemoveItemEvent() when removeItem != null:
return removeItem(_that.itemId,_that.quantity);case UseItemEvent() when useItem != null:
return useItem(_that.itemId);case PurchaseItemEvent() when purchase != null:
return purchase(_that.itemId,_that.currentCoins,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function( String itemId,  int quantity)  addItem,required TResult Function( String itemId,  int quantity)  removeItem,required TResult Function( String itemId)  useItem,required TResult Function( String itemId,  int currentCoins,  int quantity)  purchase,}) {final _that = this;
switch (_that) {
case LoadInventoryEvent():
return load();case AddItemEvent():
return addItem(_that.itemId,_that.quantity);case RemoveItemEvent():
return removeItem(_that.itemId,_that.quantity);case UseItemEvent():
return useItem(_that.itemId);case PurchaseItemEvent():
return purchase(_that.itemId,_that.currentCoins,_that.quantity);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function( String itemId,  int quantity)?  addItem,TResult? Function( String itemId,  int quantity)?  removeItem,TResult? Function( String itemId)?  useItem,TResult? Function( String itemId,  int currentCoins,  int quantity)?  purchase,}) {final _that = this;
switch (_that) {
case LoadInventoryEvent() when load != null:
return load();case AddItemEvent() when addItem != null:
return addItem(_that.itemId,_that.quantity);case RemoveItemEvent() when removeItem != null:
return removeItem(_that.itemId,_that.quantity);case UseItemEvent() when useItem != null:
return useItem(_that.itemId);case PurchaseItemEvent() when purchase != null:
return purchase(_that.itemId,_that.currentCoins,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class LoadInventoryEvent implements InventoryEvent {
  const LoadInventoryEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadInventoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryEvent.load()';
}


}




/// @nodoc


class AddItemEvent implements InventoryEvent {
  const AddItemEvent({required this.itemId, this.quantity = 1});
  

 final  String itemId;
@JsonKey() final  int quantity;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddItemEventCopyWith<AddItemEvent> get copyWith => _$AddItemEventCopyWithImpl<AddItemEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemEvent&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,quantity);

@override
String toString() {
  return 'InventoryEvent.addItem(itemId: $itemId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $AddItemEventCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory $AddItemEventCopyWith(AddItemEvent value, $Res Function(AddItemEvent) _then) = _$AddItemEventCopyWithImpl;
@useResult
$Res call({
 String itemId, int quantity
});




}
/// @nodoc
class _$AddItemEventCopyWithImpl<$Res>
    implements $AddItemEventCopyWith<$Res> {
  _$AddItemEventCopyWithImpl(this._self, this._then);

  final AddItemEvent _self;
  final $Res Function(AddItemEvent) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,}) {
  return _then(AddItemEvent(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RemoveItemEvent implements InventoryEvent {
  const RemoveItemEvent({required this.itemId, this.quantity = 1});
  

 final  String itemId;
@JsonKey() final  int quantity;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveItemEventCopyWith<RemoveItemEvent> get copyWith => _$RemoveItemEventCopyWithImpl<RemoveItemEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveItemEvent&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,quantity);

@override
String toString() {
  return 'InventoryEvent.removeItem(itemId: $itemId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $RemoveItemEventCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory $RemoveItemEventCopyWith(RemoveItemEvent value, $Res Function(RemoveItemEvent) _then) = _$RemoveItemEventCopyWithImpl;
@useResult
$Res call({
 String itemId, int quantity
});




}
/// @nodoc
class _$RemoveItemEventCopyWithImpl<$Res>
    implements $RemoveItemEventCopyWith<$Res> {
  _$RemoveItemEventCopyWithImpl(this._self, this._then);

  final RemoveItemEvent _self;
  final $Res Function(RemoveItemEvent) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,}) {
  return _then(RemoveItemEvent(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UseItemEvent implements InventoryEvent {
  const UseItemEvent(this.itemId);
  

 final  String itemId;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UseItemEventCopyWith<UseItemEvent> get copyWith => _$UseItemEventCopyWithImpl<UseItemEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UseItemEvent&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'InventoryEvent.useItem(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class $UseItemEventCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory $UseItemEventCopyWith(UseItemEvent value, $Res Function(UseItemEvent) _then) = _$UseItemEventCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class _$UseItemEventCopyWithImpl<$Res>
    implements $UseItemEventCopyWith<$Res> {
  _$UseItemEventCopyWithImpl(this._self, this._then);

  final UseItemEvent _self;
  final $Res Function(UseItemEvent) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(UseItemEvent(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PurchaseItemEvent implements InventoryEvent {
  const PurchaseItemEvent({required this.itemId, required this.currentCoins, this.quantity = 1});
  

 final  String itemId;
 final  int currentCoins;
@JsonKey() final  int quantity;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseItemEventCopyWith<PurchaseItemEvent> get copyWith => _$PurchaseItemEventCopyWithImpl<PurchaseItemEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseItemEvent&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.currentCoins, currentCoins) || other.currentCoins == currentCoins)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,currentCoins,quantity);

@override
String toString() {
  return 'InventoryEvent.purchase(itemId: $itemId, currentCoins: $currentCoins, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $PurchaseItemEventCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory $PurchaseItemEventCopyWith(PurchaseItemEvent value, $Res Function(PurchaseItemEvent) _then) = _$PurchaseItemEventCopyWithImpl;
@useResult
$Res call({
 String itemId, int currentCoins, int quantity
});




}
/// @nodoc
class _$PurchaseItemEventCopyWithImpl<$Res>
    implements $PurchaseItemEventCopyWith<$Res> {
  _$PurchaseItemEventCopyWithImpl(this._self, this._then);

  final PurchaseItemEvent _self;
  final $Res Function(PurchaseItemEvent) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? currentCoins = null,Object? quantity = null,}) {
  return _then(PurchaseItemEvent(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,currentCoins: null == currentCoins ? _self.currentCoins : currentCoins // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$InventoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState()';
}


}

/// @nodoc
class $InventoryStateCopyWith<$Res>  {
$InventoryStateCopyWith(InventoryState _, $Res Function(InventoryState) __);
}


/// Adds pattern-matching-related methods to [InventoryState].
extension InventoryStatePatterns on InventoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InventoryInitial value)?  initial,TResult Function( InventoryLoading value)?  loading,TResult Function( InventoryLoaded value)?  loaded,TResult Function( InventoryItemUsed value)?  itemUsed,TResult Function( InventoryPurchaseSuccess value)?  purchaseSuccess,TResult Function( InventoryPurchaseFailed value)?  purchaseFailed,TResult Function( InventoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InventoryInitial() when initial != null:
return initial(_that);case InventoryLoading() when loading != null:
return loading(_that);case InventoryLoaded() when loaded != null:
return loaded(_that);case InventoryItemUsed() when itemUsed != null:
return itemUsed(_that);case InventoryPurchaseSuccess() when purchaseSuccess != null:
return purchaseSuccess(_that);case InventoryPurchaseFailed() when purchaseFailed != null:
return purchaseFailed(_that);case InventoryError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InventoryInitial value)  initial,required TResult Function( InventoryLoading value)  loading,required TResult Function( InventoryLoaded value)  loaded,required TResult Function( InventoryItemUsed value)  itemUsed,required TResult Function( InventoryPurchaseSuccess value)  purchaseSuccess,required TResult Function( InventoryPurchaseFailed value)  purchaseFailed,required TResult Function( InventoryError value)  error,}){
final _that = this;
switch (_that) {
case InventoryInitial():
return initial(_that);case InventoryLoading():
return loading(_that);case InventoryLoaded():
return loaded(_that);case InventoryItemUsed():
return itemUsed(_that);case InventoryPurchaseSuccess():
return purchaseSuccess(_that);case InventoryPurchaseFailed():
return purchaseFailed(_that);case InventoryError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InventoryInitial value)?  initial,TResult? Function( InventoryLoading value)?  loading,TResult? Function( InventoryLoaded value)?  loaded,TResult? Function( InventoryItemUsed value)?  itemUsed,TResult? Function( InventoryPurchaseSuccess value)?  purchaseSuccess,TResult? Function( InventoryPurchaseFailed value)?  purchaseFailed,TResult? Function( InventoryError value)?  error,}){
final _that = this;
switch (_that) {
case InventoryInitial() when initial != null:
return initial(_that);case InventoryLoading() when loading != null:
return loading(_that);case InventoryLoaded() when loaded != null:
return loaded(_that);case InventoryItemUsed() when itemUsed != null:
return itemUsed(_that);case InventoryPurchaseSuccess() when purchaseSuccess != null:
return purchaseSuccess(_that);case InventoryPurchaseFailed() when purchaseFailed != null:
return purchaseFailed(_that);case InventoryError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( InventoryEntity inventory)?  loaded,TResult Function( String itemId,  Map<String, double> effects)?  itemUsed,TResult Function( String itemId,  int quantity,  int cost)?  purchaseSuccess,TResult Function( String reason)?  purchaseFailed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InventoryInitial() when initial != null:
return initial();case InventoryLoading() when loading != null:
return loading();case InventoryLoaded() when loaded != null:
return loaded(_that.inventory);case InventoryItemUsed() when itemUsed != null:
return itemUsed(_that.itemId,_that.effects);case InventoryPurchaseSuccess() when purchaseSuccess != null:
return purchaseSuccess(_that.itemId,_that.quantity,_that.cost);case InventoryPurchaseFailed() when purchaseFailed != null:
return purchaseFailed(_that.reason);case InventoryError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( InventoryEntity inventory)  loaded,required TResult Function( String itemId,  Map<String, double> effects)  itemUsed,required TResult Function( String itemId,  int quantity,  int cost)  purchaseSuccess,required TResult Function( String reason)  purchaseFailed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case InventoryInitial():
return initial();case InventoryLoading():
return loading();case InventoryLoaded():
return loaded(_that.inventory);case InventoryItemUsed():
return itemUsed(_that.itemId,_that.effects);case InventoryPurchaseSuccess():
return purchaseSuccess(_that.itemId,_that.quantity,_that.cost);case InventoryPurchaseFailed():
return purchaseFailed(_that.reason);case InventoryError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( InventoryEntity inventory)?  loaded,TResult? Function( String itemId,  Map<String, double> effects)?  itemUsed,TResult? Function( String itemId,  int quantity,  int cost)?  purchaseSuccess,TResult? Function( String reason)?  purchaseFailed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case InventoryInitial() when initial != null:
return initial();case InventoryLoading() when loading != null:
return loading();case InventoryLoaded() when loaded != null:
return loaded(_that.inventory);case InventoryItemUsed() when itemUsed != null:
return itemUsed(_that.itemId,_that.effects);case InventoryPurchaseSuccess() when purchaseSuccess != null:
return purchaseSuccess(_that.itemId,_that.quantity,_that.cost);case InventoryPurchaseFailed() when purchaseFailed != null:
return purchaseFailed(_that.reason);case InventoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class InventoryInitial implements InventoryState {
  const InventoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState.initial()';
}


}




/// @nodoc


class InventoryLoading implements InventoryState {
  const InventoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState.loading()';
}


}




/// @nodoc


class InventoryLoaded implements InventoryState {
  const InventoryLoaded({required this.inventory});
  

 final  InventoryEntity inventory;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryLoadedCopyWith<InventoryLoaded> get copyWith => _$InventoryLoadedCopyWithImpl<InventoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryLoaded&&(identical(other.inventory, inventory) || other.inventory == inventory));
}


@override
int get hashCode => Object.hash(runtimeType,inventory);

@override
String toString() {
  return 'InventoryState.loaded(inventory: $inventory)';
}


}

/// @nodoc
abstract mixin class $InventoryLoadedCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryLoadedCopyWith(InventoryLoaded value, $Res Function(InventoryLoaded) _then) = _$InventoryLoadedCopyWithImpl;
@useResult
$Res call({
 InventoryEntity inventory
});




}
/// @nodoc
class _$InventoryLoadedCopyWithImpl<$Res>
    implements $InventoryLoadedCopyWith<$Res> {
  _$InventoryLoadedCopyWithImpl(this._self, this._then);

  final InventoryLoaded _self;
  final $Res Function(InventoryLoaded) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? inventory = null,}) {
  return _then(InventoryLoaded(
inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryEntity,
  ));
}


}

/// @nodoc


class InventoryItemUsed implements InventoryState {
  const InventoryItemUsed({required this.itemId, required final  Map<String, double> effects}): _effects = effects;
  

 final  String itemId;
 final  Map<String, double> _effects;
 Map<String, double> get effects {
  if (_effects is EqualUnmodifiableMapView) return _effects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_effects);
}


/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemUsedCopyWith<InventoryItemUsed> get copyWith => _$InventoryItemUsedCopyWithImpl<InventoryItemUsed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItemUsed&&(identical(other.itemId, itemId) || other.itemId == itemId)&&const DeepCollectionEquality().equals(other._effects, _effects));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,const DeepCollectionEquality().hash(_effects));

@override
String toString() {
  return 'InventoryState.itemUsed(itemId: $itemId, effects: $effects)';
}


}

/// @nodoc
abstract mixin class $InventoryItemUsedCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryItemUsedCopyWith(InventoryItemUsed value, $Res Function(InventoryItemUsed) _then) = _$InventoryItemUsedCopyWithImpl;
@useResult
$Res call({
 String itemId, Map<String, double> effects
});




}
/// @nodoc
class _$InventoryItemUsedCopyWithImpl<$Res>
    implements $InventoryItemUsedCopyWith<$Res> {
  _$InventoryItemUsedCopyWithImpl(this._self, this._then);

  final InventoryItemUsed _self;
  final $Res Function(InventoryItemUsed) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? effects = null,}) {
  return _then(InventoryItemUsed(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,effects: null == effects ? _self._effects : effects // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

/// @nodoc


class InventoryPurchaseSuccess implements InventoryState {
  const InventoryPurchaseSuccess({required this.itemId, required this.quantity, required this.cost});
  

 final  String itemId;
 final  int quantity;
 final  int cost;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryPurchaseSuccessCopyWith<InventoryPurchaseSuccess> get copyWith => _$InventoryPurchaseSuccessCopyWithImpl<InventoryPurchaseSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryPurchaseSuccess&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.cost, cost) || other.cost == cost));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,quantity,cost);

@override
String toString() {
  return 'InventoryState.purchaseSuccess(itemId: $itemId, quantity: $quantity, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $InventoryPurchaseSuccessCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryPurchaseSuccessCopyWith(InventoryPurchaseSuccess value, $Res Function(InventoryPurchaseSuccess) _then) = _$InventoryPurchaseSuccessCopyWithImpl;
@useResult
$Res call({
 String itemId, int quantity, int cost
});




}
/// @nodoc
class _$InventoryPurchaseSuccessCopyWithImpl<$Res>
    implements $InventoryPurchaseSuccessCopyWith<$Res> {
  _$InventoryPurchaseSuccessCopyWithImpl(this._self, this._then);

  final InventoryPurchaseSuccess _self;
  final $Res Function(InventoryPurchaseSuccess) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,Object? cost = null,}) {
  return _then(InventoryPurchaseSuccess(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class InventoryPurchaseFailed implements InventoryState {
  const InventoryPurchaseFailed(this.reason);
  

 final  String reason;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryPurchaseFailedCopyWith<InventoryPurchaseFailed> get copyWith => _$InventoryPurchaseFailedCopyWithImpl<InventoryPurchaseFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryPurchaseFailed&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'InventoryState.purchaseFailed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $InventoryPurchaseFailedCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryPurchaseFailedCopyWith(InventoryPurchaseFailed value, $Res Function(InventoryPurchaseFailed) _then) = _$InventoryPurchaseFailedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$InventoryPurchaseFailedCopyWithImpl<$Res>
    implements $InventoryPurchaseFailedCopyWith<$Res> {
  _$InventoryPurchaseFailedCopyWithImpl(this._self, this._then);

  final InventoryPurchaseFailed _self;
  final $Res Function(InventoryPurchaseFailed) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(InventoryPurchaseFailed(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class InventoryError implements InventoryState {
  const InventoryError(this.message);
  

 final  String message;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryErrorCopyWith<InventoryError> get copyWith => _$InventoryErrorCopyWithImpl<InventoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'InventoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $InventoryErrorCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryErrorCopyWith(InventoryError value, $Res Function(InventoryError) _then) = _$InventoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$InventoryErrorCopyWithImpl<$Res>
    implements $InventoryErrorCopyWith<$Res> {
  _$InventoryErrorCopyWithImpl(this._self, this._then);

  final InventoryError _self;
  final $Res Function(InventoryError) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(InventoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
