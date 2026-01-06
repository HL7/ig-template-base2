$(function () {

  const $table = $("table.fhir-conformance-list");

  /* Exclude header row (0) and filter row (1) */
  const $rows = $table.find("tr").slice(2);

  function normalize(text) {
    return text.replace(/\s+/g, "").toLowerCase();
  }

  function applyFilters() {

    const idFilter   = normalize($("input[name='filterid']").val() || "");
    const ruleFilter = normalize($("input[name='filterrule']").val() || "");

    const expectations = $("input[name^='expect']:checked")
      .map(function () {
        return $(this)[0].nextSibling.nodeValue.trim();
      })
      .get();

    const actors = $("input[name^='actor']:checked")
      .map(function () { return $(this).next("a").text().trim(); })
      .get();

    const categories = $("input[name^='category']:checked")
      .map(function () {
        return this.nextSibling.nodeValue.trim();
      })
      .get();

    const conditional = $("input[name='conditionFilter']:checked").val();

    $rows.each(function () {

      const $cells = $(this).children("th,td");

      const idText          = normalize($cells.eq(0).text());
      const expectationText = $cells.eq(1).text().replace(/\s+/g, " ").trim();
      const conditionalText = $cells.eq(2).text();
      const actorText       = $cells.eq(3).text();
      const categoryText    = $cells.eq(4).text();
      const ruleText        = normalize($cells.eq(5).text());

      const hasConditionalX = /\bX\b/.test(conditionalText);

      let visible = true;

      /* Id filter */
      if (idFilter && !idText.includes(idFilter)) {
        visible = false;
      }

      /* Expectation filter */
      if (expectations.length && !expectations.includes(expectationText)) {
        visible = false;
      }

      /* Conditional filter */
      if (conditional === "true" && !hasConditionalX) {
        visible = false;
      }
      if (conditional === "false" && hasConditionalX) {
        visible = false;
      }

      /* Actor filter */
      if (actors.length && !actors.some(a => actorText.includes(a))) {
        visible = false;
      }

      /* Category filter */
      if (categories.length && !categories.some(c => categoryText.includes(c))) {
        visible = false;
      }

      /* Rule filter */
      if (ruleFilter && !ruleText.includes(ruleFilter)) {
        visible = false;
      }

      $(this).toggle(visible);
    });
  }

  /* Apply filtering on any control change */
  $table.on("change keyup", "input", applyFilters);

  /* Clear Filters */
  $("input[name='clearFilters']").on("click", function () {
    $table.find("input[type='text']").val("");
    $table.find("input[type='checkbox']").prop("checked", false);
    $("#conditionAny").prop("checked", true);
    $rows.show();
  });

  /* Default state */
  $("#conditionAny").prop("checked", true);

});
