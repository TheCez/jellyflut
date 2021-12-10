import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  late DetailsInfosFuture _d;
  DetailsInfosFuture get detailsInfos => _d;

  DetailsBloc(this._d) : super(DetailsLoadedState(_d));

  @override
  Stream<DetailsState> mapEventToState(
    DetailsEvent event,
  ) async* {
    if (event is DetailsItemInfos) {
      _d = event.detailsInfos;
      yield DetailsLoadedState(_d);
    }
  }
}
