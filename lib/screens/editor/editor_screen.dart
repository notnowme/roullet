import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/widgets/app_toast.dart';
import 'package:toruru/common/widgets/glass_card.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/models/map_storage.dart';
import 'package:toruru/screens/providers/editor_provider.dart';

part 'object_palette.dart';
part 'editor_canvas.dart';
part 'property_panel.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final MapData? initialMap;

  const EditorScreen({super.key, this.initialMap});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialMap != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(editorProvider.notifier).loadMap(widget.initialMap!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    return Scaffold(
      backgroundColor: AppColor.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _EditorToolbar(state: state),
            const Expanded(child: _EditorCanvas()),
            if (state.guideMessage != null) _EditorGuide(state: state),
            const _PropertyPanel(),
            const _ObjectPalette(),
          ],
        ),
      ),
    );
  }
}

// ─── 에디터 툴바 ────────────────────────────────────────────────────

class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.state});
  final EditorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.bgCard.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: AppColor.borderLight),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.textPrimary,
              size: 22,
            ),
            onPressed: () => context.pop(state.mapData),
          ),
          GestureDetector(
            onTap: () => _showNameDialog(context, ref),
            child: Text(
              state.mapData.name,
              style: const TextStyle(
                color: AppColor.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          _ActionIcon(
            icon: Icons.save_rounded,
            color: AppColor.accentSub,
            onTap: () {
              ref.read(editorProvider.notifier).save();
              AppToast.show(
                context,
                AppLocalizations.of(context)!.mapSave(state.mapData.name),
                icon: Icons.save_rounded,
                color: AppColor.accentSub,
              );
            },
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColor.textPrimary,
              size: 22,
            ),
            color: AppColor.bgElevated,
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportJson(context, state);
                case 'import':
                  _importJson(context, ref);
                case 'clear':
                  _showClearConfirm(context, ref);
                case 'test':
                  context.pop(state.mapData);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'export',
                child: Text(
                  AppLocalizations.of(context)!.jsonExport,
                  style: const TextStyle(color: AppColor.textPrimary),
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Text(
                  AppLocalizations.of(context)!.jsonImport,
                  style: const TextStyle(color: AppColor.textPrimary),
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text(
                  AppLocalizations.of(context)!.allDelete,
                  style: const TextStyle(color: AppColor.danger),
                ),
              ),
              PopupMenuItem(
                value: 'test',
                child: Text(
                  AppLocalizations.of(context)!.testPlay,
                  style: const TextStyle(color: AppColor.accentSub),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: state.mapData.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bgElevated,
        title: Text(
          AppLocalizations.of(context)!.mapName,
          style: const TextStyle(color: AppColor.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColor.textPrimary),
          decoration: AppUI.inputDecoration(
            hintText: AppLocalizations.of(context)!.newMap,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColor.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(editorProvider.notifier).setName(controller.text);
              Navigator.pop(ctx);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(color: AppColor.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _exportJson(BuildContext context, EditorState state) {
    final json = MapStorage.export(state.mapData);
    Clipboard.setData(ClipboardData(text: json));
    AppToast.show(
      context,
      AppLocalizations.of(context)!.jsonExportDesc,
      icon: Icons.copy_rounded,
    );
  }

  void _importJson(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bgElevated,
        title: Text(
          AppLocalizations.of(context)!.jsonExport,
          style: const TextStyle(color: AppColor.textPrimary),
        ),
        content: TextField(
          controller: controller,
          maxLines: 8,
          style: const TextStyle(color: AppColor.textPrimary, fontSize: 12),
          decoration: AppUI.inputDecoration(
            hintText: AppLocalizations.of(context)!.jsonImportDesc,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColor.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              final imported = MapStorage.import(controller.text);
              if (imported != null) {
                ref.read(editorProvider.notifier).loadMap(imported);
                Navigator.pop(ctx);
              }
            },
            child: Text(
              AppLocalizations.of(context)!.import,
              style: const TextStyle(color: AppColor.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bgElevated,
        title: const Text(
          '전체 삭제',
          style: TextStyle(color: AppColor.textPrimary),
        ),
        content: const Text(
          '모든 오브젝트를 삭제하시겠습니까?',
          style: TextStyle(color: AppColor.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColor.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(editorProvider.notifier).clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('삭제', style: TextStyle(color: AppColor.danger)),
          ),
        ],
      ),
    );
  }
}

// ─── 에디터 가이드 메시지 ────────────────────────────────────────────

class _EditorGuide extends ConsumerWidget {
  const _EditorGuide({required this.state});
  final EditorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColor.accent.withValues(alpha: 0.1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.guideMessage!,
              style: const TextStyle(color: AppColor.textPrimary, fontSize: 13),
            ),
          ),
          if (state.step == PlacementStep.mapLinePoints)
            GestureDetector(
              onTap: () => ref.read(editorProvider.notifier).finishMapLine(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.accentSub,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppLocalizations.of(context)!.mapDone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => ref.read(editorProvider.notifier).cancelPlacing(),
            child: const Icon(Icons.close, color: AppColor.textMuted, size: 20),
          ),
        ],
      ),
    );
  }
}
