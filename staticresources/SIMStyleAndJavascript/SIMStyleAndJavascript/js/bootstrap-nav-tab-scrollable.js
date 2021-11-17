// Add Horizontal Tabs to jquery
(function ($){

  $.fn.horizontalTabs = function() {
    // Variable creation
    var $elem = $(this),
    widthOfReducedList = $elem.find('.ul-wrapper').width(),
    widthOfList = 0,
    currentPos = 0,
    adjustScroll = function () {
      $elem.find('.ul-wrapper li').each(function(index, item) {
        widthOfList += $(item).width();
      });

      widthAvailale = $elem.width();

      if (widthOfList > widthAvailale) {
        $elem.find('.scroller').show();
        updateArrowStyle(currentPos);
        widthOfReducedList = $elem.find('.ul-wrapper').width();
      } else {
        $elem.find('.scroller').hide();
      }
    },
    scrollLeft = function () {
      $elem.find('.ul-wrapper').animate({
          scrollLeft: currentPos - widthOfReducedList
      }, 500);
      
      if (currentPos - widthOfReducedList > 0) {
        currentPos -= widthOfReducedList;    
      } else {
        currentPos = 0;
      }
    },
    scrollRight = function () {
      $elem.find('.ul-wrapper').animate({
        scrollLeft: currentPos + widthOfReducedList
      }, 500);

      if ( (currentPos + widthOfReducedList) < (widthOfList - widthOfReducedList)) {
        currentPos += widthOfReducedList;
      } else {
        currentPos = (widthOfList - widthOfReducedList);
      }
    },
    manualScroll = function () {
      currentPos = $elem.find('.ul-wrapper').scrollLeft();
      
      updateArrowStyle(currentPos);
    },
    updateArrowStyle = function (position) {
      if (position >= (widthOfList - widthOfReducedList)) {
        $elem.find('.scroller-right').addClass('disabledObj');
      } else {
        $elem.find('.scroller-right').removeClass('disabledObj');
      };

      if (position <= 0) {
        $elem.find('.scroller-left').addClass('disabledObj');
      } else {
        $elem.find('.scroller-left').removeClass('disabledObj');
      };
    };

    // Event binding
    $(window).resize( function () {
      adjustScroll();
    });

    $elem.find('.scroller-left').on('click.horizontalTabs', function (){
      scrollLeft();
    });

    $elem.find('.scroller-right').on('click.horizontalTabs', function (){
      scrollRight();
    });

    $elem.find('.ul-wrapper').scroll( function (){
      manualScroll();
      
    });

    // Initial Call
    adjustScroll();

    return this;
  }

}(window.jQuery));
