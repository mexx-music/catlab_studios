import 'package:catlab_studios/features/vision/data/business_brain_story.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';

/// Which portfolio projects have a vision story, and what it is.
///
/// Membership here is the single switch that puts the "Explore the Vision"
/// action on a project's detail sheet. A project without an entry shows
/// exactly what it showed before.
///
/// AI-hint: add a story only where the project's own repository documents a
/// direction worth showing — an invented vision is worse than none.
abstract final class VisionStoriesRepository {
  static final List<VisionStory> all = [businessBrainStory];

  static VisionStory? forProject(String projectId) {
    for (final story in all) {
      if (story.projectId == projectId) return story;
    }
    return null;
  }

  static bool hasStory(String projectId) => forProject(projectId) != null;
}
