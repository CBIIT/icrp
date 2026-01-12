(function ($, Drupal, once) {
  Drupal.behaviors.viewsBootstrapCarouselManual = {
    attach: function (context) {

      $(once('views-bs-carousel', '.view .carousel', context)).each(function () {
        const $carousel = $(this);
        const $inner = $carousel.find('.carousel-inner');

        // 🔒 HARD STOP Bootstrap carousel JS triggers
        $carousel
          .removeAttr('data-ride')
          .removeAttr('data-interval')
          .removeAttr('data-pause');
        $carousel.removeData('bs.carousel');
        $carousel.off('.bs.carousel');
        // Normalize items (Views outputs BS4/5 markup)
        const $items = $inner.find('.carousel-item').addClass('item');
        if ($items.length < 2) {
          return;
        }

        // Determine starting index
        let index = $items.filter('.active').index();
        if (index < 0) {
          index = 0;
        }

        // Initial visibility state
        $items.hide().removeClass('active');
        $items.eq(index).show().addClass('active');

        const $indicators = $carousel.find('.carousel-indicators li');

        function showSlide(newIndex) {
          if (newIndex === index) return;

          $items.eq(index).removeClass('active').hide();
          index = newIndex;
          $items.eq(index).addClass('active').show();

          // Sync indicators
          $indicators.removeClass('active');
          $indicators.eq(index).addClass('active');
        }

        // ▶ NEXT arrow
        $carousel.find('.carousel-control-next')
          .off('click')
          .on('click', function (e) {
            e.preventDefault();
            e.stopImmediatePropagation();
            showSlide((index + 1) % $items.length);
          });

        // ◀ PREV arrow
        $carousel.find('.carousel-control-prev')
          .off('click')
          .on('click', function (e) {
            e.preventDefault();
            e.stopImmediatePropagation();
            showSlide((index - 1 + $items.length) % $items.length);
          });

        // ● Indicators (dots)
        $indicators
          .off('click')
          .on('click', function (e) {
            e.preventDefault();
            e.stopImmediatePropagation();
            showSlide($(this).index());
          });

        // ⏱ AUTO-SLIDE (SAFE)
        let autoTimer = setInterval(function () {
          showSlide((index + 1) % $items.length);
        }, 5000);

        // ⏸ Pause on hover (matches old behavior)
        $carousel
          .on('mouseenter', function () {
            clearInterval(autoTimer);
          })
          .on('mouseleave', function () {
            autoTimer = setInterval(function () {
              showSlide((index + 1) % $items.length);
            }, 5000);
          });

      });

    }
  };
})(jQuery, Drupal, once);

