// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tamtama_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TamtamaEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent()';
}


}

/// @nodoc
class $TamtamaEventCopyWith<$Res>  {
$TamtamaEventCopyWith(TamtamaEvent _, $Res Function(TamtamaEvent) __);
}


/// Adds pattern-matching-related methods to [TamtamaEvent].
extension TamtamaEventPatterns on TamtamaEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadTamtamaEvent value)?  load,TResult Function( TamtamaUpdatedEvent value)?  updated,TResult Function( TamtamaErrorEvent value)?  error,TResult Function( FeedPetEvent value)?  feedPet,TResult Function( PlayWithPetEvent value)?  playWithPet,TResult Function( CleanPetEvent value)?  cleanPet,TResult Function( ToggleSleepEvent value)?  toggleSleep,TResult Function( TickEvent value)?  tick,TResult Function( RewardTickEvent value)?  rewardTick,TResult Function( AutoSaveTickEvent value)?  autoSaveTick,TResult Function( EvolutionCheckTickEvent value)?  evolutionCheckTick,TResult Function( CheckEvolutionEvent value)?  checkEvolution,TResult Function( ApplyOfflineTicksEvent value)?  applyOfflineTicks,TResult Function( ListeningTickEvent value)?  onListeningTick,TResult Function( SetListeningEvent value)?  setListening,TResult Function( EconomyUpdatedEvent value)?  economyUpdated,TResult Function( DebugSetStatsEvent value)?  debugSetStats,TResult Function( DebugAddCoinsEvent value)?  debugAddCoins,TResult Function( ResetTamtamaEvent value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load(_that);case TamtamaUpdatedEvent() when updated != null:
return updated(_that);case TamtamaErrorEvent() when error != null:
return error(_that);case FeedPetEvent() when feedPet != null:
return feedPet(_that);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that);case CleanPetEvent() when cleanPet != null:
return cleanPet(_that);case ToggleSleepEvent() when toggleSleep != null:
return toggleSleep(_that);case TickEvent() when tick != null:
return tick(_that);case RewardTickEvent() when rewardTick != null:
return rewardTick(_that);case AutoSaveTickEvent() when autoSaveTick != null:
return autoSaveTick(_that);case EvolutionCheckTickEvent() when evolutionCheckTick != null:
return evolutionCheckTick(_that);case CheckEvolutionEvent() when checkEvolution != null:
return checkEvolution(_that);case ApplyOfflineTicksEvent() when applyOfflineTicks != null:
return applyOfflineTicks(_that);case ListeningTickEvent() when onListeningTick != null:
return onListeningTick(_that);case SetListeningEvent() when setListening != null:
return setListening(_that);case EconomyUpdatedEvent() when economyUpdated != null:
return economyUpdated(_that);case DebugSetStatsEvent() when debugSetStats != null:
return debugSetStats(_that);case DebugAddCoinsEvent() when debugAddCoins != null:
return debugAddCoins(_that);case ResetTamtamaEvent() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadTamtamaEvent value)  load,required TResult Function( TamtamaUpdatedEvent value)  updated,required TResult Function( TamtamaErrorEvent value)  error,required TResult Function( FeedPetEvent value)  feedPet,required TResult Function( PlayWithPetEvent value)  playWithPet,required TResult Function( CleanPetEvent value)  cleanPet,required TResult Function( ToggleSleepEvent value)  toggleSleep,required TResult Function( TickEvent value)  tick,required TResult Function( RewardTickEvent value)  rewardTick,required TResult Function( AutoSaveTickEvent value)  autoSaveTick,required TResult Function( EvolutionCheckTickEvent value)  evolutionCheckTick,required TResult Function( CheckEvolutionEvent value)  checkEvolution,required TResult Function( ApplyOfflineTicksEvent value)  applyOfflineTicks,required TResult Function( ListeningTickEvent value)  onListeningTick,required TResult Function( SetListeningEvent value)  setListening,required TResult Function( EconomyUpdatedEvent value)  economyUpdated,required TResult Function( DebugSetStatsEvent value)  debugSetStats,required TResult Function( DebugAddCoinsEvent value)  debugAddCoins,required TResult Function( ResetTamtamaEvent value)  reset,}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent():
return load(_that);case TamtamaUpdatedEvent():
return updated(_that);case TamtamaErrorEvent():
return error(_that);case FeedPetEvent():
return feedPet(_that);case PlayWithPetEvent():
return playWithPet(_that);case CleanPetEvent():
return cleanPet(_that);case ToggleSleepEvent():
return toggleSleep(_that);case TickEvent():
return tick(_that);case RewardTickEvent():
return rewardTick(_that);case AutoSaveTickEvent():
return autoSaveTick(_that);case EvolutionCheckTickEvent():
return evolutionCheckTick(_that);case CheckEvolutionEvent():
return checkEvolution(_that);case ApplyOfflineTicksEvent():
return applyOfflineTicks(_that);case ListeningTickEvent():
return onListeningTick(_that);case SetListeningEvent():
return setListening(_that);case EconomyUpdatedEvent():
return economyUpdated(_that);case DebugSetStatsEvent():
return debugSetStats(_that);case DebugAddCoinsEvent():
return debugAddCoins(_that);case ResetTamtamaEvent():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadTamtamaEvent value)?  load,TResult? Function( TamtamaUpdatedEvent value)?  updated,TResult? Function( TamtamaErrorEvent value)?  error,TResult? Function( FeedPetEvent value)?  feedPet,TResult? Function( PlayWithPetEvent value)?  playWithPet,TResult? Function( CleanPetEvent value)?  cleanPet,TResult? Function( ToggleSleepEvent value)?  toggleSleep,TResult? Function( TickEvent value)?  tick,TResult? Function( RewardTickEvent value)?  rewardTick,TResult? Function( AutoSaveTickEvent value)?  autoSaveTick,TResult? Function( EvolutionCheckTickEvent value)?  evolutionCheckTick,TResult? Function( CheckEvolutionEvent value)?  checkEvolution,TResult? Function( ApplyOfflineTicksEvent value)?  applyOfflineTicks,TResult? Function( ListeningTickEvent value)?  onListeningTick,TResult? Function( SetListeningEvent value)?  setListening,TResult? Function( EconomyUpdatedEvent value)?  economyUpdated,TResult? Function( DebugSetStatsEvent value)?  debugSetStats,TResult? Function( DebugAddCoinsEvent value)?  debugAddCoins,TResult? Function( ResetTamtamaEvent value)?  reset,}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load(_that);case TamtamaUpdatedEvent() when updated != null:
return updated(_that);case TamtamaErrorEvent() when error != null:
return error(_that);case FeedPetEvent() when feedPet != null:
return feedPet(_that);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that);case CleanPetEvent() when cleanPet != null:
return cleanPet(_that);case ToggleSleepEvent() when toggleSleep != null:
return toggleSleep(_that);case TickEvent() when tick != null:
return tick(_that);case RewardTickEvent() when rewardTick != null:
return rewardTick(_that);case AutoSaveTickEvent() when autoSaveTick != null:
return autoSaveTick(_that);case EvolutionCheckTickEvent() when evolutionCheckTick != null:
return evolutionCheckTick(_that);case CheckEvolutionEvent() when checkEvolution != null:
return checkEvolution(_that);case ApplyOfflineTicksEvent() when applyOfflineTicks != null:
return applyOfflineTicks(_that);case ListeningTickEvent() when onListeningTick != null:
return onListeningTick(_that);case SetListeningEvent() when setListening != null:
return setListening(_that);case EconomyUpdatedEvent() when economyUpdated != null:
return economyUpdated(_that);case DebugSetStatsEvent() when debugSetStats != null:
return debugSetStats(_that);case DebugAddCoinsEvent() when debugAddCoins != null:
return debugAddCoins(_that);case ResetTamtamaEvent() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function( TamtamaEntity tamtama)?  updated,TResult Function( String message)?  error,TResult Function( FoodType? food)?  feedPet,TResult Function( ActivityType? activity)?  playWithPet,TResult Function()?  cleanPet,TResult Function()?  toggleSleep,TResult Function()?  tick,TResult Function()?  rewardTick,TResult Function()?  autoSaveTick,TResult Function()?  evolutionCheckTick,TResult Function()?  checkEvolution,TResult Function()?  applyOfflineTicks,TResult Function( int minutes,  String stationId)?  onListeningTick,TResult Function( bool isListening)?  setListening,TResult Function( TamtamaEconomyEntity economy)?  economyUpdated,TResult Function( double? hunger,  double? energy,  double? happiness,  double? hygiene,  double? affection,  double? stress,  double? health)?  debugSetStats,TResult Function( double amount)?  debugAddCoins,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load();case TamtamaUpdatedEvent() when updated != null:
return updated(_that.tamtama);case TamtamaErrorEvent() when error != null:
return error(_that.message);case FeedPetEvent() when feedPet != null:
return feedPet(_that.food);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that.activity);case CleanPetEvent() when cleanPet != null:
return cleanPet();case ToggleSleepEvent() when toggleSleep != null:
return toggleSleep();case TickEvent() when tick != null:
return tick();case RewardTickEvent() when rewardTick != null:
return rewardTick();case AutoSaveTickEvent() when autoSaveTick != null:
return autoSaveTick();case EvolutionCheckTickEvent() when evolutionCheckTick != null:
return evolutionCheckTick();case CheckEvolutionEvent() when checkEvolution != null:
return checkEvolution();case ApplyOfflineTicksEvent() when applyOfflineTicks != null:
return applyOfflineTicks();case ListeningTickEvent() when onListeningTick != null:
return onListeningTick(_that.minutes,_that.stationId);case SetListeningEvent() when setListening != null:
return setListening(_that.isListening);case EconomyUpdatedEvent() when economyUpdated != null:
return economyUpdated(_that.economy);case DebugSetStatsEvent() when debugSetStats != null:
return debugSetStats(_that.hunger,_that.energy,_that.happiness,_that.hygiene,_that.affection,_that.stress,_that.health);case DebugAddCoinsEvent() when debugAddCoins != null:
return debugAddCoins(_that.amount);case ResetTamtamaEvent() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function( TamtamaEntity tamtama)  updated,required TResult Function( String message)  error,required TResult Function( FoodType? food)  feedPet,required TResult Function( ActivityType? activity)  playWithPet,required TResult Function()  cleanPet,required TResult Function()  toggleSleep,required TResult Function()  tick,required TResult Function()  rewardTick,required TResult Function()  autoSaveTick,required TResult Function()  evolutionCheckTick,required TResult Function()  checkEvolution,required TResult Function()  applyOfflineTicks,required TResult Function( int minutes,  String stationId)  onListeningTick,required TResult Function( bool isListening)  setListening,required TResult Function( TamtamaEconomyEntity economy)  economyUpdated,required TResult Function( double? hunger,  double? energy,  double? happiness,  double? hygiene,  double? affection,  double? stress,  double? health)  debugSetStats,required TResult Function( double amount)  debugAddCoins,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent():
return load();case TamtamaUpdatedEvent():
return updated(_that.tamtama);case TamtamaErrorEvent():
return error(_that.message);case FeedPetEvent():
return feedPet(_that.food);case PlayWithPetEvent():
return playWithPet(_that.activity);case CleanPetEvent():
return cleanPet();case ToggleSleepEvent():
return toggleSleep();case TickEvent():
return tick();case RewardTickEvent():
return rewardTick();case AutoSaveTickEvent():
return autoSaveTick();case EvolutionCheckTickEvent():
return evolutionCheckTick();case CheckEvolutionEvent():
return checkEvolution();case ApplyOfflineTicksEvent():
return applyOfflineTicks();case ListeningTickEvent():
return onListeningTick(_that.minutes,_that.stationId);case SetListeningEvent():
return setListening(_that.isListening);case EconomyUpdatedEvent():
return economyUpdated(_that.economy);case DebugSetStatsEvent():
return debugSetStats(_that.hunger,_that.energy,_that.happiness,_that.hygiene,_that.affection,_that.stress,_that.health);case DebugAddCoinsEvent():
return debugAddCoins(_that.amount);case ResetTamtamaEvent():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function( TamtamaEntity tamtama)?  updated,TResult? Function( String message)?  error,TResult? Function( FoodType? food)?  feedPet,TResult? Function( ActivityType? activity)?  playWithPet,TResult? Function()?  cleanPet,TResult? Function()?  toggleSleep,TResult? Function()?  tick,TResult? Function()?  rewardTick,TResult? Function()?  autoSaveTick,TResult? Function()?  evolutionCheckTick,TResult? Function()?  checkEvolution,TResult? Function()?  applyOfflineTicks,TResult? Function( int minutes,  String stationId)?  onListeningTick,TResult? Function( bool isListening)?  setListening,TResult? Function( TamtamaEconomyEntity economy)?  economyUpdated,TResult? Function( double? hunger,  double? energy,  double? happiness,  double? hygiene,  double? affection,  double? stress,  double? health)?  debugSetStats,TResult? Function( double amount)?  debugAddCoins,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load();case TamtamaUpdatedEvent() when updated != null:
return updated(_that.tamtama);case TamtamaErrorEvent() when error != null:
return error(_that.message);case FeedPetEvent() when feedPet != null:
return feedPet(_that.food);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that.activity);case CleanPetEvent() when cleanPet != null:
return cleanPet();case ToggleSleepEvent() when toggleSleep != null:
return toggleSleep();case TickEvent() when tick != null:
return tick();case RewardTickEvent() when rewardTick != null:
return rewardTick();case AutoSaveTickEvent() when autoSaveTick != null:
return autoSaveTick();case EvolutionCheckTickEvent() when evolutionCheckTick != null:
return evolutionCheckTick();case CheckEvolutionEvent() when checkEvolution != null:
return checkEvolution();case ApplyOfflineTicksEvent() when applyOfflineTicks != null:
return applyOfflineTicks();case ListeningTickEvent() when onListeningTick != null:
return onListeningTick(_that.minutes,_that.stationId);case SetListeningEvent() when setListening != null:
return setListening(_that.isListening);case EconomyUpdatedEvent() when economyUpdated != null:
return economyUpdated(_that.economy);case DebugSetStatsEvent() when debugSetStats != null:
return debugSetStats(_that.hunger,_that.energy,_that.happiness,_that.hygiene,_that.affection,_that.stress,_that.health);case DebugAddCoinsEvent() when debugAddCoins != null:
return debugAddCoins(_that.amount);case ResetTamtamaEvent() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class LoadTamtamaEvent implements TamtamaEvent {
  const LoadTamtamaEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTamtamaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.load()';
}


}




/// @nodoc


class TamtamaUpdatedEvent implements TamtamaEvent {
  const TamtamaUpdatedEvent(this.tamtama);
  

 final  TamtamaEntity tamtama;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaUpdatedEventCopyWith<TamtamaUpdatedEvent> get copyWith => _$TamtamaUpdatedEventCopyWithImpl<TamtamaUpdatedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaUpdatedEvent&&(identical(other.tamtama, tamtama) || other.tamtama == tamtama));
}


@override
int get hashCode => Object.hash(runtimeType,tamtama);

@override
String toString() {
  return 'TamtamaEvent.updated(tamtama: $tamtama)';
}


}

/// @nodoc
abstract mixin class $TamtamaUpdatedEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $TamtamaUpdatedEventCopyWith(TamtamaUpdatedEvent value, $Res Function(TamtamaUpdatedEvent) _then) = _$TamtamaUpdatedEventCopyWithImpl;
@useResult
$Res call({
 TamtamaEntity tamtama
});




}
/// @nodoc
class _$TamtamaUpdatedEventCopyWithImpl<$Res>
    implements $TamtamaUpdatedEventCopyWith<$Res> {
  _$TamtamaUpdatedEventCopyWithImpl(this._self, this._then);

  final TamtamaUpdatedEvent _self;
  final $Res Function(TamtamaUpdatedEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tamtama = null,}) {
  return _then(TamtamaUpdatedEvent(
null == tamtama ? _self.tamtama : tamtama // ignore: cast_nullable_to_non_nullable
as TamtamaEntity,
  ));
}


}

/// @nodoc


class TamtamaErrorEvent implements TamtamaEvent {
  const TamtamaErrorEvent(this.message);
  

 final  String message;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaErrorEventCopyWith<TamtamaErrorEvent> get copyWith => _$TamtamaErrorEventCopyWithImpl<TamtamaErrorEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaErrorEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TamtamaEvent.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TamtamaErrorEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $TamtamaErrorEventCopyWith(TamtamaErrorEvent value, $Res Function(TamtamaErrorEvent) _then) = _$TamtamaErrorEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TamtamaErrorEventCopyWithImpl<$Res>
    implements $TamtamaErrorEventCopyWith<$Res> {
  _$TamtamaErrorEventCopyWithImpl(this._self, this._then);

  final TamtamaErrorEvent _self;
  final $Res Function(TamtamaErrorEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TamtamaErrorEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FeedPetEvent implements TamtamaEvent {
  const FeedPetEvent([this.food]);
  

 final  FoodType? food;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedPetEventCopyWith<FeedPetEvent> get copyWith => _$FeedPetEventCopyWithImpl<FeedPetEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedPetEvent&&(identical(other.food, food) || other.food == food));
}


@override
int get hashCode => Object.hash(runtimeType,food);

@override
String toString() {
  return 'TamtamaEvent.feedPet(food: $food)';
}


}

/// @nodoc
abstract mixin class $FeedPetEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $FeedPetEventCopyWith(FeedPetEvent value, $Res Function(FeedPetEvent) _then) = _$FeedPetEventCopyWithImpl;
@useResult
$Res call({
 FoodType? food
});




}
/// @nodoc
class _$FeedPetEventCopyWithImpl<$Res>
    implements $FeedPetEventCopyWith<$Res> {
  _$FeedPetEventCopyWithImpl(this._self, this._then);

  final FeedPetEvent _self;
  final $Res Function(FeedPetEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? food = freezed,}) {
  return _then(FeedPetEvent(
freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as FoodType?,
  ));
}


}

/// @nodoc


class PlayWithPetEvent implements TamtamaEvent {
  const PlayWithPetEvent([this.activity]);
  

 final  ActivityType? activity;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayWithPetEventCopyWith<PlayWithPetEvent> get copyWith => _$PlayWithPetEventCopyWithImpl<PlayWithPetEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayWithPetEvent&&(identical(other.activity, activity) || other.activity == activity));
}


@override
int get hashCode => Object.hash(runtimeType,activity);

@override
String toString() {
  return 'TamtamaEvent.playWithPet(activity: $activity)';
}


}

/// @nodoc
abstract mixin class $PlayWithPetEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $PlayWithPetEventCopyWith(PlayWithPetEvent value, $Res Function(PlayWithPetEvent) _then) = _$PlayWithPetEventCopyWithImpl;
@useResult
$Res call({
 ActivityType? activity
});




}
/// @nodoc
class _$PlayWithPetEventCopyWithImpl<$Res>
    implements $PlayWithPetEventCopyWith<$Res> {
  _$PlayWithPetEventCopyWithImpl(this._self, this._then);

  final PlayWithPetEvent _self;
  final $Res Function(PlayWithPetEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activity = freezed,}) {
  return _then(PlayWithPetEvent(
freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityType?,
  ));
}


}

/// @nodoc


class CleanPetEvent implements TamtamaEvent {
  const CleanPetEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanPetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.cleanPet()';
}


}




/// @nodoc


class ToggleSleepEvent implements TamtamaEvent {
  const ToggleSleepEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleSleepEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.toggleSleep()';
}


}




/// @nodoc


class TickEvent implements TamtamaEvent {
  const TickEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TickEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.tick()';
}


}




/// @nodoc


class RewardTickEvent implements TamtamaEvent {
  const RewardTickEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardTickEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.rewardTick()';
}


}




/// @nodoc


class AutoSaveTickEvent implements TamtamaEvent {
  const AutoSaveTickEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoSaveTickEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.autoSaveTick()';
}


}




/// @nodoc


class EvolutionCheckTickEvent implements TamtamaEvent {
  const EvolutionCheckTickEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvolutionCheckTickEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.evolutionCheckTick()';
}


}




/// @nodoc


class CheckEvolutionEvent implements TamtamaEvent {
  const CheckEvolutionEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEvolutionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.checkEvolution()';
}


}




/// @nodoc


class ApplyOfflineTicksEvent implements TamtamaEvent {
  const ApplyOfflineTicksEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyOfflineTicksEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.applyOfflineTicks()';
}


}




/// @nodoc


class ListeningTickEvent implements TamtamaEvent {
  const ListeningTickEvent(this.minutes, this.stationId);
  

 final  int minutes;
 final  String stationId;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningTickEventCopyWith<ListeningTickEvent> get copyWith => _$ListeningTickEventCopyWithImpl<ListeningTickEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningTickEvent&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.stationId, stationId) || other.stationId == stationId));
}


@override
int get hashCode => Object.hash(runtimeType,minutes,stationId);

@override
String toString() {
  return 'TamtamaEvent.onListeningTick(minutes: $minutes, stationId: $stationId)';
}


}

/// @nodoc
abstract mixin class $ListeningTickEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $ListeningTickEventCopyWith(ListeningTickEvent value, $Res Function(ListeningTickEvent) _then) = _$ListeningTickEventCopyWithImpl;
@useResult
$Res call({
 int minutes, String stationId
});




}
/// @nodoc
class _$ListeningTickEventCopyWithImpl<$Res>
    implements $ListeningTickEventCopyWith<$Res> {
  _$ListeningTickEventCopyWithImpl(this._self, this._then);

  final ListeningTickEvent _self;
  final $Res Function(ListeningTickEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? minutes = null,Object? stationId = null,}) {
  return _then(ListeningTickEvent(
null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,null == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetListeningEvent implements TamtamaEvent {
  const SetListeningEvent(this.isListening);
  

 final  bool isListening;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetListeningEventCopyWith<SetListeningEvent> get copyWith => _$SetListeningEventCopyWithImpl<SetListeningEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetListeningEvent&&(identical(other.isListening, isListening) || other.isListening == isListening));
}


@override
int get hashCode => Object.hash(runtimeType,isListening);

@override
String toString() {
  return 'TamtamaEvent.setListening(isListening: $isListening)';
}


}

/// @nodoc
abstract mixin class $SetListeningEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $SetListeningEventCopyWith(SetListeningEvent value, $Res Function(SetListeningEvent) _then) = _$SetListeningEventCopyWithImpl;
@useResult
$Res call({
 bool isListening
});




}
/// @nodoc
class _$SetListeningEventCopyWithImpl<$Res>
    implements $SetListeningEventCopyWith<$Res> {
  _$SetListeningEventCopyWithImpl(this._self, this._then);

  final SetListeningEvent _self;
  final $Res Function(SetListeningEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isListening = null,}) {
  return _then(SetListeningEvent(
null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class EconomyUpdatedEvent implements TamtamaEvent {
  const EconomyUpdatedEvent(this.economy);
  

 final  TamtamaEconomyEntity economy;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EconomyUpdatedEventCopyWith<EconomyUpdatedEvent> get copyWith => _$EconomyUpdatedEventCopyWithImpl<EconomyUpdatedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EconomyUpdatedEvent&&(identical(other.economy, economy) || other.economy == economy));
}


@override
int get hashCode => Object.hash(runtimeType,economy);

@override
String toString() {
  return 'TamtamaEvent.economyUpdated(economy: $economy)';
}


}

/// @nodoc
abstract mixin class $EconomyUpdatedEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $EconomyUpdatedEventCopyWith(EconomyUpdatedEvent value, $Res Function(EconomyUpdatedEvent) _then) = _$EconomyUpdatedEventCopyWithImpl;
@useResult
$Res call({
 TamtamaEconomyEntity economy
});




}
/// @nodoc
class _$EconomyUpdatedEventCopyWithImpl<$Res>
    implements $EconomyUpdatedEventCopyWith<$Res> {
  _$EconomyUpdatedEventCopyWithImpl(this._self, this._then);

  final EconomyUpdatedEvent _self;
  final $Res Function(EconomyUpdatedEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? economy = null,}) {
  return _then(EconomyUpdatedEvent(
null == economy ? _self.economy : economy // ignore: cast_nullable_to_non_nullable
as TamtamaEconomyEntity,
  ));
}


}

/// @nodoc


class DebugSetStatsEvent implements TamtamaEvent {
  const DebugSetStatsEvent({this.hunger, this.energy, this.happiness, this.hygiene, this.affection, this.stress, this.health});
  

 final  double? hunger;
 final  double? energy;
 final  double? happiness;
 final  double? hygiene;
 final  double? affection;
 final  double? stress;
 final  double? health;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebugSetStatsEventCopyWith<DebugSetStatsEvent> get copyWith => _$DebugSetStatsEventCopyWithImpl<DebugSetStatsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebugSetStatsEvent&&(identical(other.hunger, hunger) || other.hunger == hunger)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.happiness, happiness) || other.happiness == happiness)&&(identical(other.hygiene, hygiene) || other.hygiene == hygiene)&&(identical(other.affection, affection) || other.affection == affection)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.health, health) || other.health == health));
}


@override
int get hashCode => Object.hash(runtimeType,hunger,energy,happiness,hygiene,affection,stress,health);

@override
String toString() {
  return 'TamtamaEvent.debugSetStats(hunger: $hunger, energy: $energy, happiness: $happiness, hygiene: $hygiene, affection: $affection, stress: $stress, health: $health)';
}


}

/// @nodoc
abstract mixin class $DebugSetStatsEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $DebugSetStatsEventCopyWith(DebugSetStatsEvent value, $Res Function(DebugSetStatsEvent) _then) = _$DebugSetStatsEventCopyWithImpl;
@useResult
$Res call({
 double? hunger, double? energy, double? happiness, double? hygiene, double? affection, double? stress, double? health
});




}
/// @nodoc
class _$DebugSetStatsEventCopyWithImpl<$Res>
    implements $DebugSetStatsEventCopyWith<$Res> {
  _$DebugSetStatsEventCopyWithImpl(this._self, this._then);

  final DebugSetStatsEvent _self;
  final $Res Function(DebugSetStatsEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hunger = freezed,Object? energy = freezed,Object? happiness = freezed,Object? hygiene = freezed,Object? affection = freezed,Object? stress = freezed,Object? health = freezed,}) {
  return _then(DebugSetStatsEvent(
hunger: freezed == hunger ? _self.hunger : hunger // ignore: cast_nullable_to_non_nullable
as double?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as double?,happiness: freezed == happiness ? _self.happiness : happiness // ignore: cast_nullable_to_non_nullable
as double?,hygiene: freezed == hygiene ? _self.hygiene : hygiene // ignore: cast_nullable_to_non_nullable
as double?,affection: freezed == affection ? _self.affection : affection // ignore: cast_nullable_to_non_nullable
as double?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as double?,health: freezed == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class DebugAddCoinsEvent implements TamtamaEvent {
  const DebugAddCoinsEvent(this.amount);
  

 final  double amount;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebugAddCoinsEventCopyWith<DebugAddCoinsEvent> get copyWith => _$DebugAddCoinsEventCopyWithImpl<DebugAddCoinsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebugAddCoinsEvent&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'TamtamaEvent.debugAddCoins(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $DebugAddCoinsEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $DebugAddCoinsEventCopyWith(DebugAddCoinsEvent value, $Res Function(DebugAddCoinsEvent) _then) = _$DebugAddCoinsEventCopyWithImpl;
@useResult
$Res call({
 double amount
});




}
/// @nodoc
class _$DebugAddCoinsEventCopyWithImpl<$Res>
    implements $DebugAddCoinsEventCopyWith<$Res> {
  _$DebugAddCoinsEventCopyWithImpl(this._self, this._then);

  final DebugAddCoinsEvent _self;
  final $Res Function(DebugAddCoinsEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(DebugAddCoinsEvent(
null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ResetTamtamaEvent implements TamtamaEvent {
  const ResetTamtamaEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetTamtamaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.reset()';
}


}




/// @nodoc
mixin _$TamtamaState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState()';
}


}

/// @nodoc
class $TamtamaStateCopyWith<$Res>  {
$TamtamaStateCopyWith(TamtamaState _, $Res Function(TamtamaState) __);
}


/// Adds pattern-matching-related methods to [TamtamaState].
extension TamtamaStatePatterns on TamtamaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TamtamaInitial value)?  initial,TResult Function( TamtamaLoading value)?  loading,TResult Function( TamtamaLoaded value)?  loaded,TResult Function( TamtamaError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TamtamaInitial() when initial != null:
return initial(_that);case TamtamaLoading() when loading != null:
return loading(_that);case TamtamaLoaded() when loaded != null:
return loaded(_that);case TamtamaError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TamtamaInitial value)  initial,required TResult Function( TamtamaLoading value)  loading,required TResult Function( TamtamaLoaded value)  loaded,required TResult Function( TamtamaError value)  error,}){
final _that = this;
switch (_that) {
case TamtamaInitial():
return initial(_that);case TamtamaLoading():
return loading(_that);case TamtamaLoaded():
return loaded(_that);case TamtamaError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TamtamaInitial value)?  initial,TResult? Function( TamtamaLoading value)?  loading,TResult? Function( TamtamaLoaded value)?  loaded,TResult? Function( TamtamaError value)?  error,}){
final _that = this;
switch (_that) {
case TamtamaInitial() when initial != null:
return initial(_that);case TamtamaLoading() when loading != null:
return loading(_that);case TamtamaLoaded() when loaded != null:
return loaded(_that);case TamtamaError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TamtamaEntity tamtama,  TamtamaEconomyEntity economy,  bool isListening)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TamtamaInitial() when initial != null:
return initial();case TamtamaLoading() when loading != null:
return loading();case TamtamaLoaded() when loaded != null:
return loaded(_that.tamtama,_that.economy,_that.isListening);case TamtamaError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TamtamaEntity tamtama,  TamtamaEconomyEntity economy,  bool isListening)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TamtamaInitial():
return initial();case TamtamaLoading():
return loading();case TamtamaLoaded():
return loaded(_that.tamtama,_that.economy,_that.isListening);case TamtamaError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TamtamaEntity tamtama,  TamtamaEconomyEntity economy,  bool isListening)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TamtamaInitial() when initial != null:
return initial();case TamtamaLoading() when loading != null:
return loading();case TamtamaLoaded() when loaded != null:
return loaded(_that.tamtama,_that.economy,_that.isListening);case TamtamaError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TamtamaInitial implements TamtamaState {
  const TamtamaInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState.initial()';
}


}




/// @nodoc


class TamtamaLoading implements TamtamaState {
  const TamtamaLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState.loading()';
}


}




/// @nodoc


class TamtamaLoaded implements TamtamaState {
  const TamtamaLoaded({required this.tamtama, required this.economy, this.isListening = false});
  

 final  TamtamaEntity tamtama;
 final  TamtamaEconomyEntity economy;
@JsonKey() final  bool isListening;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaLoadedCopyWith<TamtamaLoaded> get copyWith => _$TamtamaLoadedCopyWithImpl<TamtamaLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaLoaded&&(identical(other.tamtama, tamtama) || other.tamtama == tamtama)&&(identical(other.economy, economy) || other.economy == economy)&&(identical(other.isListening, isListening) || other.isListening == isListening));
}


@override
int get hashCode => Object.hash(runtimeType,tamtama,economy,isListening);

@override
String toString() {
  return 'TamtamaState.loaded(tamtama: $tamtama, economy: $economy, isListening: $isListening)';
}


}

/// @nodoc
abstract mixin class $TamtamaLoadedCopyWith<$Res> implements $TamtamaStateCopyWith<$Res> {
  factory $TamtamaLoadedCopyWith(TamtamaLoaded value, $Res Function(TamtamaLoaded) _then) = _$TamtamaLoadedCopyWithImpl;
@useResult
$Res call({
 TamtamaEntity tamtama, TamtamaEconomyEntity economy, bool isListening
});




}
/// @nodoc
class _$TamtamaLoadedCopyWithImpl<$Res>
    implements $TamtamaLoadedCopyWith<$Res> {
  _$TamtamaLoadedCopyWithImpl(this._self, this._then);

  final TamtamaLoaded _self;
  final $Res Function(TamtamaLoaded) _then;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tamtama = null,Object? economy = null,Object? isListening = null,}) {
  return _then(TamtamaLoaded(
tamtama: null == tamtama ? _self.tamtama : tamtama // ignore: cast_nullable_to_non_nullable
as TamtamaEntity,economy: null == economy ? _self.economy : economy // ignore: cast_nullable_to_non_nullable
as TamtamaEconomyEntity,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TamtamaError implements TamtamaState {
  const TamtamaError(this.message);
  

 final  String message;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaErrorCopyWith<TamtamaError> get copyWith => _$TamtamaErrorCopyWithImpl<TamtamaError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TamtamaState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TamtamaErrorCopyWith<$Res> implements $TamtamaStateCopyWith<$Res> {
  factory $TamtamaErrorCopyWith(TamtamaError value, $Res Function(TamtamaError) _then) = _$TamtamaErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TamtamaErrorCopyWithImpl<$Res>
    implements $TamtamaErrorCopyWith<$Res> {
  _$TamtamaErrorCopyWithImpl(this._self, this._then);

  final TamtamaError _self;
  final $Res Function(TamtamaError) _then;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TamtamaError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
