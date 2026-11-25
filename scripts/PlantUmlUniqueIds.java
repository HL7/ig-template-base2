import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

// PlantUML numbers ids (ent0001, lnk2) afresh in each diagram, so two diagrams on one page
// share ids. Prefix them with the diagram file name.
// Usage: java PlantUmlUniqueIds.java <svg output dir> <plantuml source dir>...
public class PlantUmlUniqueIds {
  private static final Pattern ID_ATTR = Pattern.compile("(=\"#?)((?:ent|lnk)\\d+\")");

  public static void main(String[] args) throws IOException {
    Path out = Paths.get(args[0]);
    for (int i = 1; i < args.length; i++) {
      Path src = Paths.get(args[i]);
      if (!Files.isDirectory(src)) {
        continue;
      }
      try (Stream<Path> files = Files.walk(src)) {
        for (Path p : (Iterable<Path>) files.filter(f -> f.toString().endsWith(".plantuml"))::iterator) {
          String base = p.getFileName().toString().replaceFirst("\\.plantuml$", "");
          try (Stream<Path> svgs = Files.list(out)) {
            for (Path svg : (Iterable<Path>) svgs.filter(s -> isOutputOf(s, base))::iterator) {
              prefixIds(svg, base.replaceAll("[^A-Za-z0-9_-]", "_"));
            }
          }
        }
      }
    }
  }

  private static boolean isOutputOf(Path svg, String base) {
    String name = svg.getFileName().toString();
    return name.equals(base + ".svg") || name.matches(Pattern.quote(base) + "_\\d{3}\\.svg");
  }

  private static void prefixIds(Path svg, String prefix) throws IOException {
    String text = new String(Files.readAllBytes(svg), StandardCharsets.UTF_8);
    Matcher m = ID_ATTR.matcher(text);
    String result = m.replaceAll("$1" + Matcher.quoteReplacement(prefix) + "-$2");
    if (!result.equals(text)) {
      Files.write(svg, result.getBytes(StandardCharsets.UTF_8));
    }
  }
}
