import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  int _selectedIndex = 0;
  double _iconSize = 24.0; // Default size of icons
  Color _iconColor = Colors.purple.shade300; // Default icon color
  
  // Multi-selection state
  bool _isMultiSelectMode = false;
  Set<String> _selectedTaskIds = {};
  
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addTask() {
    if (taskController.text.isEmpty) return;
    final newTask = Task(
      title: taskController.text,
      startTime: DateTime.now(),
    );
    setState(() {
      tasks.add(newTask);
    });

    // Add task to Firestore
    _firestore.collection('tasks').add({
      'title': newTask.title,
      'startTime': newTask.startTime,
      'isCompleted': newTask.isCompleted,
      'endTime': newTask.endTime,
    });

    taskController.clear();
  }

  void toggleTaskStatus(Task task, String documentId) {
    setState(() {
      // If in multi-select mode, toggle selection instead of status
      if (_isMultiSelectMode) {
        _toggleTaskSelection(documentId);
        return;
      }
      
      // Normal mode - toggle completion status
      bool newCompletionStatus = !task.isCompleted;
      DateTime? newEndTime = task.endTime;
      if (newCompletionStatus && task.endTime == null) {
        newEndTime = DateTime.now();
      }
      
      // Update Firestore document
      _firestore.collection('tasks').doc(documentId).update({
        'isCompleted': newCompletionStatus,
        'endTime': newEndTime,
      });
    });
  }
  
  void _toggleTaskSelection(String documentId) {
    setState(() {
      if (_selectedTaskIds.contains(documentId)) {
        _selectedTaskIds.remove(documentId);
      } else {
        _selectedTaskIds.add(documentId);
      }
      
      // Exit multi-select mode if no tasks are selected
      if (_selectedTaskIds.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }
  
  void _enterMultiSelectMode(String initialDocumentId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedTaskIds = {initialDocumentId};
    });
  }
  
  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedTaskIds.clear();
    });
  }
  
  void _deleteSelectedTasks() {
    // Delete selected tasks from Firestore
    for (String docId in _selectedTaskIds) {
      _firestore.collection('tasks').doc(docId).delete();
    }
    // Exit multi-select mode after deletion
    _exitMultiSelectMode();
  }
  
  void _markSelectedTasksComplete() {
    // Mark all selected tasks as complete
    for (String docId in _selectedTaskIds) {
      _firestore.collection('tasks').doc(docId).update({
        'isCompleted': true,
        'endTime': DateTime.now(),
      });
    }
    // Exit multi-select mode after updating
    _exitMultiSelectMode();
  }

  String formatTime(DateTime startTime, DateTime? endTime) {
    final duration =
        endTime != null ? endTime.difference(startTime) : Duration.zero;
    return '${duration.inMinutes} min ${duration.inSeconds % 60} sec';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the respective page depending on the selected index
    if (index == 0) {
      // Home page logic here
    } else if (index == 1) {
      // Settings page logic here
    } else if (index == 2) {
      // Profile page logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade300,
        title: _isMultiSelectMode 
          ? Text("${_selectedTaskIds.length} selected")
          : const Text("To-Do List"),
        centerTitle: true,
        actions: _isMultiSelectMode ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSelectedTasks,
          ),
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: _markSelectedTasksComplete,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _exitMultiSelectMode,
          ),
        ] : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Task Input Field (hide when in selection mode)
              if (!_isMultiSelectMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Task Input Field
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            labelText: "Enter new task",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Add Task Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade300,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: addTask,
                        child: const Text("Add Task",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),

              // Display Task List
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('tasks').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final taskDocs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: taskDocs.length,
                      itemBuilder: (context, index) {
                        final doc = taskDocs[index];
                        final docId = doc.id;
                        final task = Task.fromFirestore(doc);
                        final isSelected = _selectedTaskIds.contains(docId);
                        
                        return Card(
                          color: isSelected ? Colors.purple.shade100 : Colors.white,
                          elevation: 5,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () => toggleTaskStatus(task, docId),
                            onLongPress: () => _enterMultiSelectMode(docId),
                            leading: _isMultiSelectMode
                              ? Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.purple.shade500,
                                )
                              : Icon(
                                  task.isCompleted
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: task.isCompleted
                                      ? Colors.green
                                      : Colors.purple.shade300,
                                ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: task.isCompleted && !_isMultiSelectMode
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              task.isCompleted
                                  ? "Completed in: ${formatTime(task.startTime, task.endTime)}"
                                  : "In progress",
                              style: TextStyle(
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.purple.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _iconSize = 30.0; // Increase icon size
                  _iconColor = Colors.purple.shade500; // Change color
                });
              },
              onExit: (_) {
                setState(() {
                  _iconSize = 24.0; // Reset icon size
                  _iconColor = Colors.purple.shade300; // Reset color
                });
              },
              child: Icon(
                Icons.home,
                size: _iconSize,
                color: _iconColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _iconSize = 30.0; // Increase icon size
                  _iconColor = Colors.purple.shade500; // Change color
                });
              },
              onExit: (_) {
                setState(() {
                  _iconSize = 24.0; // Reset icon size
                  _iconColor = Colors.purple.shade300; // Reset color
                });
              },
              child: Icon(
                Icons.settings,
                size: _iconSize,
                color: _iconColor,
              ),
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _iconSize = 30.0; // Increase icon size
                  _iconColor = Colors.purple.shade500; // Change color
                });
              },
              onExit: (_) {
                setState(() {
                  _iconSize = 24.0; // Reset icon size
                  _iconColor = Colors.purple.shade300; // Reset color
                });
              },
              child: Icon(
                Icons.person,
                size: _iconSize,
                color: _iconColor,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Task {
  String title;
  DateTime startTime;
  DateTime? endTime;
  bool isCompleted;

  Task({
    required this.title,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
  });
  
  // Constructor to create Task from Firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      title: data['title'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      isCompleted: data['isCompleted'],
    );
  }
}