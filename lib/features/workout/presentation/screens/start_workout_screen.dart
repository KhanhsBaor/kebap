import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/core/theme/kebap_typography.dart';
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/l10n/app_localizations.dart';

const _regionSlugs = ['upper_body', 'lower_body', 'other'];

/// S04. One region per workout. Switching region clears the selection.
class StartWorkoutScreen extends ConsumerStatefulWidget {
  const StartWorkoutScreen({super.key});

  @override
  ConsumerState<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends ConsumerState<StartWorkoutScreen> {
  int? _regionId;
  final List<int> _selectedIds = [];
  var _prompted = false;
  var _starting = false;
  ProviderSubscription<AsyncValue<WorkoutSession?>>? _sessionSub;

  @override
  void initState() {
    super.initState();
    _sessionSub = ref.listenManual(activeWorkoutProvider, (previous, next) {
      final session = next.asData?.value;
      if (session == null || _prompted) return;
      _prompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showInProgressDialog();
      });
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _sessionSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(activeWorkoutCommandsProvider);

    final l10n = AppLocalizations.of(context);
    final regionsAsync = ref.watch(bodyRegionsProvider);
    final groupsAsync = ref.watch(muscleGroupsProvider);
    final regions = regionsAsync.asData?.value;
    final groups = groupsAsync.asData?.value;

    return Scaffold(
      key: const ValueKey('start-workout-screen'),
      appBar: AppBar(title: Text(l10n.startWorkoutTitle)),
      body: switch ((regionsAsync, groupsAsync, regions, groups)) {
        (AsyncError(), _, _, _) ||
        (_, AsyncError(), _, _) => _EmptyCatalog(message: l10n.noMuscleGroups),
        (_, _, final regions?, final groups?)
            when regions.isEmpty || groups.isEmpty =>
          _EmptyCatalog(message: l10n.noMuscleGroups),
        (_, _, final regions?, final groups?) => _Picker(
          regions: _orderedRegions(regions),
          groups: groups,
          regionId: _regionId,
          selectedIds: _selectedIds,
          starting: _starting,
          onRegion: _viewRegion,
          onGroup: _toggleGroup,
          onStart: _start,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  void _viewRegion(int id, int fallbackId) {
    final current = _regionId ?? fallbackId;
    setState(() {
      if (current != id) _selectedIds.clear();
      _regionId = id;
    });
  }

  void _toggleGroup(MuscleGroup group) {
    setState(() {
      _regionId = group.regionId;
      if (_selectedIds.contains(group.id)) {
        _selectedIds.remove(group.id);
      } else {
        _selectedIds.add(group.id);
      }
    });
  }

  Future<void> _start() async {
    final regionId = _regionId;
    if (regionId == null || _selectedIds.isEmpty || _starting) return;
    setState(() => _starting = true);
    await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .startWorkout(
          regionId: regionId,
          muscleGroupIds: List.of(_selectedIds),
        );
    if (!mounted) return;
    final notice = ref.read(activeWorkoutCommandsProvider);
    if (notice != null) {
      setState(() => _starting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).startWorkoutFailed),
        ),
      );
      return;
    }
    context.pushReplacementNamed(AppRoutes.activeWorkoutName);
  }

  Future<void> _showInProgressDialog() {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<KebapColors>()!;
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusCard),
            side: BorderSide(color: colors.border),
          ),
          title: Text(l10n.workoutInProgressTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                key: const ValueKey('continue-that-workout'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.pushReplacementNamed(AppRoutes.activeWorkoutName);
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(spacing.touch),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                child: Text(l10n.continueThatWorkout),
              ),
              SizedBox(height: spacing.sm),
              OutlinedButton(
                key: const ValueKey('discard-and-start-new'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await ref
                      .read(activeWorkoutCommandsProvider.notifier)
                      .cancelWorkout();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.trendDown,
                  minimumSize: Size.fromHeight(spacing.touch),
                  side: BorderSide(color: colors.trendDown),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusCard),
                  ),
                ),
                child: Text(l10n.discardAndStartNew),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xl,
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({
    required this.regions,
    required this.groups,
    required this.regionId,
    required this.selectedIds,
    required this.starting,
    required this.onRegion,
    required this.onGroup,
    required this.onStart,
  });

  final List<BodyRegion> regions;
  final List<MuscleGroup> groups;
  final int? regionId;
  final List<int> selectedIds;
  final bool starting;
  final void Function(int id, int fallbackId) onRegion;
  final void Function(MuscleGroup group) onGroup;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final locale = Localizations.localeOf(context);
    final viewed = regions.firstWhere(
      (region) => region.id == regionId,
      orElse: () => regions.first,
    );
    final visible = [
      for (final group in groups)
        if (group.regionId == viewed.id) group,
    ];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final region in regions)
                    _ChoiceChip(
                      key: ValueKey('region-${region.slug}'),
                      label: catalogName(
                        nameEn: region.nameEn,
                        nameVi: region.nameVi,
                        locale: locale,
                      ),
                      selected: region.id == viewed.id,
                      onTap: () => onRegion(region.id, regions.first.id),
                    ),
                ],
              ),
              SizedBox(height: spacing.lg),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final group in visible)
                    _ChoiceChip(
                      key: ValueKey('group-${group.slug}'),
                      label: catalogName(
                        nameEn: group.nameEn,
                        nameVi: group.nameVi,
                        locale: locale,
                      ),
                      orderKey: group.slug,
                      order: selectedIds.contains(group.id)
                          ? selectedIds.indexOf(group.id) + 1
                          : null,
                      selected: selectedIds.contains(group.id),
                      onTap: () => onGroup(group),
                    ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.md,
            spacing.sm,
            spacing.md,
            spacing.md,
          ),
          child: SafeArea(
            top: false,
            child: FilledButton(
              key: const ValueKey('start-workout-button'),
              onPressed: selectedIds.isEmpty || starting ? null : onStart,
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(spacing.touch),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.border,
                disabledForegroundColor: colors.muted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusCard),
                ),
              ),
              child: Text(l10n.startWorkoutAction),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.order,
    this.orderKey,
    super.key,
  });

  final String label;
  final int? order;
  final String? orderKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KebapColors>()!;
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final numbers = Theme.of(context).extension<KebapTypography>()!;
    final radius = BorderRadius.circular(spacing.radiusControl);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? colors.surface : colors.background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: selected ? colors.foreground : colors.border),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(borderRadius: radius),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: spacing.touch,
              minHeight: spacing.touch,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (order != null) ...[
                    Text(
                      '$order',
                      key: orderKey == null
                          ? null
                          : ValueKey('group-order-$orderKey'),
                      style: numbers.secondaryNumber,
                    ),
                    SizedBox(width: spacing.sm),
                  ],
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<BodyRegion> _orderedRegions(List<BodyRegion> regions) {
  final copy = List<BodyRegion>.of(regions);
  copy.sort((a, b) {
    final aRank = _regionSlugs.indexOf(a.slug);
    final bRank = _regionSlugs.indexOf(b.slug);
    return (aRank == -1 ? _regionSlugs.length : aRank).compareTo(
      bRank == -1 ? _regionSlugs.length : bRank,
    );
  });
  return copy;
}
