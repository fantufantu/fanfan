enum NamedRoute {
  Home,
  Statistics,
  Profile,

  Authorization,
  SignIn,
  SignUp,

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

final configurations = <NamedRoute, Configuration>{
  NamedRoute.Home: Configuration(bottomNavigationBar: true),
  NamedRoute.Statistics: Configuration(bottomNavigationBar: true),
  NamedRoute.Billings: Configuration(bottomNavigationBar: true),
  NamedRoute.Authorization: Configuration(bottomNavigationBar: false),
  NamedRoute.Billing: Configuration(bottomNavigationBar: false),
  NamedRoute.EditableBilling: Configuration(bottomNavigationBar: false),
  NamedRoute.Transactions: Configuration(bottomNavigationBar: false),
  NamedRoute.Transaction: Configuration(bottomNavigationBar: false),
  NamedRoute.EditableTransaction: Configuration(bottomNavigationBar: false),
};
