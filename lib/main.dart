import 'package:platform_core_frontend/app/app.dart';
import 'package:platform_core_frontend/app/bootstrap.dart';
import 'package:platform_core_frontend/core/config/app_config.dart';

void main() {
  const config = AppConfig.platformCoreDev;
  final services = bootstrapServices(config);

  bootstrap(() => App(services: services));
}
