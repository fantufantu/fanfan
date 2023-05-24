enum NamedRoute {
  Home,
  Statistics,
  Authorization,

  Billings,
  Billing,
  EditableBilling,

  Transactions,
  Transaction,
  EditableTransaction
}

class AppBar {
  String? title;
}

class Configuration {
  Configuration({
    this.appBar,
    required this.bottomNavigationBar,
  });

  late AppBar? appBar;
  late bool bottomNavigationBar;
}

final configurations = Map<NamedRoute, Configuration>();
