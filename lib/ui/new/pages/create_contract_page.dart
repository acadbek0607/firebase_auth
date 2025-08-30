import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/ui/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _innController = TextEditingController();
  final _amountController = TextEditingController();

  String? _selectedType;
  StatusType? _selectedStatus;

  ContractEntity? _createdContract;

  late final VoidCallback _pageListener;
  late final VoidCallback _resetListener;

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _addressController.clear();
    _innController.clear();
    _amountController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
    });
    _createdContract = null;
  }

  @override
  void initState() {
    super.initState();
    _pageListener = () {
      if (selectedPageNotifier.value != 5) {
        _resetForm();
      }
    };
    _resetListener = _resetForm;
    selectedPageNotifier.addListener(_pageListener);
    resetContractFormNotifier.addListener(_resetListener);
  }

  @override
  void dispose() {
    selectedPageNotifier.removeListener(_pageListener);
    resetContractFormNotifier.removeListener(_resetListener);
    _fullNameController.dispose();
    _addressController.dispose();
    _innController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.darkest,
        title: Text(
          tr('new_contract', context: context),
          style: Kstyle.textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
      ),
      body: BlocConsumer<ContractBloc, ContractState>(
        listener: (context, state) {
          if (state.status == BlocStatus.loaded && _createdContract != null) {
            final match = state.contracts.firstWhere(
              (c) =>
                  c.fullName == _createdContract!.fullName &&
                  c.inn == _createdContract!.inn &&
                  c.createdAt.isAtSameMomentAs(_createdContract!.createdAt),
              orElse: () => state.contracts.last,
            );

            Navigator.pushReplacementNamed(
              context,
              '/contract_detail',
              arguments: {
                'contract': match,
                'allContracts': state.contracts,
                'originIndex': 0,
              },
            );
          } else if (state.status == BlocStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage.toString())),
            );
          }
        },
        builder: (context, state) {
          final isFormComplete =
              _selectedType != null &&
              _fullNameController.text.isNotEmpty &&
              _addressController.text.isNotEmpty &&
              _innController.text.isNotEmpty &&
              _selectedStatus != null &&
              _amountController.text.isNotEmpty;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 20.0),
                      Text(
                        'Entity',
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      CustomDropdown(
                        label: '',
                        value: _selectedType ?? '',
                        items: [
                          tr('personal', context: context),
                          tr('legal', context: context),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedType = val);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        tr('fisher', context: context),
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _fullNameController,
                        style: Kstyle.textStyle,
                        textCapitalization: TextCapitalization.words,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              width: 1.2,
                              color: _fullNameController.text.isNotEmpty
                                  ? AppColors.newLabel
                                  : AppColors.newLabel.withAlpha(102),
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        tr('address_of', context: context),
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _addressController,
                        textCapitalization: TextCapitalization.words,
                        style: Kstyle.textStyle,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              width: 1.2,
                              color: _addressController.text.isNotEmpty
                                  ? AppColors.newLabel
                                  : AppColors.newLabel.withAlpha(102),
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        tr('iec', context: context),
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _innController,
                        style: Kstyle.textStyle,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              width: 1.2,
                              color: _innController.text.isNotEmpty
                                  ? AppColors.newLabel
                                  : AppColors.newLabel.withAlpha(102),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/help.svg',
                                height: 20.0,
                              ),
                              color: AppColors.newLabel,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: AppColors.dark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16.0,
                                      16.0,
                                      16.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            color: AppColors.commentTF,
                                          ),
                                          child: Text(
                                            tr('iec_info', context: context),
                                            style: Kstyle.textStyle,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              tr('close', context: context),
                                              style: Kstyle.textStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        tr('status_of_contract', context: context),
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      CustomDropdown(
                        label: '',
                        value: _selectedStatus?.label(context) ?? '',
                        items: StatusType.values
                            .map((s) => s.label(context))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStatus = StatusTypeExtension.fromLabel(
                                val,
                                context,
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Cost of the contract',
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardGrey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _amountController,
                        style: Kstyle.textStyle,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              width: 1.2,
                              color: _amountController.text.isNotEmpty
                                  ? AppColors.newLabel
                                  : AppColors.newLabel.withAlpha(102),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final digits = newValue.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (digits.isEmpty) {
                              return const TextEditingValue(text: '');
                            }
                            final formatted = KFormat.amountFormat.format(
                              int.parse(digits),
                            );
                            final withCurrency =
                                '$formatted ${tr('currency', context: context)}';
                            return TextEditingValue(
                              text: withCurrency,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          }),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                      ),
                      if (isFormComplete) ...[
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final contract = ContractEntity(
                                type: _selectedType!,
                                fullName: _fullNameController.text,
                                organizationAddress: _addressController.text,
                                inn: _innController.text,
                                status: _selectedStatus!,
                                amount: double.parse(
                                  _amountController.text.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  ),
                                ),
                                createdAt: DateTime.now(),
                              );

                              _createdContract = contract;

                              context.read<ContractBloc>().add(
                                CreateContractEvent(contract),
                              );
                            }
                          },
                          style: Kstyle.buttonStyle,
                          child: Text(
                            tr('save_contract', context: context),
                            style: Kstyle.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (state.status == BlocStatus.loading)
                const Center(child: CircularProgressIndicator.adaptive()),
            ],
          );
        },
      ),
    );
  }
}
