import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RowCart extends StatelessWidget {
  const RowCart({
    super.key,
    required this.selectedPlanets,
    required this.vehiclesList,
  });
  final List<VehiclesModel>? vehiclesList;
  final List<PlanetsModel>? selectedPlanets;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.1,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: ListView.builder(
          itemCount: selectedPlanets!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/vehicles/${vehiclesList![index].name!.split(" ").last.toLowerCase()}.webp',
                  fit: BoxFit.cover,
                ),
                renderAnimatedArrows(),
                Image.asset(
                  'assets/images/planets/${selectedPlanets![index].name!.toLowerCase()}.webp',
                  fit: BoxFit.cover,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  renderAnimatedArrows() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey,
      direction: ShimmerDirection.ltr,
      loop: 10,
      child: const Row(
        children: [
          Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
