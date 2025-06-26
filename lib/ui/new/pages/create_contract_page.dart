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
            Navigator.pushReplacementNamed(
              context,
              '/contract_detail',
              arguments: _createdContract,
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
                      SizedBox(height: 20.0),
                      Text('Entity', style: Kstyle.textStyle),
                      SizedBox(height: 6.0),
                      CustomDropdown(
                        label: 'Entity Type',
                        value: _selectedType,
                        items: ['personal', 'legal'],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedType = val);
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text('''Fisher's full name''', style: Kstyle.textStyle),
                      SizedBox(height: 6.0),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'Full name',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Address of the organization',
                        style: Kstyle.textStyle,
                      ),
                      SizedBox(height: 6.0),
                      TextFormField(
                        controller: _addressController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'Organization Address',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.0),
                      Text('ITN/IEC', style: Kstyle.textStyle),
                      SizedBox(height: 6.0),
                      TextFormField(
                        controller: _innController,
                        decoration: Kstyle.textFieldStyle.copyWith(
                          labelText: 'INN',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.0),
                      Text('Status of the contract', style: Kstyle.textStyle),
                      SizedBox(height: 6.0),
                      CustomDropdown(
                        label: 'Status',
                        value: _selectedStatus.toFirestoreString(),
                        items: StatusType.values
                            .map((s) => s.toFirestoreString())
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(
                              () => _selectedStatus =
                                  StatusTypeExtension.fromString(val),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 16.0),
                      Text('Cost of the contract', style: Kstyle.textStyle),
                      SizedBox(height: 6.0),
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
                        onPressed: () async {
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

                            context.read<ContractBloc>().add(
                              CreateContractEvent(contract),
                            );

                            // Wait briefly for Firestore to update
                            await Future.delayed(
                              const Duration(milliseconds: 600),
                            );

                            // Manually reload the contracts from Firestore
                            context.read<ContractBloc>().add(LoadContracts());

                            // Navigate after another short delay to ensure contracts are loaded
                            await Future.delayed(
                              const Duration(milliseconds: 600),
                            );

                            // Read latest contracts from Bloc state
                            final currentState = context
                                .read<ContractBloc>()
                                .state;
                            if (currentState is ContractLoaded) {
                              final contracts = currentState.contracts;

                              // Find the most recently created contract
                              final newContract = contracts.firstWhere(
                                (c) =>
                                    c.fullName == contract.fullName &&
                                    c.inn == contract.inn &&
                                    c.createdAt.isAtSameMomentAs(
                                      contract.createdAt,
                                    ),
                                orElse: () => contracts.last,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ContractDetailPage(
                                    contract: newContract,
                                    allContracts: contracts,
                                  ),
                                ),
                              );
                            }
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
