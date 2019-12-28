typedef TestAction = Future Function();

/// Run list of [actions] sequentially,
/// awaiting for each action to compete before starting next action.
Future<void> runTestActions(Iterable<TestAction> actions) async {
  for (final action in actions) {
    await action();
  }
}
