import 'package:flutter/material.dart';

import '../agregar_parada/agregar_parada.dart';
import '../administrar_paradas/administrar_paradas.dart';
import '../empleados_actuales/empleados_actuales.dart';
import '../ver_solicitudes/ver_solicitudes.dart';

class ResumenEmpresaPage extends StatelessWidget {
  const ResumenEmpresaPage({super.key});

  static const _backgroundColor = Color(0xFFF6FAF8);
  static const _cardColor = Colors.white;
  static const _primaryColor = Color(0xFF34A0A4);
  static const _titleColor = Color(0xFF184E77);
  static const _mutedTextColor = Color(0xFF98A2B3);
  static const _bodyTextColor = Color(0xFF111827);
  static const _softBorderColor = Color(0xFFE6EAF0);

  static const _asistencias = 0;
  static const _paradas = 0;
  static const _variacion = 0;
  static const _empleadosPresentes = 0;
  static const _empleadosTotales = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _StatsRow(),
                    const SizedBox(height: 20),
                    const _TodaySummaryCard(),
                    const SizedBox(height: 22),
                    const Text(
                      'Acciones rápidas',
                      style: TextStyle(
                        color: _bodyTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _QuickActionsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _EmpresaBottomNav(),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 10),
      decoration: const BoxDecoration(
        color: ResumenEmpresaPage._cardColor,
        border: Border(bottom: BorderSide(color: Color(0xFFEFF2F5))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: ResumenEmpresaPage._mutedTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Constructora XYZ',
                  style: TextStyle(
                    color: ResumenEmpresaPage._titleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            showBadge: true,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.logout_rounded,
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IconButton(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF1F3F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: EdgeInsets.zero,
              icon: Icon(
                icon,
                size: 18,
                color: ResumenEmpresaPage._bodyTextColor,
              ),
              tooltip: showBadge ? 'Notificaciones' : 'Salir',
            ),
          ),
          if (showBadge)
            Positioned(
              top: 6,
              right: 7,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.groups_2_outlined,
            iconColor: ResumenEmpresaPage._primaryColor,
            iconBackground: Color(0xFFE6F7F5),
            value: '${ResumenEmpresaPage._asistencias}',
            label: 'Asistencias',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.location_on_outlined,
            iconColor: Color(0xFF52B69A),
            iconBackground: Color(0xFFE6F7EF),
            value: '${ResumenEmpresaPage._paradas}',
            label: 'Paradas',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up_rounded,
            iconColor: Color(0xFF00A759),
            iconBackground: Color(0xFFE8F8ED),
            value: '+${ResumenEmpresaPage._variacion}%',
            valueColor: Color(0xFF00A759),
            label: 'vs. ayer',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: ResumenEmpresaPage._cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ResumenEmpresaPage._softBorderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F184E77),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? ResumenEmpresaPage._bodyTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: ResumenEmpresaPage._mutedTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard();

  @override
  Widget build(BuildContext context) {
    const total = ResumenEmpresaPage._empleadosTotales;
    const present = ResumenEmpresaPage._empleadosPresentes;
    const progress = total == 0 ? 0.0 : present / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(19, 20, 19, 19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34A0A4), Color(0xFF184E77)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33184E77),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de hoy',
            style: TextStyle(
              color: Color(0xBFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '$present / $total',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'empleados han asistido',
            style: TextStyle(
              color: Color(0xD9FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0x3DFFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF99D98C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  _QuickActionsGrid();

  final List<_QuickActionData> actions = [
    _QuickActionData(
      title: 'Administrar sitios',
      icon: Icons.location_on_outlined,
      iconColor: ResumenEmpresaPage._primaryColor,
      iconBackground: const Color(0xFFE6F7F5),
      pageBuilder: (_) => const AdministrarParadasPage(),
    ),
    _QuickActionData(
      title: 'Agregar parada',
      icon: Icons.add_rounded,
      iconColor: ResumenEmpresaPage._titleColor,
      iconBackground: const Color(0xFFE7F0F5),
      pageBuilder: (_) => const AgregarParadaPage(),
    ),
    _QuickActionData(
      title: 'Ver empleados',
      icon: Icons.groups_2_outlined,
      iconColor: const Color(0xFF52B69A),
      iconBackground: const Color(0xFFE6F7EF),
      pageBuilder: (_) => const EmpleadosActualesPage(),
    ),
    _QuickActionData(
      title: 'Solicitudes',
      icon: Icons.task_alt_rounded,
      iconColor: const Color(0xFFFFA300),
      iconBackground: const Color(0xFFFFF4DD),
      pageBuilder: (_) => const VerSolicitudesPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.67,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return _QuickActionCard(action: action);
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickActionData action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ResumenEmpresaPage._cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 1.5,
      shadowColor: const Color(0x26184E77),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: action.pageBuilder),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: action.iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.iconColor, size: 18),
              ),
              const Spacer(),
              Text(
                action.title,
                style: const TextStyle(
                  color: ResumenEmpresaPage._bodyTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.pageBuilder,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final WidgetBuilder pageBuilder;
}

class _EmpresaBottomNav extends StatelessWidget {
  const _EmpresaBottomNav();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 63,
        margin: const EdgeInsets.fromLTRB(19, 0, 19, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26184E77),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: _NavItem(
                icon: Icons.home_outlined,
                label: 'Inicio',
                selected: true,
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.location_on_outlined,
                label: 'Sitios',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdministrarParadasPage(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.groups_2_outlined,
                label: 'Empleados',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmpleadosActualesPage(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.description_outlined,
                label: 'Solicitudes',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerSolicitudesPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? ResumenEmpresaPage._primaryColor
        : ResumenEmpresaPage._mutedTextColor;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F7F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
