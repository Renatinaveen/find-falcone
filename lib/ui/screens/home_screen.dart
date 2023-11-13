import 'package:find_falcone/blocs/falcone_bloc.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';
import 'package:find_falcone/resources/fonts_class.dart';
import 'package:find_falcone/resources/helpers/decide_device.dart';
import 'package:find_falcone/resources/states/falcone_states.dart';
import 'package:find_falcone/ui/screens/content_not_found_screen.dart';
import 'package:find_falcone/ui/screens/planet_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/selection_model.dart';
import '../../resources/assets_class.dart';
import '../../resources/events/falcone_events.dart';
import '../../resources/theme_class.dart';
import '../components/background_widget.dart';
import '../components/selected_details_widget.dart';
import '../components/selected_row_ui_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FalconeBloc _falconeBloc = FalconeBloc();
  var openCart = false;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -0.7) {
      setState(() {
        openCart = true;
      });
    } else if (details.primaryDelta! > 10) {
      setState(() {
        openCart = false;
      });
    }
  }

  @override
  void dispose() {
    _falconeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const BackgroundWidget(),
          BlocProvider<FalconeBloc>(
            create: (BuildContext context) {
              return _falconeBloc..add(FetchPlanetsNVehicles());
            },
            child: BlocListener<FalconeBloc, FalconeStates>(
              listener: (BuildContext context, FalconeStates state) {
                if (state is FailedToFetchPlanetsNVehicles) {
                  pushErrorScreen();
                }
              },
              child: BlocBuilder<FalconeBloc, FalconeStates>(
                builder: (BuildContext context, FalconeStates state) {
                  if (state is FetchedPlanetsNVehicles) {
                    return _buildPlanetsList(
                        state.planets, state.vehicles, state.selectionModel);
                  }
                  return Lottie.asset(
                    Assets.planets,
                    repeat: true,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.4,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildPlanetsList(List<PlanetsModel> planetsList,
      List<VehiclesModel> vehiclesList, SelectionModel selectionModel) {
    return ScopedModel<SelectionModel>(
      model: selectionModel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) =>
            LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                top: openCart ? -(constraints.maxHeight - 80) : 0,
                left: 0,
                right: 0,
                height: constraints.maxHeight,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    childAspectRatio:
                        DecideDevice().returnDeviceType(context) == 0
                            ? 1.1
                            : 0.9,
                    crossAxisCount:
                        DecideDevice().returnDeviceType(context) == 0 ? 3 : 2,
                    children: planetsList
                        .map((product) => GestureDetector(
                              onTap: () {
                                navigateToDetails(context, product, planetsList,
                                    vehiclesList, selectionModel);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Hero(
                                      tag: product.name!,
                                      child: Container(
                                        padding: const EdgeInsets.all(0),
                                        child: Image.asset(
                                          'assets/images/planets/${product.name!.toLowerCase()}.webp',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name!,
                                        style: const TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: FontsClass.fontSize16,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeClass.white,
                                        ),
                                      ),
                                      Text(
                                        'Distance: ${product.distance}',
                                        style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: FontsClass.fontSize16,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeClass.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  DecideDevice().returnDeviceType(context) == 0
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        )
                                      : Container()
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              ScopedModelDescendant<SelectionModel>(
                builder: (
                  BuildContext context,
                  Widget? child,
                  SelectionModel model,
                ) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),
                    bottom: 0,
                    height: openCart
                        ? MediaQuery.sizeOf(context).height - 100
                        : model.selectedPlanets.isEmpty
                            ? 0
                            : DecideDevice().returnDeviceType(context) == 0
                                ? 100
                                : 80,
                    width: MediaQuery.sizeOf(context).width,
                    child: GestureDetector(
                      onVerticalDragUpdate: _onVerticalGesture,
                      onTap: () {
                        if (model.selectedPlanets.isNotEmpty) {
                          setState(() {
                            openCart = !openCart;
                            if (openCart) {
                              _animationController.forward();
                            } else {
                              _animationController.reverse();
                            }
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: ThemeClass.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeClass.grey.withOpacity(0.5),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 700),
                          switchInCurve: Curves.easeInOut,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: openCart
                                ? SelectedDetails(
                                    selectionModel: model,
                                    closeCart: () => setState(() {
                                      openCart = false;
                                      _animationController.reverse();
                                    }),
                                    removeItem: (index) {
                                      model.removeSelection(index);
                                    },
                                    resetSelection: () {
                                      _falconeBloc.add(FetchPlanetsNVehicles());
                                      openCart = false;
                                      _animationController.reverse();
                                      model.resetSelection();
                                    },
                                  )
                                : RowCart(
                                    selectedPlanets: model.selectedPlanets,
                                    vehiclesList: model.selectedVehicles,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  void navigateToDetails(
      BuildContext context,
      PlanetsModel planet,
      List<PlanetsModel> planetsList,
      List<VehiclesModel> vehiclesList,
      SelectionModel selectionModel) async {
    var result = await Navigator.push(
        context,
        PageRouteBuilder(
          maintainState: true,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: PlanetDetailScreen(
              planets: planet,
              vehicles: vehiclesList,
              index: planetsList.indexOf(planet),
              selectionModel: selectionModel,
            ),
          ),
        ));
    setState(() {});
    if(kDebugMode) {
      debugPrint('result ${selectionModel.selectedPlanets}');
      debugPrint('result ${selectionModel.selectedVehicles}');
    }
  }

  void pushErrorScreen() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContentNotFoundScreen(),
      ),
    );
    if (res == 'retry') {
      _falconeBloc.add(FetchPlanetsNVehicles());
    }
  }
}
