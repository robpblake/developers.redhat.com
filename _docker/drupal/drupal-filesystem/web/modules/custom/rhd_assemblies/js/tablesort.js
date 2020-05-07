/**
 * @file
 * Javascript Table Sort Component.
 */

(function ($, Drupal) {

  Drupal.behaviors.rhd_tablesort = {
    attach: function (context, settings) {
      $('.assembly-type-events_collection .rhd-c-table', context).once('rhd_tablesort').each(function () {

        // Set default sort state on date column for first page load.
        // Set sort type to date.
        $(this).find('th#view-field-start-table-column')
          .addClass('pf-m-selected')
          .attr('data-sort-method', 'date')
          .attr('aria-sort', 'ascending');

        // Initialize tablesort.
        table = $(this)[0];
        new Tablesort(table);

        // Update active sort state UI when sorted.
        table.addEventListener('afterSort', function (e) {

          // Reset table headers to inactive state.
          $(this)
            .find('th')
            .removeClass('pf-m-selected');
          $(this)
            .find('th [data-fa-i2svg]')
            .removeClass('fa-long-arrow-alt-down fa-long-arrow-alt-up')
            .addClass('fa-arrows-alt-v');

          // Set current active state and sort direction icons.
          activeSort = $(this).find('th[aria-sort]');
          sortDirection = activeSort.attr('aria-sort');
          console.log('sortDirection');
          console.log(sortDirection);
          icon = activeSort.find('[data-fa-i2svg]');

          activeSort.addClass('pf-m-selected');

          $(icon).removeClass('fa-arrows-alt-v');
          if (sortDirection == 'ascending') {
            $(icon).addClass('fa-long-arrow-alt-down');
          }
          else if (sortDirection == 'descending') {
            $(icon).addClass('fa-long-arrow-alt-up');
          }
          else {
            $(icon).addClass('fa-arrows-alt-v');
          }
        });
      });
    }
  }

})(jQuery, Drupal);
