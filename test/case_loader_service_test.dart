import 'package:flutter_test/flutter_test.dart';
import 'package:chasethecase/services/case_loader_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CaseLoaderService parses CASE-017 JSON bundle from assets', () async {
    final pkg = await CaseLoaderService.loadCaseBundleFromAssets('assets/cases/case_017_atlantic_night');
    expect(pkg, isNotNull);
    expect(pkg!.manifest.id, 'CASE-017');
    expect(pkg.manifest.flight.flightNumber, 'AF-447');
    expect(pkg.eventAxis.markers.isNotEmpty, true);
    expect(pkg.evidenceNodes.length, greaterThanOrEqualTo(5));
    expect(pkg.evidenceRelations.isNotEmpty, true);
    expect(pkg.causalGraph.nodes.isNotEmpty, true);
  });

  test('CaseLoaderService parses CASE-002 JSON bundle from assets', () async {
    final pkg = await CaseLoaderService.loadCaseBundleFromAssets('assets/cases/case_002_ghost_flight_helios');
    expect(pkg, isNotNull);
    expect(pkg!.manifest.id, 'CASE-002');
    expect(pkg.manifest.flight.flightNumber, 'HCY-522');
    expect(pkg.evidenceNodes.isNotEmpty, true);
  });

  test('CaseLoaderService parses CASE-001 JSON bundle from assets', () async {
    final pkg = await CaseLoaderService.loadCaseBundleFromAssets('assets/cases/case_001_tenerife_collision');
    expect(pkg, isNotNull);
    expect(pkg!.manifest.id, 'CASE-001');
    expect(pkg.evidenceNodes.isNotEmpty, true);
  });
}
