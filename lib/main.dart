import 'package:flutter/material.dart';

import 'src/app_state.dart';

void main() {
  runApp(MarcAppScope(state: MarcAppState(), child: const MarcApp()));
}

class MarcAppScope extends InheritedNotifier<MarcAppState> {
  const MarcAppScope({
    super.key,
    required MarcAppState state,
    required super.child,
  }) : super(notifier: state);

  static MarcAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MarcAppScope>();
    assert(scope != null, 'MarcAppScope was not found in the widget tree');
    return scope!.notifier!;
  }
}

class MarcApp extends StatelessWidget {
  const MarcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    return MaterialApp(
      title: 'MarcAPP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: state.currentUser == null ? const LoginScreen() : const RoleHome(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'empleado@marcapp.pe');
  final _password = TextEditingController(text: '123456');
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.location_on,
                  color: theme.colorScheme.primary,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'MarcAPP',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Registro de asistencia laboral con validacion GPS en tiempo real',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contrasena',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: const Text('Iniciar sesion'),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _setCredentials('empleado@marcapp.pe'),
                              icon: const Icon(Icons.badge_outlined),
                              label: const Text('Demo empleado'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _setCredentials('admin@marcapp.pe'),
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                              ),
                              label: const Text('Demo empresa'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setCredentials(String email) {
    setState(() {
      _email.text = email;
      _password.text = '123456';
      _error = null;
    });
  }

  void _login() {
    final ok = MarcAppScope.of(context).login(_email.text, _password.text);
    if (!ok) {
      setState(() => _error = 'Credenciales no validas para el prototipo.');
    }
  }
}

class RoleHome extends StatelessWidget {
  const RoleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final role = MarcAppScope.of(context).currentUser!.role;
    return role == UserRole.admin ? const AdminHome() : const EmployeeHome();
  }
}

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'MarcAPP Empleado',
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.punch_clock_outlined),
          label: 'Marcar',
        ),
        NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
        NavigationDestination(
          icon: Icon(Icons.business_outlined),
          label: 'Empresa',
        ),
      ],
      children: const [
        EmployeeCheckInView(),
        EmployeeHistoryView(),
        EmployeeCompanyView(),
      ],
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'MarcAPP Empresa',
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Panel',
        ),
        NavigationDestination(
          icon: Icon(Icons.place_outlined),
          label: 'Paradas',
        ),
        NavigationDestination(
          icon: Icon(Icons.group_add_outlined),
          label: 'Solicitudes',
        ),
        NavigationDestination(
          icon: Icon(Icons.summarize_outlined),
          label: 'Reportes',
        ),
      ],
      children: const [
        AdminDashboardView(),
        AdminStopsView(),
        AdminRequestsView(),
        AdminReportsView(),
      ],
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.destinations,
    required this.children,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final String title;
  final List<NavigationDestination> destinations;
  final List<Widget> children;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final content = SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: children[selectedIndex],
          ),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              Center(child: Text(state.currentUser!.name)),
              IconButton(
                tooltip: 'Cerrar sesion',
                onPressed: state.logout,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: wide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      destinations: destinations
                          .map(
                            (destination) => NavigationRailDestination(
                              icon: destination.icon,
                              selectedIcon: destination.selectedIcon,
                              label: Text(destination.label),
                            ),
                          )
                          .toList(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  destinations: destinations,
                ),
        );
      },
    );
  }
}

class EmployeeCheckInView extends StatelessWidget {
  const EmployeeCheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    final employee = state.currentEmployee!;
    final stop = state.assignedStop!;
    final validation = state.employeeGpsValidation!;
    final last = state.lastAttendance;
    final canMark = validation.available && validation.insideZone;
    return ListView(
      children: [
        SectionHeader(
          title: 'Marcar asistencia',
          subtitle: '${employee.fullName} - ${employee.position}',
        ),
        const SizedBox(height: 12),
        StatusCard(
          icon: validation.insideZone ? Icons.gps_fixed : Icons.gps_off,
          title: validation.insideZone ? 'Zona valida' : 'Marcacion bloqueada',
          value: validation.message,
          color: validation.insideZone
              ? const Color(0xFF0F766E)
              : const Color(0xFFB45309),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.siteName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${stop.name} - radio ${stop.radiusMeters.toStringAsFixed(0)} m',
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: validation.available
                      ? (1 -
                                validation.distanceMeters /
                                    (stop.radiusMeters * 2))
                            .clamp(0.0, 1.0)
                      : 0,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Text(
                  validation.available
                      ? 'Distancia simulada: ${validation.distanceMeters.toStringAsFixed(1)} m'
                      : 'Sin lectura de GPS disponible',
                ),
                const SizedBox(height: 14),
                SegmentedButton<GpsScenario>(
                  segments: const [
                    ButtonSegment(
                      value: GpsScenario.insideZone,
                      icon: Icon(Icons.my_location),
                      label: Text('Dentro'),
                    ),
                    ButtonSegment(
                      value: GpsScenario.outsideZone,
                      icon: Icon(Icons.wrong_location_outlined),
                      label: Text('Fuera'),
                    ),
                    ButtonSegment(
                      value: GpsScenario.unavailable,
                      icon: Icon(
                        Icons.signal_cellular_connected_no_internet_4_bar,
                      ),
                      label: Text('Sin GPS'),
                    ),
                  ],
                  selected: {state.gpsScenario},
                  onSelectionChanged: (selection) =>
                      state.setGpsScenario(selection.first),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: canMark
                    ? () => _mark(context, AttendanceType.entry)
                    : null,
                icon: const Icon(Icons.login),
                label: const Text('Marcar entrada'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: canMark
                    ? () => _mark(context, AttendanceType.exit)
                    : null,
                icon: const Icon(Icons.logout),
                label: const Text('Marcar salida'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InfoTile(
          icon: Icons.schedule,
          title: 'Ultima marcacion',
          subtitle: last == null
              ? 'Todavia no hay registros'
              : '${_attendanceLabel(last.type)} - ${state.formatDate(last.timestamp)} ${state.formatTime(last.timestamp)}',
        ),
      ],
    );
  }

  void _mark(BuildContext context, AttendanceType type) {
    final state = MarcAppScope.of(context);
    final record = state.markAttendance(type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          record == null
              ? 'No se pudo registrar: ubicacion invalida.'
              : '${_attendanceLabel(type)} registrada a las ${state.formatTime(record.timestamp)}.',
        ),
      ),
    );
  }
}

class EmployeeHistoryView extends StatelessWidget {
  const EmployeeHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    final employee = state.currentEmployee!;
    final records = state.recordsForEmployee(employee.id);
    return ListView(
      children: [
        SectionHeader(
          title: 'Historial personal',
          subtitle:
              '${records.length} marcaciones - ${state.workedHoursFor(employee.id).toStringAsFixed(1)} h acumuladas',
        ),
        const SizedBox(height: 12),
        for (final record in records)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoTile(
              icon: record.type == AttendanceType.entry
                  ? Icons.login
                  : Icons.logout,
              title: _attendanceLabel(record.type),
              subtitle:
                  '${state.stopById(record.stopId).siteName} - ${state.formatDate(record.timestamp)} ${state.formatTime(record.timestamp)}',
              trailing: Chip(
                label: Text(record.validGps ? 'GPS valido' : 'Observado'),
                avatar: Icon(
                  record.validGps ? Icons.verified : Icons.warning,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class EmployeeCompanyView extends StatelessWidget {
  const EmployeeCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    final company = state.currentCompany!;
    final employee = state.currentEmployee!;
    final requests = state.joinRequests
        .where((request) => request.employeeId == employee.id)
        .toList();
    return ListView(
      children: [
        SectionHeader(title: company.name, subtitle: company.description),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil del empleado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                InfoTile(
                  icon: Icons.person_outline,
                  title: employee.fullName,
                  subtitle:
                      'DNI ${employee.document} - rating ${employee.rating.toStringAsFixed(1)}/5',
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: state.createJoinRequest,
                  icon: const Icon(Icons.group_add_outlined),
                  label: const Text('Solicitar ingreso a obra'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SectionHeader(
          title: 'Solicitudes',
          subtitle: 'Seguimiento de ingreso a planilla',
        ),
        const SizedBox(height: 8),
        for (final request in requests)
          InfoTile(
            icon: Icons.assignment_outlined,
            title: request.siteName,
            subtitle:
                'Estado: ${_requestLabel(request.status)} - ${state.formatDate(request.createdAt)}',
          ),
      ],
    );
  }
}

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    return ListView(
      children: [
        const SectionHeader(
          title: 'Panel de monitoreo',
          subtitle: 'Indicadores de asistencia por obra y empresa',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          children: [
            for (final metric in state.dashboardMetrics)
              MetricCard(metric: metric),
          ],
        ),
        const SizedBox(height: 16),
        const SectionHeader(
          title: 'Marcaciones recientes',
          subtitle: 'Vista en tiempo real',
        ),
        const SizedBox(height: 8),
        for (final record in state.reportRecords().take(6))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoTile(
              icon: record.type == AttendanceType.entry
                  ? Icons.login
                  : Icons.logout,
              title: state.employeeById(record.employeeId).fullName,
              subtitle:
                  '${_attendanceLabel(record.type)} en ${state.stopById(record.stopId).name} - ${state.formatTime(record.timestamp)}',
              trailing: const Chip(label: Text('Valida')),
            ),
          ),
      ],
    );
  }
}

class AdminStopsView extends StatefulWidget {
  const AdminStopsView({super.key});

  @override
  State<AdminStopsView> createState() => _AdminStopsViewState();
}

class _AdminStopsViewState extends State<AdminStopsView> {
  final _name = TextEditingController(text: 'Nueva parada');
  final _site = TextEditingController(text: 'Obra Los Olivos');
  double _radius = 100;

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    return ListView(
      children: [
        const SectionHeader(
          title: 'Gestion de paradas',
          subtitle: 'Crear, editar radio y eliminar zonas autorizadas',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de parada',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _site,
                  decoration: const InputDecoration(labelText: 'Obra'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _radius,
                        min: 50,
                        max: 250,
                        divisions: 8,
                        label: '${_radius.round()} m',
                        onChanged: (value) => setState(() => _radius = value),
                      ),
                    ),
                    SizedBox(width: 72, child: Text('${_radius.round()} m')),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => state.addStop(
                      name: _name.text,
                      siteName: _site.text,
                      radiusMeters: _radius,
                    ),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Crear parada'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (final stop in state.stops)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.siteName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${stop.name} - ${stop.radiusMeters.toStringAsFixed(0)} m - ${stop.employeeIds.length} empleados asignados',
                    ),
                    Slider(
                      value: stop.radiusMeters.clamp(50, 250),
                      min: 50,
                      max: 250,
                      divisions: 8,
                      label: '${stop.radiusMeters.round()} m',
                      onChanged: (value) =>
                          state.updateStopRadius(stop.id, value),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final deleted = state.deleteStop(stop.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                deleted
                                    ? 'Parada eliminada.'
                                    : 'No se puede eliminar: tiene empleados o asistencias.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Eliminar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AdminRequestsView extends StatelessWidget {
  const AdminRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    return ListView(
      children: [
        const SectionHeader(
          title: 'Solicitudes y plantilla',
          subtitle: 'Aceptar empleados y revisar personal actual',
        ),
        const SizedBox(height: 12),
        for (final request in state.joinRequests)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoTile(
              icon: Icons.assignment_ind_outlined,
              title: state.employeeById(request.employeeId).fullName,
              subtitle:
                  '${request.siteName} - estado ${_requestLabel(request.status)}',
              trailing: request.status == RequestStatus.pending
                  ? Wrap(
                      spacing: 4,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Aceptar',
                          onPressed: () => state.decideRequest(
                            request.id,
                            RequestStatus.accepted,
                          ),
                          icon: const Icon(Icons.check),
                        ),
                        IconButton.outlined(
                          tooltip: 'Rechazar',
                          onPressed: () => state.decideRequest(
                            request.id,
                            RequestStatus.rejected,
                          ),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    )
                  : Chip(label: Text(_requestLabel(request.status))),
            ),
          ),
        const SizedBox(height: 16),
        const SectionHeader(
          title: 'Empleados actuales',
          subtitle: 'Personal por parada',
        ),
        const SizedBox(height: 8),
        for (final employee in state.employees)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoTile(
              icon: employee.active
                  ? Icons.verified_user_outlined
                  : Icons.person_off,
              title: employee.fullName,
              subtitle:
                  '${employee.position} - ${state.stopById(employee.assignedStopId).name}',
              trailing: Chip(
                label: Text(employee.active ? 'Activo' : 'Pendiente'),
              ),
            ),
          ),
      ],
    );
  }
}

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MarcAppScope.of(context);
    final records = state.reportRecords();
    return ListView(
      children: [
        SectionHeader(
          title: 'Reportes de asistencia',
          subtitle:
              '${records.length} registros filtrados - exportacion simulada',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          children: [
            for (final payment in state.paymentSchedule)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.employeeName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('${payment.validAttendances} marcaciones validas'),
                      Text(
                        '${payment.totalHours.toStringAsFixed(1)} horas acumuladas',
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(payment.status)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte PDF/Excel simulado para el prototipo.'),
            ),
          ),
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Exportar reporte'),
        ),
        const SizedBox(height: 12),
        for (final record in records)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoTile(
              icon: Icons.fact_check_outlined,
              title: state.employeeById(record.employeeId).fullName,
              subtitle:
                  '${state.stopById(record.stopId).siteName} - ${_attendanceLabel(record.type)} - ${state.formatDate(record.timestamp)} ${state.formatTime(record.timestamp)}',
              trailing: const Chip(label: Text('GPS OK')),
            ),
          ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              foregroundColor: Colors.white,
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.metric});

  final ReportMetric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(metric.label, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              metric.value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: metric.value.contains('%')
                  ? (int.tryParse(metric.value.replaceAll('%', '')) ?? 0) / 100
                  : 0.68,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              metric.delta,
              style: const TextStyle(color: Color(0xFF0F766E)),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 620
            ? 2
            : 1;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 1 ? 2.9 : 1.65,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

String _attendanceLabel(AttendanceType type) {
  return type == AttendanceType.entry ? 'Entrada' : 'Salida';
}

String _requestLabel(RequestStatus status) {
  return switch (status) {
    RequestStatus.pending => 'Pendiente',
    RequestStatus.accepted => 'Aceptada',
    RequestStatus.rejected => 'Rechazada',
  };
}
