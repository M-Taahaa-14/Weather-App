import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory("4b70de9efa5b4c136ceb026ec70da9ca",
            language: Language.ENGLISH);

        // Fetch the current weather
        final Weather currentWeather = await wf.currentWeatherByLocation(
            event.position.latitude, event.position.longitude);

        // Fetch the 5-day forecast
        final List<Weather> fiveDayForecast =
            await wf.fiveDayForecastByLocation(
                event.position.latitude, event.position.longitude);

        emit(WeatherBlocSuccess(currentWeather, fiveDayForecast));
      } catch (e) {
        emit(WeatherBlocFailiure());
      }
    });

    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory("4b70de9efa5b4c136ceb026ec70da9ca",
            language: Language.ENGLISH);

        // Fetch the current weather by city name
        final Weather currentWeather =
            await wf.currentWeatherByCityName(event.cityName);

        // Fetch the 5-day forecast by city name
        final List<Weather> fiveDayForecast =
            await wf.fiveDayForecastByCityName(event.cityName);

        emit(WeatherBlocSuccess(currentWeather, fiveDayForecast));
      } catch (e) {
        emit(WeatherBlocFailiure());
      }
    });
  }
}
