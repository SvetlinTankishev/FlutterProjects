import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/components/exercise_tile.dart';
import 'package:workout_tracker_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    print("Checking off exercise: $exerciseName for workout: $workoutName");
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: exerciseNameController,
            ),
            TextField(
              controller: weightController,
            ),
            TextField(
              controller: repsController,
            ),
            TextField(
              controller: setsController,
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    print("Adding new exercise: $newExerciseName");
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExcercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExcercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => Dismissible(
            key: ValueKey(value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name),
            background: _buildDismissibleBackground(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '${value.getRelevantWorkout(widget.workoutName).exercises[index].name} deleted')));
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises
                    .removeAt(index);
              });
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ExerciseTile(
                exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                weight: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .weight,
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckBoxChanged: (val) => onCheckBoxChanged(
                  widget.workoutName,
                  value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(5.0)),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(' Delete',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
