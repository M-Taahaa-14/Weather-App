part of 'weather_bloc_bloc.dart';

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

final class WeatherBlocInitial extends WeatherBlocState {}

final class WeatherBlocLoading extends WeatherBlocState {}

final class WeatherBlocFailiure extends WeatherBlocState {}

final class WeatherBlocSuccess extends WeatherBlocState {
  final Weather currentWeather;
  final List<Weather> fiveDayForecast;

  const WeatherBlocSuccess(this.currentWeather, this.fiveDayForecast);

  @override
  List<Object> get props => [currentWeather, fiveDayForecast];
}
