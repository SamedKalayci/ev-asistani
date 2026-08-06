import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/providers/user_provider.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';

/// Yemek tarifi ekleme ve düzenleme formu.
class RecipeFormScreen extends ConsumerStatefulWidget {
  const RecipeFormScreen({super.key, this.editRecipe});

  final RecipeModel? editRecipe;

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _prepTimeCtrl;
  late final TextEditingController _cookTimeCtrl;
  late final TextEditingController _servingsCtrl;
  late final TextEditingController _imageUrlCtrl;

  String _selectedCategory = 'Ana Yemek';
  final List<_IngredientRow> _ingredientRows = [];
  final List<TextEditingController> _instructionControllers = [];

  bool get _isEditMode => widget.editRecipe != null;

  static const List<String> _categories = [
    'Ana Yemek',
    'Çorba',
    'Tatlı',
    'Salata',
    'Kahvaltılık',
    'Hamur İşi',
  ];

  @override
  void initState() {
    super.initState();
    final recipe = widget.editRecipe;

    _titleCtrl = TextEditingController(text: recipe?.title ?? '');
    _descCtrl = TextEditingController(text: recipe?.description ?? '');
    _prepTimeCtrl =
        TextEditingController(text: '${recipe?.prepTimeMinutes ?? 15}');
    _cookTimeCtrl =
        TextEditingController(text: '${recipe?.cookTimeMinutes ?? 30}');
    _servingsCtrl = TextEditingController(text: '${recipe?.servings ?? 4}');
    _imageUrlCtrl = TextEditingController(text: recipe?.imageUrl ?? '');

    if (recipe != null) {
      _selectedCategory = recipe.category;
      for (final ing in recipe.ingredients) {
        _ingredientRows.add(_IngredientRow(
          nameCtrl: TextEditingController(text: ing.name),
          amountCtrl: TextEditingController(text: ing.amount),
          unitCtrl: TextEditingController(text: ing.unit),
          isOptional: ing.isOptional,
        ));
      }
      for (final step in recipe.instructions) {
        _instructionControllers.add(TextEditingController(text: step));
      }
    }

    if (_ingredientRows.isEmpty) {
      _addIngredientRow();
    }
    if (_instructionControllers.isEmpty) {
      _addInstructionStep();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _prepTimeCtrl.dispose();
    _cookTimeCtrl.dispose();
    _servingsCtrl.dispose();
    _imageUrlCtrl.dispose();
    for (final row in _ingredientRows) {
      row.dispose();
    }
    for (final ctrl in _instructionControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientRows.add(_IngredientRow(
        nameCtrl: TextEditingController(),
        amountCtrl: TextEditingController(),
        unitCtrl: TextEditingController(),
      ));
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredientRows.length <= 1) return;
    setState(() {
      final removed = _ingredientRows.removeAt(index);
      removed.dispose();
    });
  }

  void _addInstructionStep() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstructionStep(int index) {
    if (_instructionControllers.length <= 1) return;
    setState(() {
      final removed = _instructionControllers.removeAt(index);
      removed.dispose();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientRows
        .map((row) => RecipeIngredientModel(
              name: row.nameCtrl.text.trim(),
              amount: row.amountCtrl.text.trim(),
              unit: row.unitCtrl.text.trim(),
              isOptional: row.isOptional,
            ))
        .where((ing) => ing.name.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen en az bir malzeme ekleyin.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final instructions = _instructionControllers
        .map((ctrl) => ctrl.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final notifier = ref.read(recipeNotifierProvider.notifier);
    final familyId = ref.read(activeFamilyIdProvider);
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';

    final prepTime = int.tryParse(_prepTimeCtrl.text.trim()) ?? 15;
    final cookTime = int.tryParse(_cookTimeCtrl.text.trim()) ?? 30;
    final servings = int.tryParse(_servingsCtrl.text.trim()) ?? 4;

    if (_isEditMode) {
      final updated = widget.editRecipe!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        category: _selectedCategory,
        prepTimeMinutes: prepTime,
        cookTimeMinutes: cookTime,
        servings: servings,
        imageUrl: _imageUrlCtrl.text.trim().isEmpty
            ? null
            : _imageUrlCtrl.text.trim(),
        ingredients: ingredients,
        instructions: instructions,
      );
      await notifier.updateRecipe(updated);
    } else {
      final newRecipe = RecipeModel(
        id: '',
        familyId: familyId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        category: _selectedCategory,
        prepTimeMinutes: prepTime,
        cookTimeMinutes: cookTime,
        servings: servings,
        imageUrl: _imageUrlCtrl.text.trim().isEmpty
            ? null
            : _imageUrlCtrl.text.trim(),
        ingredients: ingredients,
        instructions: instructions,
        createdBy: uid,
      );
      await notifier.addRecipe(newRecipe);
    }

    final state = ref.read(recipeNotifierProvider);
    if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(recipeNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Tarifi Düzenle' : 'Yeni Tarif Ekle',
          style: AppTypography.titleLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Tarif Adı',
                  hintText: 'Örn: Mercimek Çorbası, Karnıyarık...',
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Tarif adı zorunludur.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Kategori Seçimi
                Text(
                  'Kategori',
                  style: AppTypography.labelMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderMd,
                    ),
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Açıklama (İsteğe Bağlı)',
                  hintText: 'Kısa bilgi...',
                  controller: _descCtrl,
                  maxLines: 2,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Süreler ve Porsiyon
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Hazırlama (dk)',
                        hintText: '15',
                        controller: _prepTimeCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Pişirme (dk)',
                        hintText: '30',
                        controller: _cookTimeCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Porsiyon',
                        hintText: '4',
                        controller: _servingsCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Görsel URL (İsteğe Bağlı)',
                  hintText: 'https://...',
                  controller: _imageUrlCtrl,
                  keyboardType: TextInputType.url,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Malzemeler Bölümü ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Malzemeler',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addIngredientRow,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Malzeme Ekle'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ingredientRows.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final row = _ingredientRows[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: row.nameCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Malzeme adı (örn: Un)',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: row.amountCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Miktar (örn: 2)',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: row.unitCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Birim (su bardağı)',
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                          color: AppColors.error,
                          onPressed: () => _removeIngredientRow(index),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Hazırlanış Adımları ─────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hazırlanış Adımları',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addInstructionStep,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Adım Ekle'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _instructionControllers.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final ctrl = _instructionControllers[index];
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl,
                            decoration: InputDecoration(
                              hintText: '${index + 1}. Adım açıklaması...',
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                          color: AppColors.error,
                          onPressed: () => _removeInstructionStep(index),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xxl * 1.5),

                PrimaryButton(
                  text: _isEditMode ? 'Kaydet' : 'Tarifi Oluştur',
                  icon: _isEditMode ? Icons.check_rounded : Icons.add_rounded,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IngredientRow {
  _IngredientRow({
    required this.nameCtrl,
    required this.amountCtrl,
    required this.unitCtrl,
    this.isOptional = false,
  });

  final TextEditingController nameCtrl;
  final TextEditingController amountCtrl;
  final TextEditingController unitCtrl;
  bool isOptional;

  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
    unitCtrl.dispose();
  }
}
