$(function () {

  const $table = $("table.fhir-conformance-list");

  /* Exclude header row (0) and filter row (1) */
  const $rows = $table.find("tr").slice(2);

  function normalize(text) {
    return text.replace(/\s+/g, " ").trim();
  }

  function applyFilters() {

    const idFilter   = normalize($("input[name='filterid']").val() || "").toLowerCase();
    const ruleFilter = normalize($("input[name='filterrule']").val() || "").toLowerCase();

    /* Selected expectations (exact tokens) */
    const expectations = $("input[name^='expect']:checked")
      .map(function () {
        return normalize(this.nextSibling.nodeValue);
      })
      .get();

    /* Selected actors */
    const actors = $("input[name^='actor']:checked")
      .map(function () {
        return $(this).next("a").text().trim();
      })
      .get();

    /* Selected categories */
    const categories = $("input[name^='category']:checked")
      .map(function () {
        return normalize(this.nextSibling.nodeValue);
      })
      .get();

    const conditional = $("input[name='conditionFilter']:checked").val();

    $rows.each(function () {

      const $cells = $(this).children("th,td");

      const idText   = $cells.eq(0).text().toLowerCase();
      const ruleText = $cells.eq(5).text().toLowerCase();
      const condText = $cells.eq(2).text();

      const hasConditionalX = /\bX\b/.test(condText);

      /* Extract expectation tokens (split on <br/>) */
      const rowExpectations = $cells.eq(1)
        .html()
        .split(/<br\s*\/?>/i)
        .map(e => normalize($("<div>").html(e).text()))
        .filter(Boolean);

      /* Extract actors (exact anchor match) */
      const rowActors = $cells.eq(3).find("a")
        .map(function () {
          return $(this).text().trim();
        })
        .get();

      /* Extract categories (exact tokens) */
      const rowCategories = $cells.eq(4)
        .text()
        .split(/\s*[\r\n]+\s*/)
        .map(c => c.trim())
        .filter(Boolean);

      let visible = true;

      /* Id filter */
      if (idFilter && !idText.includes(idFilter)) {
        visible = false;
      }

      /* Expectation filter — exact token match */
      if (expectations.length &&
          !expectations.some(e => rowExpectations.includes(e))) {
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
      if (actors.length &&
          !actors.some(a => rowActors.includes(a))) {
        visible = false;
      }

      /* Category filter */
      if (categories.length &&
          !categories.some(c => rowCategories.includes(c))) {
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
