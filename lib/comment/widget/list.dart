import 'package:furlovin/client/client.dart';
import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/user/user.dart';
import 'package:material_ui/material_ui.dart';

const int commentWidthStep = 3;
const double commentIndent = 16;
const int commentDepthLimit = 5;
const double commentAvatarSize = 30;
const double commentElbowGap = 3;
const double commentElbowArm = 9;
const double commentRailAlpha = 0.7;
const double commentBreakAlpha = 0.5;

typedef CommentRow = ({Comment comment, int depth});

int commentDepth(Comment comment) {
  final int? width = comment.width;
  if (width == null || width >= 100) return 0;
  return ((100 - width) ~/ commentWidthStep).clamp(0, commentDepthLimit);
}

List<CommentRow> threadComments(List<Comment> comments) => [
  for (final Comment comment in comments)
    (comment: comment, depth: commentDepth(comment)),
];

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.row});

  final CommentRow row;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Comment comment = row.comment;
    return CustomPaint(
      painter: CommentElbow(
        depth: row.depth,
        color: theme.colorScheme.outlineVariant.withValues(
          alpha: commentRailAlpha,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: row.depth * commentIndent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Poster(
              name: comment.author,
              child: Avatar(
                url: comment.authorAvatar,
                name: comment.authorName ?? comment.author,
                size: commentAvatarSize,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        child: Poster(
                          name: comment.author,
                          child: Text(
                            comment.authorName ?? comment.author ?? 'unknown',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (comment.posted case final DateTime posted)
                        Text(
                          describeWhen(posted),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (comment.body case final String body)
                    MarkupBody(
                      markup: body,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentElbow extends CustomPainter {
  const CommentElbow({required this.depth, required this.color});

  final int depth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (depth == 0) return;
    final Paint brush = Paint()
      ..color = color
      ..strokeWidth = 1;
    const double turn = commentAvatarSize / 2;
    final double x = depth * commentIndent - commentElbowArm - commentElbowGap;
    canvas.drawLine(Offset(x, turn - commentElbowArm), Offset(x, turn), brush);
    canvas.drawLine(Offset(x, turn), Offset(x + commentElbowArm, turn), brush);
  }

  @override
  bool shouldRepaint(CommentElbow old) =>
      old.depth != depth || old.color != color;
}

class CommentBreak extends StatelessWidget {
  const CommentBreak({super.key, required this.below});

  final CommentRow below;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (below.depth > 0) return const SizedBox(height: 16);
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 18, 8, 18),
      child: ColoredBox(
        color: theme.colorScheme.outlineVariant.withValues(
          alpha: commentBreakAlpha,
        ),
        child: const SizedBox(height: 1, width: double.infinity),
      ),
    );
  }
}
