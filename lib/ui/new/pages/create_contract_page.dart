import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/ui/detail/pages/contract_detail_page.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:fire_auth/ui/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';

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

  String _selectedType = 'legal';
  StatusType _selectedStatus = StatusType.inProcess;

  ContractEntity? _createdContract;

  @override
  Widget build(BuildContext context) {
    selectedPageNotifier.value = 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Contract')),
      body: BlocConsumer<ContractBloc, ContractState>(
        listener: (context, state) {
          if (state is ContractLoaded && _createdContract != null) {
            final match = state.contracts.firstWhere(
              (c) =>
                  c.fullName == _createdContract!.fullName &&
                  c.inn == _createdContract!.inn &&
                  c.createdAt.isAtSameMomentAs(_createdContract!.createdAt),
              orElse: () => state.contracts.last,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ContractDetailPage(
                  contract: match,
                  allContracts: state.contracts,
                ),
              ),
            );
          } else if (state is ContractError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 20.0),
                      Text('Entity', style: Kstyle.textStyle),
                      const SizedBox(height: 6.0),
                      CustomDropdown(
                        label: 'Entity Type',
                        value: _selectedType,
                        items: ['personal', 'legal'],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedType = val);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text('''Fisher's full name''', style: Kstyle.textStyle),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'Full name',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Address of the organization',
                        style: Kstyle.textStyle,
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _addressController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'Organization Address',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text('ITN/IEC', style: Kstyle.textStyle),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _innController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'INN',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text('Status of the contract', style: Kstyle.textStyle),
                      const SizedBox(height: 6.0),
                      CustomDropdown(
                        label: 'Status',
                        value: _selectedStatus.toFirestoreString(),
                        items: StatusType.values
                            .map((s) => s.toFirestoreString())
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStatus = StatusTypeExtension.fromString(
                                val,
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text('Cost of the contract', style: Kstyle.textStyle),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _amountController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'Amount',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final contract = ContractEntity(
                              type: _selectedType,
                              fullName: _fullNameController.text,
                              organizationAddress: _addressController.text,
                              inn: _innController.text,
                              status: _selectedStatus,
                              amount: double.parse(_amountController.text),
                              createdAt: DateTime.now(),
                            );

                            _createdContract = contract;

                            context.read<ContractBloc>().add(
                              CreateContractEvent(contract),
                            );
                          }
                        },
                        style: Kstyle.buttonStyle,
                        child: const Text('Create Contract'),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is ContractLoading)
                const Center(child: CircularProgressIndicator.adaptive()),
            ],
          );
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
