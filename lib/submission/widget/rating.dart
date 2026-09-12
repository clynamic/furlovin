import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

extension RatingColour on Ratings {
  Color of(SubmissionRating rating) => switch (rating) {
    SubmissionRating.general => general,
    SubmissionRating.mature => mature,
    SubmissionRating.adult => adult,
  };
}
