import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/service.dart';
import 'auth.dart';

enum EventGroup {
  shortSprints('Short Sprints'),
  longSprints("Long Sprints"),
  middleDistance('Middle Distance'),
  longDistance('Long Distance'),
  jumps('Jumps'),
  hurdles('Hurdles');

  const EventGroup(this.group);
  final String group;
}

final selectedEventGroupProvider =
    StateProvider<EventGroup>((ref) => EventGroup.shortSprints);
final isCoachProvider = StateProvider<bool>((ref) => false);
final firstNameProvider = StateProvider<String>((ref) => "");
final lastNameProvider = StateProvider<String>((ref) => "");
final gradYearProvider = StateProvider<int>((ref) => 0);
final emailProvider = StateProvider<String>((ref) => "");
final passwordProvider = StateProvider<String>((ref) => "");

class Register extends ConsumerWidget {
  Register({super.key});

  Future<void> _register(
      email, password, name, group, gradYear, isCoach) async {
    String uid = await Auth().createUser(email: email, password: password);

    Service().registerUser(uid, name, group, gradYear, isCoach);
    print("Created user with id: $uid");
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController eventGroupController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradYearController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String email = ref.watch(emailProvider);
    final String password = ref.watch(passwordProvider);
    final String firstName = ref.watch(firstNameProvider);
    final String lastName = ref.watch(lastNameProvider);
    final EventGroup group = ref.watch(selectedEventGroupProvider);
    final int gradYear = ref.watch(gradYearProvider);
    final bool isCoach = ref.watch(isCoachProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Register Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              child: Column(
                children: [
                  const Text("First Name"),
                  TextField(
                    controller: firstNameController,
                    keyboardType: TextInputType.text,
                    // onChanged: (value) => {
                    //   ref.read(firstNameProvider.notifier).state = value,
                    // },
                  ),
                  const Text("Last Name"),
                  TextField(
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                    // onChanged: (value) => {
                    //   ref.read(lastNameProvider.notifier).state = value,
                    // },
                  ),
                  const Text("Graduation Year"),
                  TextField(
                    controller: gradYearController,
                    keyboardType: TextInputType.number,
                    // onChanged: (value) => {
                    //   ref.read(gradYearProvider.notifier).state =
                    //       int.tryParse(value) != null
                    //           ? int.parse(value)
                    //           : DateTime.now().year,
                    // },
                  ),
                  const Text("Coach?"),
                  Checkbox(
                      value: ref.watch(isCoachProvider),
                      onChanged: (val) {
                        ref
                            .read(isCoachProvider.notifier)
                            .update((state) => val!);
                      }),
                  const Text("Event Group"),
                  DropdownMenu<EventGroup>(
                    initialSelection: EventGroup.shortSprints,
                    controller: eventGroupController,
                    requestFocusOnTap: true,
                    label: const Text('Event Group'),
                    onSelected: (EventGroup? group) {
                      ref
                          .read(selectedEventGroupProvider.notifier)
                          .update((state) => group!);
                    },
                    dropdownMenuEntries: EventGroup.values
                        .map<DropdownMenuEntry<EventGroup>>((EventGroup group) {
                      return DropdownMenuEntry<EventGroup>(
                        value: group,
                        label: group.name,
                      );
                    }).toList(),
                  ),
                  const Text("Email"),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    // onChanged: (value) => {
                    //   ref.read(emailProvider.notifier).state = value,
                    // },
                  ),
                  const Text("Password"),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    // onChanged: (value) => {
                    //   ref.read(passwordProvider.notifier).state = value,
                    // },
                  ),
                  TextButton(
                      onPressed: () => {
                            _register(
                                emailController.value.text,
                                passwordController.value.text,
                                "${firstNameController.value.text} ${lastNameController.value.text}",
                                eventGroupController.value.text,
                                int.parse(gradYearController.value.text),
                                ref.read(isCoachProvider.notifier).state),
                            Navigator.pop(context)
                          },
                      child: const Text("Create Account"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
