import 'package:flutter/material.dart';
import 'package:flutter_assignment/utils/colours.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_assignment/bloc/api_bloc.dart';
import 'package:flutter_assignment/model/covid_model.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  final ApiBloc _apiBloc = ApiBloc();
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    _apiBloc.add(GetApiList());
    super.initState();
  }

  void notifError() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Connection Time Out"),
            content: Text("Do you want to reconnect?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      _apiBloc.add(GetApiList());
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("No")),
            ],
          );
        });
  }

  Widget _buildListApi() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: BlocProvider(
            create: (_) => _apiBloc,
            child: BlocListener<ApiBloc, ApiState>(
              listener: (context, state) {
                if (state is ApiError) {
                  notifError();
                }
              },
              child: BlocBuilder<ApiBloc, ApiState>(
                builder: (context, state) {
                  if (state is ApiInitState) {
                    return _buildLoading();
                  } else if (state is ApiLoading) {
                    return _buildLoading();
                  } else if (state is ApiLoaded) {
                    return _buildWidget(context, state.covidModel);
                  } else if (state is ApiError) {
                    return Container(
                        child: Center(
                            child: Text('Your connection has timed out')));
                  }
                },
              ),
            )));
  }

  Widget _buildWidget(BuildContext context, CovidModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Country: ${model.countries[index].country}"),
                                Text(
                                    "Total Confirmed: ${model.countries[index].totalConfirmed}"),
                                Text(
                                    "Total Deaths: ${model.countries[index].totalDeaths}"),
                                Text(
                                    "Total Recovered: ${model.countries[index].totalRecovered}"),
                              ],
                            )),
                        Expanded(
                          flex: 2,
                          child: Container(
                              child: Center(
                            child: IconButton(
                                icon: Icon(Icons.notifications_on),
                                onPressed: () {}),
                          )),
                        )
                      ],
                    )));
          }),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : Container(),
          centerTitle: true,
          title: _isSearching
              ? _buildSearchField()
              : Text("My App", style: TextStyle(color: Colors.white)),
          actions: _buildActions(),
        ),
        body: _buildListApi());
  }
}
