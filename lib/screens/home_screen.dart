import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('lib/assets/images/1.png', scale: 3);
      case >= 300 && < 400:
        return Image.asset('lib/assets/images/2.png', scale: 3);
      case >= 500 && < 600:
        return Image.asset('lib/assets/images/3.png', scale: 3);
      case >= 600 && < 700:
        return Image.asset('lib/assets/images/4.png', scale: 3);
      case >= 700 && < 800:
        return Image.asset('lib/assets/images/5.png', scale: 3);
      case == 800:
        return Image.asset('lib/assets/images/6.png', scale: 3);
      case > 800 && <= 804:
        return Image.asset('lib/assets/images/7.png', scale: 3);
      default:
        return Image.asset('lib/assets/images/7.png', scale: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white24,
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search city...',
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              context.read<WeatherBlocBloc>().add(FetchWeatherByCity(value));
            },
          ),
        ),
      ),
      body: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
        builder: (context, state) {
          if (state is WeatherBlocSuccess) {
            return Stack(
              children: [
                // Background Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 0, 128, 188),
                        Color.fromARGB(255, 31, 120, 164),
                        Color.fromARGB(255, 77, 138, 195),
                      ],
                    ),
                  ),
                ),
                // Main Content
                Column(
                  children: [
                    SizedBox(height: 160), // Space at the top
                    // Weather Information Card
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '📍 ${state.currentWeather.areaName}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 10),
                          getWeatherIcon(
                              state.currentWeather.weatherConditionCode!),
                          SizedBox(height: 5),
                          Text(
                            '${state.currentWeather.temperature!.celsius!.round()}°C',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${state.currentWeather.tempMax!.celsius!.round()}°C / ${state.currentWeather.tempMin!.celsius!.round()}°C',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE dd •')
                                .add_jm()
                                .format(state.currentWeather.date!),
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80), // Space between card and forecast
                    // 5-Day Forecast
                    Container(
                      height: 150, // Set a fixed height for the forecast
                      child: ListView.builder(
                        itemCount: state.fiveDayForecast.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final dayForecast = state.fiveDayForecast[index];
                          return Container(
                            width: 100, // Adjust width as needed
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('E').format(dayForecast.date!),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                getWeatherIcon(
                                    dayForecast.weatherConditionCode!),
                                SizedBox(height: 5),
                                Text(
                                  '${dayForecast.tempMax!.celsius!.round()}°C / ${dayForecast.tempMin!.celsius!.round()}°C',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 39, 85, 130),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: '',
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}
