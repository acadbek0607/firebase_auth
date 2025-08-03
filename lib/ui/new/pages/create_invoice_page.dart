import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
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
  bool _isCreating = false;

  late final VoidCallback _pageListener;

  @override
  void initState() {
    super.initState();
    _pageListener = () {
      if (selectedPageNotifier.value != 6) {
        _formKey.currentState?.reset();
        _serviceNameController.clear();
        _costController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() => _status = null);
      }
    };
    selectedPageNotifier.addListener(_pageListener);
  }

  @override
  void dispose() {
    selectedPageNotifier.removeListener(_pageListener);
    _serviceNameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.black,
        title: Text(tr('new_invoice', context: context)),
        centerTitle: false,
        titleSpacing: 4.0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
      ),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (_isCreating && state.status == InvoiceStatus.loaded) {
            selectedViewNotifier.value = HomeViewType.invoice;
            selectedPageNotifier.value = 0;
            Navigator.pushReplacementNamed(context, '/home');
            _isCreating = false;
          } else if (_isCreating && state.status == InvoiceStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage.toString())),
            );
            _isCreating = false;
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
                      Text(
                        tr('service_name', context: context),
                        style: Kstyle.textStyle,
                      ),
                      SizedBox(height: 6.0),
                      TextFormField(
                        controller: _serviceNameController,
                        decoration: Kstyle.textFieldStyle,
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        tr('cost', context: context),
                        style: Kstyle.textStyle,
                      ),
                      SizedBox(height: 6.0),
                      TextFormField(
                        controller: _costController,
                        decoration: Kstyle.textFieldStyle,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? tr('required', context: context)
                            : null,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        tr('status_of_invoice', context: context),
                        style: Kstyle.textStyle,
                      ),
                      SizedBox(height: 6.0),
                      CustomDropdown(
                        label: '',
                        value: _status?.label(context) ?? '',
                        items: StatusType.values
                            .map((s) => s.label(context))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _status = StatusTypeExtension.fromLabel(
                                val,
                                context,
                              );
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
                            _isCreating = true;
                            context.read<InvoiceBloc>().add(
                              CreateInvoiceEvent(invoice),
                            );
                          }
                        },
                        style: Kstyle.buttonStyle,
                        child: Text(
                          tr('save_invoice', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isCreating && state.status == InvoiceStatus.loading)
                const Center(child: CircularProgressIndicator.adaptive()),
            ],
          );
        },
      ),
    );
  }
}
