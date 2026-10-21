class LearningQuestion {
  const LearningQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.sourcePages,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final List<int> sourcePages;

  Map<String, Object?> toJson() => {
        'id': id,
        'prompt': prompt,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'sourcePages': sourcePages,
      };

  factory LearningQuestion.fromJson(Map<String, Object?> json) =>
      LearningQuestion(
        id: json['id']! as String,
        prompt: json['prompt']! as String,
        options: List<String>.from(json['options']! as List),
        correctIndex: json['correctIndex']! as int,
        explanation: json['explanation']! as String,
        sourcePages: List<int>.from(json['sourcePages']! as List),
      );
}

class LessonSection {
  const LessonSection({required this.title, required this.body, this.formula});

  final String title;
  final String body;
  final String? formula;

  Map<String, Object?> toJson() => {
        'title': title,
        'body': body,
        'formula': formula,
      };

  factory LessonSection.fromJson(Map<String, Object?> json) => LessonSection(
        title: json['title']! as String,
        body: json['body']! as String,
        formula: json['formula'] as String?,
      );
}

class LessonContent {
  const LessonContent({
    required this.id,
    required this.order,
    required this.title,
    required this.context,
    required this.objectives,
    required this.sections,
    required this.sourcePages,
    required this.labKind,
    required this.labTitle,
    required this.labActivity,
    required this.labObjective,
    required this.labSteps,
    required this.labObservation,
    required this.evaluation,
  });

  final String id;
  final int order;
  final String title;
  final String context;
  final List<String> objectives;
  final List<LessonSection> sections;
  final List<int> sourcePages;
  final String labKind;
  final String labTitle;
  final String labActivity;
  final String labObjective;
  final List<String> labSteps;
  final String labObservation;
  final List<LearningQuestion> evaluation;

  Map<String, Object?> toJson() => {
        'id': id,
        'order': order,
        'title': title,
        'context': context,
        'objectives': objectives,
        'sections': sections.map((section) => section.toJson()).toList(),
        'sourcePages': sourcePages,
        'labKind': labKind,
        'labTitle': labTitle,
        'labActivity': labActivity,
        'labObjective': labObjective,
        'labSteps': labSteps,
        'labObservation': labObservation,
        'evaluation': evaluation.map((question) => question.toJson()).toList(),
      };

  factory LessonContent.fromJson(Map<String, Object?> json) => LessonContent(
        id: json['id']! as String,
        order: json['order']! as int,
        title: json['title']! as String,
        context: json['context']! as String,
        objectives: List<String>.from(json['objectives']! as List),
        sections: (json['sections']! as List)
            .map((item) => LessonSection.fromJson(Map<String, Object?>.from(item as Map)))
            .toList(),
        sourcePages: List<int>.from(json['sourcePages']! as List),
        labKind: json['labKind']! as String,
        labTitle: json['labTitle']! as String,
        labActivity: json['labActivity']! as String,
        labObjective: json['labObjective']! as String,
        labSteps: List<String>.from(json['labSteps']! as List),
        labObservation: json['labObservation']! as String,
        evaluation: (json['evaluation']! as List)
            .map((item) => LearningQuestion.fromJson(Map<String, Object?>.from(item as Map)))
            .toList(),
      );
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.className,
    required this.username,
  });

  final int id;
  final String fullName;
  final String className;
  final String username;
}

class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.completed,
    required this.score,
    required this.updatedAt,
  });

  final String lessonId;
  final bool completed;
  final int? score;
  final DateTime updatedAt;
}

enum AssessmentStatus { passed, notPassed, pendingRule }

class AssessmentOutcome {
  const AssessmentOutcome({
    required this.correctCount,
    required this.total,
    required this.percent,
    required this.status,
  });

  final int correctCount;
  final int total;
  final int percent;
  final AssessmentStatus status;
}
