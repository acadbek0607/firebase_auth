import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/detail/pages/contract_detail_page.dart';
import 'package:fire_auth/ui/new/pages/create_contract_page.dart';
import 'package:fire_auth/ui/new/pages/create_invoice_page.dart';
import 'package:fire_auth/ui/new/pages/new_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

// Auth Feature
import 'package:fire_auth/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:fire_auth/features/auth/data/repos/auth_repo_impl.dart';
import 'package:fire_auth/features/auth/domain/usecases/usecases.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/auth/presentation/pages/sign_in_page.dart';
import 'package:fire_auth/features/auth/presentation/pages/sign_up_page.dart';
import 'package:fire_auth/features/auth/presentation/pages/welcome_page.dart';

// Contract Feature
import 'package:fire_auth/features/contract/data/datasources/contract_remote_data_source_impl.dart';
import 'package:fire_auth/features/contract/data/repos/contract_repo_impl.dart';
import 'package:fire_auth/features/contract/domain/usecases/contract_usecases.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';

// Invoice Feature
import 'package:fire_auth/features/invoice/data/datasources/invoice_remote_data_source_impl.dart';
import 'package:fire_auth/features/invoice/data/repos/invoice_repo_impl.dart';
import 'package:fire_auth/features/invoice/domain/usecases/invoice_usecases.dart';
import 'package:fire_auth/features/invoice/presentation/bloc/invoice_bloc.dart';

// UI
import 'package:fire_auth/ui/home/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Auth
  final authRepo = AuthRepoImpl(AuthRemoteDataSourceImpl(firebaseAuth));

  // Contract
  final contractRepo = ContractRepositoryImpl(
    ContractRemoteDataSourceImpl(firestore),
  );

  // Invoice
  final invoiceRepo = InvoiceRepositoryImpl(
    InvoiceRemoteDataSourceImpl(firestore),
  );

  runApp(
    MyApp(
      authRepo: authRepo,
      contractRepo: contractRepo,
      invoiceRepo: invoiceRepo,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepoImpl authRepo;
  final ContractRepositoryImpl contractRepo;
  final InvoiceRepositoryImpl invoiceRepo;

  const MyApp({
    super.key,
    required this.authRepo,
    required this.contractRepo,
    required this.invoiceRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signInWithEmail: SignInWithEmail(authRepo),
            signUpWithEmail: SignUpWithEmail(authRepo),
            signOut: SignOut(authRepo),
            getCurrentUser: GetCurrentUser(authRepo),
          )..add(AuthCheckRequested()),
        ),
        BlocProvider<ContractBloc>(
          create: (_) => ContractBloc(
            createContract: CreateContract(contractRepo),
            updateContract: UpdateContract(contractRepo),
            deleteContract: DeleteContract(contractRepo),
            getContracts: GetContracts(contractRepo),
          )..add(LoadContracts()),
        ),
        BlocProvider<InvoiceBloc>(
          create: (_) => InvoiceBloc(
            createInvoice: CreateInvoice(invoiceRepo),
            updateInvoice: UpdateInvoice(invoiceRepo),
            deleteInvoice: DeleteInvoice(invoiceRepo),
            getInvoices: GetInvoices(invoiceRepo),
          )..add(LoadInvoices()),
        ),
      ],
      child: MaterialApp(
        title: 'iBilling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInPage(),
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/welcome': (context) => const WelcomePage(),
          '/home': (context) => const HomePage(),
          '/new': (context) => const NewPage(),
          '/create_contract': (context) => const CreateContractPage(),
          '/create_invoice': (context) => const CreateInvoicePage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/contract_detail':
              final args = settings.arguments as Map<String, dynamic>;
              final contract = args['contract'] as ContractEntity;
              final allContracts = args['allContracts'] as List<ContractEntity>;
              return MaterialPageRoute(
                builder: (context) => ContractDetailPage(
                  contract: contract,
                  allContracts:
                      allContracts, // Can be fetched or passed if needed
                ),
              );
          }
          return null;
        },
      ),
    );
  }
}
