/// One page of a cursor-paginated endpoint.
class CursorPage<T> {
  const CursorPage({
    required this.data,
    required this.nextCursor,
    required this.hasNext,
  });

  /// Parses a page whose items are read by [itemFromJson].
  factory CursorPage.fromJson(
    dynamic json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final page = json as Map<String, dynamic>;
    final data = page['data'] as List<dynamic>;

    return CursorPage(
      data: data
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      nextCursor: page['nextCursor'] as String?,
      hasNext: page['hasNext'] as bool? ?? false,
    );
  }

  final List<T> data;

  final String? nextCursor;

  final bool hasNext;
}
