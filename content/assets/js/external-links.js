// Open external links in a new tab, matching the external-link detection used in ADHA.css
jQuery(function ($) {
  $('a[href^="http://"]:not([no-external="true"]), a[href^="https://"]:not([href^="https://build.fhir.org"]):not([no-external="true"])')
    .attr('target', '_blank')
    .attr('rel', 'noopener noreferrer');
});
