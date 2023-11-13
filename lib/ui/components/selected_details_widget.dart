import 'package:find_falcone/blocs/falcone_bloc.dart';
import 'package:find_falcone/models/selection_model.dart';
import 'package:find_falcone/resources/events/falcone_events.dart';
import 'package:find_falcone/resources/states/falcone_states.dart';
import 'package:find_falcone/ui/components/selected_row_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/search_result_srceen.dart';

class SelectedDetails extends StatefulWidget {
  final SelectionModel selectionModel;
  final VoidCallback closeCart;
  final Function(int index) removeItem;
  final VoidCallback resetSelection;

  const SelectedDetails({
    super.key,
    required this.selectionModel,
    required this.closeCart,
    required this.removeItem,
    required this.resetSelection,
  });

  @override
  State<SelectedDetails> createState() => _SelectedDetailsState();
}

class _SelectedDetailsState extends State<SelectedDetails> {
  late ScrollController _scrollController;
  late FalconeBloc _falconeBloc;

  @override
  void initState() {
    _falconeBloc = FalconeBloc();
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset <=
            _scrollController.position.minScrollExtent) {
          setState(() {
            widget.closeCart();
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FalconeBloc>(
      create: (context) => _falconeBloc,
      child: BlocListener<FalconeBloc, FalconeStates>(
        listener: (context, state) {
          if (state is FalconeResponse) {
            widget.resetSelection();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SearchResult(
                  error: state.error,
                  planetName: state.planetName,
                  status: state.status,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<FalconeBloc, FalconeStates>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ...List.generate(
                    widget.selectionModel.selectedPlanets.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: RowCart(
                            selectedPlanets: [
                              widget.selectionModel.selectedPlanets[index],
                            ],
                            vehiclesList: [
                              widget.selectionModel.selectedVehicles[index]
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              widget.removeItem(index);
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    growable: true,
                  ),
                  const SizedBox(height: 20),
                  widget.selectionModel.selectedPlanets.isNotEmpty
                      ? ElevatedButton(
                          onPressed: () => findFalconeMethod(),
                          child: const Text('Find Falcone'))
                      : const Text(
                          'No Planets Selected',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void findFalconeMethod() {
    if (widget.selectionModel.selectedPlanets.length == 4) {
      _falconeBloc.add(SearchFalcone(selectionModel: widget.selectionModel));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select 4 planets to conduct search operation',
          ),
        ),
      );
    }
  }
}
