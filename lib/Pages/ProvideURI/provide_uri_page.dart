import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mealie_mobile/Pages/ProvideURI/provide_uri_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_mobile/colors.dart';

class ProvideURIPage extends StatelessWidget {
  const ProvideURIPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProvideURIPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: const _Card(),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.95,
        child: const Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _MealieBanner(),
              SizedBox(height: 50),
              _MealieLogo(),
              SizedBox(height: 25),
              _CardBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealieBanner extends StatelessWidget {
  const _MealieBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Container(
          color: MealieColors.orange,
          child: const Text(
            "Mealie",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
      ),
    );
  }
}

class _MealieLogo extends StatelessWidget {
  const _MealieLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        Center(
            child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
              color: MealieColors.orange,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset('assets/mealie_logo.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcATop)),
        ))
      ]),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, snapshot) {
      return BlocProvider(
        create: (_) => ProvideURICubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<ProvideURICubit, ProvideURIState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              switch (context.read<ProvideURICubit>().state.status) {
                case ProvideURIStatus.invalid:
                  return const _Invalid();
                case ProvideURIStatus.valid:
                  return const _Valid();
                case ProvideURIStatus.loading:
                  return const _Loading();
                case ProvideURIStatus.ready:
                default:
                  return const _EnterURI();
              }
            }),
      );
    });
  }
}

class _EnterURI extends StatelessWidget {
  const _EnterURI();

  @override
  Widget build(BuildContext context) {
    final TextEditingController tfController = TextEditingController();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Setup",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            clipBehavior: Clip.antiAlias,
            child: TextField(
              controller: tfController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lan),
                hintText: "https://mealie.example.com",
                border: InputBorder.none,
                fillColor: Colors.grey[300],
                // focusColor: MealieColors.orange,
                // prefixIconColor: MealieColors.orange,
                // iconColor: MealieColors.orange,
                // hoverColor: MealieColors.orange,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _SubmitButton(
            tfController: tfController,
            onTap: () => context
                .read<ProvideURICubit>()
                .verifyURI(tfController.value.text),
            text: "Submit",
          )
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    super.key,
    required this.tfController,
    required this.onTap,
    required this.text,
  });

  final TextEditingController tfController;
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 40,
      child: InkWell(
        child: Container(
            decoration: const BoxDecoration(
                color: MealieColors.orange,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )),
        onTap: () => onTap(),
      ),
    );
  }
}

class _Invalid extends StatelessWidget {
  const _Invalid();

  @override
  Widget build(BuildContext context) {
    final TextEditingController tfController = TextEditingController();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Error:",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(context.read<ProvideURICubit>().state.errorMessage.toString()),
          const SizedBox(height: 20),
          _SubmitButton(
            tfController: tfController,
            onTap: () => context.read<ProvideURICubit>().reset(),
            text: "Retry",
          )
        ],
      ),
    );
  }
}

class _Valid extends StatelessWidget {
  const _Valid();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Looks Good!",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Verifying Domain...",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator(
            color: MealieColors.orange,
          ),
        ],
      ),
    );
  }
}
