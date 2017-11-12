import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';
import 'package:lit_example/code_generator.dart';

final List<BuildAction> actions = [
  new BuildAction(new PartBuilder([const LitTemplateGenerator()]),
      'lit_example',
      inputs: const ['web/main.dart'])
];
