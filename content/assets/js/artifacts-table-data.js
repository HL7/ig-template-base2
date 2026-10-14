---
---
{%- comment -%}
  Rendered by Jekyll (the front matter above makes Jekyll run Liquid over this file).
  Emits the artifacts table data for every language of the IG, keyed by language code:
    window.artifactsTableData = { "<lang>": { labels, groupDescriptions, rows }, ... }
  Row fields: p=grouping position, gid=grouping id, g=grouping label, n=title, i=id, t=type,
  u=page url, r=reference, d=description (HTML).
  Consumed by assets/js/artifacts-table.js, which picks the block matching the page's html lang attribute.
{%- endcomment -%}
{%- assign codes = site.data.languages.langs | map: 'code' -%}
{%- if codes == nil or codes.size == 0 -%}
  {%- assign defLang = site.data.languages.defLang | default: 'en' -%}
  {%- assign codes = defLang | split: ',' -%}
{%- endif -%}
window.artifactsTableData = {
{%- for lang in codes %}
{%- assign strings = site.data.stringsBase[lang] | default: site.data.stringsBase.en -%}
{%- assign groupingStrings = site.data.stringsArtifacts[lang] | default: site.data.stringsArtifacts.en %}
  {{ lang | jsonify }}: {
    "labels": {
      "type":        {{ strings['Type']        | default: 'Type'         | jsonify }},
      "category":    {{ strings['Category']    | default: 'Category'     | jsonify }},
      "useGrouping": {{ strings['UseGrouping'] | default: 'Use grouping' | jsonify }},
      "clearAll":      {{ strings['ClearAll']           | default: 'Clear all'             | jsonify }},
      "linkToSection": {{ strings['LinkToThisSection'] | default: 'Link to this section' | jsonify }}
    },
    "groupDescriptions": {
{%- assign seenGids = "|" -%}
{%- assign firstDesc = true -%}
{%- for r in site.data.artifactsTable -%}
{%- assign marker = r.groupingId | prepend: "|" | append: "|" -%}
{%- unless seenGids contains marker -%}
{%- assign seenGids = seenGids | append: r.groupingId | append: "|" -%}
{%- assign descKey = r.groupingName | append: 'Desc' -%}
{%- assign descMd = groupingStrings[descKey] -%}
{%- if descMd == nil or descMd == '' -%}
  {%- assign descMd = r.groupingDescription[lang] | default: r.groupingDescription.src -%}
{%- endif -%}
{%- if descMd and descMd != '' %}
      {% unless firstDesc %},{% endunless %}{{ r.groupingId | jsonify }}: {{ descMd | markdownify | jsonify }}
{%- assign firstDesc = false -%}
{%- endif -%}
{%- endunless -%}
{%- endfor %}
    },
    "rows": [
{%- for r in site.data.artifactsTable -%}
{%- assign titleSrc = r.title | default: r.name -%}
{%- assign ttl = titleSrc[lang] | default: titleSrc.src -%}
{%- assign rid = r.id | default: '' -%}
{%- if rid == '' -%}{%- assign rid = r.ref | split: "/" | last -%}{%- endif -%}
{%- assign descRaw = r.description[lang] | default: r.description.src | default: '' -%}
{%- assign desc = descRaw | markdownify | strip -%}
{%- assign gKey = r.groupingName | append: 'Name' -%}
{%- assign groupLabel = groupingStrings[gKey] | default: r.groupingName %}
      { "p":{{ r.groupingPos }}, "gid":{{ r.groupingId | jsonify }}, "g":{{ groupLabel | jsonify }}, "n":{{ ttl | jsonify }}, "i":{{ rid | jsonify }}, "t":{{ r.type | jsonify }}, "u":{{ r.url | jsonify }}, "r":{{ r.ref | jsonify }}, "d":{{ desc | jsonify }} }{%- unless forloop.last -%},{%- endunless %}
{%- endfor %}
    ]
  }{% unless forloop.last %},{% endunless %}
{%- endfor %}
};
