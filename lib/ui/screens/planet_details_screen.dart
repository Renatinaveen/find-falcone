import 'package:find_falcone/blocs/falcone_bloc.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/selection_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';
import 'package:find_falcone/resources/events/falcone_events.dart';
import 'package:find_falcone/resources/helpers/decide_device.dart';
import 'package:find_falcone/resources/states/falcone_states.dart';
import 'package:find_falcone/ui/components/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/fonts_class.dart';
import '../../resources/theme_class.dart';

class PlanetDetailScreen extends StatefulWidget {
  final PlanetsModel planets;
  final List<VehiclesModel> vehicles;
  final int index;
  final SelectionModel selectionModel;

  const PlanetDetailScreen(
      {super.key,
      required this.index,
      required this.vehicles,
      required this.planets,
      required this.selectionModel});

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController animationController;
  late FalconeBloc _falconeBloc;

  @override
  void initState() {
    _falconeBloc = FalconeBloc();
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  initializePageController() {
    _pageController = PageController(
      initialPage: 0,
      viewportFraction:
          DecideDevice().returnDeviceType(context) == 0 ? 0.5 : 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    initializePageController();
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const BackgroundWidget(),
          BlocProvider<FalconeBloc>(
            create: (context) => _falconeBloc
              ..add(CalculateTimeToReach(
                  distance: widget.planets.distance!,
                  speed: widget.vehicles[0].speed!)),
            child: BlocListener<FalconeBloc, FalconeStates>(
              listener: (context, state) {
                if (state is AddedSearchSelection) {
                  Navigator.pop(context, state.selectionModel);
                } else if (state is SelectedMaxPlanets) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You can select only 4 planets'),
                    ),
                  );
                } else if (state is NotEnoughRange) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Not enough range, please select another vehicle'),
                    ),
                  );
                } else if (state is VehicleNotAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Vehicle not available, please select another vehicle'),
                    ),
                  );
                } else if (state is PlanetAlreadySelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Planet already selected, please select another planet'),
                    ),
                  );
                }
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: ThemeClass.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      elevation: 0,
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      renderPlanetDetails(),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          child: renderVehicles()),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  renderPlanetDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: widget.planets.name!,
          child: Center(
            child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.3,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: animationController.value * 6.3,
                      child: Image.asset(
                          'assets/images/planets/${widget.planets.name!.toLowerCase()}.webp'),
                    );
                  },
                )),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.planets.name!,
                style: const TextStyle(
                  fontSize: FontsClass.fontSize24,
                  fontWeight: FontWeight.bold,
                  color: ThemeClass.white,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Distance: ',
                    style: TextStyle(
                      fontSize: FontsClass.fontSize16,
                      fontWeight: FontWeight.normal,
                      color: ThemeClass.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.planets.distance} megamiles',
                    style: const TextStyle(
                      fontSize: FontsClass.fontSize16,
                      fontWeight: FontWeight.bold,
                      color: ThemeClass.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(width: 20),
              Center(
                child: BlocBuilder<FalconeBloc, FalconeStates>(
                  builder: (context, state) {
                    if (state is CalculatedTimeToReach) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Time: ',
                            style: TextStyle(
                              fontSize: FontsClass.fontSize16,
                              fontWeight: FontWeight.normal,
                              color: ThemeClass.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${state.timeTaken} megamiles / hour',
                            style: const TextStyle(
                              fontSize: FontsClass.fontSize16,
                              fontWeight: FontWeight.bold,
                              color: ThemeClass.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Select a vehicle',
            style: TextStyle(
              fontSize: FontsClass.fontSize16,
              fontWeight: FontWeight.normal,
              color: ThemeClass.white,
            ),
          ),
        ),
      ],
    );
  }

  renderVehicles() {
    return PageView.builder(
        controller: _pageController,
        itemCount: widget.vehicles.length,
        pageSnapping: true,
        onPageChanged: (index) {
          _falconeBloc.add(CalculateTimeToReach(
              distance: widget.planets.distance!,
              speed: widget.vehicles[index].speed!));
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: widget.vehicles[index].totalNo! > 0 ? 1 : 0.3,
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/vehicles/${widget.vehicles[index].name!.split(" ").last.toLowerCase()}.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.vehicles[index].name!,
                            style: const TextStyle(
                              fontSize: FontsClass.fontSize20,
                              fontWeight: FontWeight.bold,
                              color: ThemeClass.white,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Speed: ',
                                style: const TextStyle(
                                  fontSize: FontsClass.fontSize16,
                                  fontWeight: FontWeight.normal,
                                  color: ThemeClass.white,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        widget.vehicles[index].speed.toString(),
                                    style: const TextStyle(
                                      fontSize: FontsClass.fontSize16,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeClass.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Range: ',
                              style: const TextStyle(
                                fontSize: FontsClass.fontSize16,
                                fontWeight: FontWeight.normal,
                                color: ThemeClass.white,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.vehicles[index].maxDistance
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: FontsClass.fontSize16,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeClass.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Available: ',
                                style: const TextStyle(
                                  fontSize: FontsClass.fontSize16,
                                  fontWeight: FontWeight.normal,
                                  color: ThemeClass.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.vehicles[index].totalNo
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: FontsClass.fontSize16,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeClass.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () => widget.vehicles[index].totalNo! >
                                      0
                                  ? _falconeBloc.add(AddSearchSelection(
                                      planet: widget.planets,
                                      vehicle: widget.vehicles[
                                          _pageController.page!.toInt()],
                                      selectionModel: widget.selectionModel))
                                  : null,
                              child: const Text('Select')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.vehicles[index].totalNo! > 0)
                Container()
              else
                const Center(
                  child: Text(
                    'Not Available',
                    style: TextStyle(
                        color: ThemeClass.white,
                        backgroundColor: ThemeClass.black,
                        fontSize: FontsClass.fontSize12,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        });
  }
}
