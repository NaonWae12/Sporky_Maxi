/// Helper utility to normalize raw string (potentially containing markdown or raw linebreaks)
/// into properly formatted HTML markup suitable for CmsHtmlContent widget.
class HtmlNormalization {
  static String normalize(String raw, {bool orderedList = false}) {
    var value = raw.trim();
    if (value.isEmpty) {
      return '<p>Data belum tersedia.</p>';
    }

    // Convert markdown bold (**text** or __text__) to HTML <strong>
    value = value.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) {
      return '<strong>${match.group(1)}</strong>';
    });
    value = value.replaceAllMapped(RegExp(r'__(.*?)__'), (match) {
      return '<strong>${match.group(1)}</strong>';
    });

    // Convert markdown italic (*text* or _text_) to HTML <em>
    value = value.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) {
      return '<em>${match.group(1)}</em>';
    });
    value = value.replaceAllMapped(RegExp(r'_(.*?)_'), (match) {
      return '<em>${match.group(1)}</em>';
    });

    final hasHtmlTags = value.contains(RegExp(r'<[^>]+>'));
    if (hasHtmlTags) return value;

    final lines = value
        .split(RegExp(r'\\n|\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (orderedList && lines.length > 1) {
      final StringBuffer buffer = StringBuffer();
      bool inList = false;

      for (final line in lines) {
        final match = RegExp(r'^\d+[\.)]\s*(.*)$').firstMatch(line);
        if (match != null) {
          if (!inList) {
            buffer.write('<ol>');
            inList = true;
          }
          final content = match.group(1) ?? '';
          buffer.write('<li>$content</li>');
        } else {
          if (inList) {
            buffer.write('</ol>');
            inList = false;
          }
          if (line.endsWith(':')) {
            buffer.write('<p><strong>$line</strong></p>');
          } else {
            buffer.write('<p>$line</p>');
          }
        }
      }

      if (inList) {
        buffer.write('</ol>');
      }
      return buffer.toString();
    }

    return '<p>${lines.join('<br/>')}</p>';
  }
}
