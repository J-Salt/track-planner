import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
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
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Register Page",
        context: context,
        trailingActions: [
          IconButton(
              onPressed: () {
                _register(
                    emailController.value.text,
                    passwordController.value.text,
                    "${firstNameController.value.text} ${lastNameController.value.text}",
                    eventGroupController.value.text,
                    int.parse(gradYearController.value.text),
                    ref.read(isCoachProvider.notifier).state);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: "First Name",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: "Last Name",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: gradYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Graduation Year",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("Coach?"),
                            Checkbox(
                                value: ref.watch(isCoachProvider),
                                onChanged: (val) {
                                  ref
                                      .read(isCoachProvider.notifier)
                                      .update((state) => val!);
                                }),
                          ],
                        ),
                        DropdownMenu<EventGroup>(
                          initialSelection: EventGroup.shortSprints,
                          controller: eventGroupController,
                          requestFocusOnTap: true,
                          enableSearch: false,
                          label: const Text('Event Group'),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          onSelected: (EventGroup? group) {
                            ref
                                .read(selectedEventGroupProvider.notifier)
                                .update((state) => group!);
                          },
                          dropdownMenuEntries: EventGroup.values
                              .map<DropdownMenuEntry<EventGroup>>(
                                  (EventGroup group) {
                            return DropdownMenuEntry<EventGroup>(
                              value: group,
                              label: group.group,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
