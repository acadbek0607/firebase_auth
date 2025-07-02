import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/ui/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _costController = TextEditingController();
  StatusType? _status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Text(
                'Service name',
                style: Kstyle.textStyle.copyWith(color: Color(0xFFE7E7E7)),
              ),
              SizedBox(height: 6.0),
              TextFormField(
                controller: _serviceNameController,
                decoration: Kstyle.textFieldStyle,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20.0),
              Text(
                'Cost',
                style: Kstyle.textStyle.copyWith(color: Color(0xFFE7E7E7)),
              ),
              SizedBox(height: 6.0),
              TextFormField(
                controller: _costController,
                decoration: Kstyle.textFieldStyle,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20.0),
              Text(
                'Status of invoice',
                style: Kstyle.textStyle.copyWith(color: Color(0xFFE7E7E7)),
              ),
              SizedBox(height: 6.0),
              CustomDropdown(
                label: 'Status',
                value: _status?.label ?? '',
                items: StatusType.values.map((s) => s.label).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _status = StatusTypeExtension.fromLabel(val);
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final invoice = InvoiceEntity(
                      serviceName: _serviceNameController.text,
                      cost: double.parse(_costController.text),
                      status: _status!,
                      createdAt: DateTime.now(),
                    );
                    context.read<InvoiceBloc>().add(
                      CreateInvoiceEvent(invoice),
                    );
                    Navigator.pop(context);
                  }
                },
                style: Kstyle.buttonStyle,
                child: const Text('Save Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
