/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.

 */
 //----MAP PLOTTER APPLICATION :: Custom Javascript for UI functionality & Events----------//

    /*$('.menu-item').mouseover(function(){
        $('.menu-item').css({'background-color':'#333','transition':'background-color 0.6s ease'});
        $(this).css({'background-color':'#cc3300','transition':'background-color 0.6s ease'});
    });*/
//----------Initially hide second section i.e. list view
   $('.direction-panel-wrapper').hide();
    
    $('.app-button').click(function(){
        $('.app-button').removeClass('button-active').addClass('button-deactive');//.css({'background-color':'#31353d','transition':'background-color 0.6s ease'});
        //$(this).css({'background-color':'#cc3300','transition':'background-color 0.6s ease'});
        $(this).addClass('button-active');
    });
	 $(document).ready(function(){document.body.addEventListener('touchmove', function(event) {
    event.preventDefault();
});}
	

    $('.map-view').click(function(){
        $('.map-viewer').show();
        $('.list-viewer').hide();
        //show map drawing toolbar
        $('.map-selection-tool-panel').show();
        //Show Top Bar Search in List View Panel
        $('.search-container').show();
        //Hide DIrection inner window
        $('.direction-panel').show();
        //$('.panel-container').show();
//------------Inner direction window data point scroller-----------//
     /*$('#inner-window-scroll').listslider({
	        left_label: '<i class="fa fa-caret-left"></i>',
	        right_label: '<i class="fa fa-caret-right"></i>'
	    }); */ 
    });

    $('.list-view').click(function(){
        $('.list-viewer').show();
        $('.map-viewer').hide();
         //hide map drawing toolbar
        $('.map-selection-tool-panel').hide();
        //Hide Top Bar Search in List View Panel
        $('.search-container').hide();
        //Hide DIrection inner window
        $('.direction-panel').hide();
        $('.direction-panel-wrapper').hide();
        //Liste View :: Right Section
	    
    });
    /*$('#scroll-data').listslider({
	        left_label: '<i class="fa fa-caret-left"></i>',
	        right_label: '<i class="fa fa-caret-right"></i>'
	    });*/
//-----------POPUP MODAL :: Horizontally Scrolled Countries Tab Navigation icons //
               /* $('.tab-list').listslider({
                    left_label: '<i class="fa fa-caret-left"></i>',
                    right_label: '<i class="fa fa-caret-right"></i>'
                }); */   
//------------Inner direction window minimizer icon click event to slide up and down -----------//
	 //$('#panel-1,#panel-2,#panel-3').css({'display':'none'});
	 $(document).on('click','.minimizer',function(){
			//$('.tab').removeClass('tab-active');
            //$('#panel-1,#panel-2,#panel-3').css({'display':'none'});
            //$('.direction-panel-wrapper').slideToggle('2000', "easeInOutSine");
		});
	
//-----------Inner direction window tab click events--------//
   $('.tab').click(function(){
   			$('.direction-panel-wrapper').slideDown(1000);
             $('.tab').removeClass('tab-active');
             $(this).addClass('tab-active');
              //Opening panels while tabbed
                 var panelId = $(this).data('panel');
                 $('.panel-container').hide();
                 $('#'+panelId).show();
    });
//------------Inner direction window scroll li active class add -----------//
    $('#inner-window-scroll li').click(function(){
       $('#inner-window-scroll li').removeClass('tab-active');
       $(this).addClass('tab-active');
     });
//-----------POPUP MODAL :: Horizontally Scrolled Tab Navigation icons//
    /*$('.tab-list').listslider({
        left_label: '<i class="fa fa-caret-left"></i>',
        right_label: '<i class="fa fa-caret-right"></i>'
    });*/
//----------Add active class to current Srolling Tab-----------//
    $('.tab-list li').click(function(){
       $('.tab-list li').removeClass('tab-active');
       $(this).addClass('tab-active');
     });
 //------------Inner direction window data point scroller-----------//
    /* $('#inner-window-scroll').listslider({
	        left_label: '<i class="fa fa-caret-left"></i>',
	        right_label: '<i class="fa fa-caret-right"></i>'
	    }); */    
    //Liste View :: Right Section
   /* $('#scroll-data').listslider({
        left_label: '<i class="fa fa-caret-left"></i>',
        right_label: '<i class="fa fa-caret-right"></i>'
    });*/
//--------Add active class to current Srolling Tab------//
    $('#scroll-data li:not(:last-child)').click(function(){
       $('.data-point-list li').removeClass('tab-active');
       $(this).addClass('tab-active');
     });
//#Panel-2 :: Inner panel Add Destination click event to show Add destination panel-----//
	$('.add-destination-tab').click(function(){
                $('.destination-panel').show().addClass('animated slideInUp');
            });
           $('[action="cancel"]').click(function(){
               $('.destination-panel').hide().removeClass('animated slideInUp');
           });    
//--------DATA POINT POPOVER TRIGGER---------//
   /* $('.add-data-point').click(function(){
 		$('.data-point-panel').hide("slide", { direction: "left" }, 1000);
        $('.data-point-panel').show("slide", { direction: "right" }, 1000);
          //$('.data-point-panel').toggle(effect, options, duration);
    });*/
//-------Accordion panel check box event to open and collapse on checked -----------//
	/*$('.collapse').collapse();
		$('.panel-heading h4 a input[type=checkbox]').on('click', function(e){
    	e.stopPropagation();
   		$(this).parent().trigger('click');   // <---  HERE
	});
	
	$('#collapseOne').on('show.bs.collapse', function(e){
    	if( ! $('.panel-heading h4 a input[type=checkbox]').is(':checked') ){
	        return false;
	    }
	});   */ 
    

    //AWS Accordion
    /*$("#mapAccordion").awsAccordion({
	    type:"vertical",
	    startSlide:1,
	    openCloseHelper:{
	        openIcon:"chevron-down",
	        closeIcon:"chevron-up"
	    },
	    openOnebyOne:true,
	    classTab:"active",
	    slideOn:"click",
	    autoPlay:false,
	    autoPlaySpeed:2000
    });

    $("#listAccordion").awsAccordion({
	    type:"vertical",
	    startSlide:1,
	    openCloseHelper:{
	        openIcon:"chevron-down",
	        closeIcon:"chevron-up"
	    },
	    openOnebyOne:true,
	    classTab:"active",
	    slideOn:"click",
	    autoPlay:false,
	    autoPlaySpeed:2000
    });
    $("#innerAccordion").awsAccordion({
	    type:"vertical",
	    startSlide:1,
	    openCloseHelper:{
	        openIcon:"chevron-down",
	        closeIcon:"chevron-up"
	    },
	    openOnebyOne:true,
	    classTab:"active",
	    slideOn:"click",
	    autoPlay:false,
	    autoPlaySpeed:2000
    });*/
 //----------CODE BY RAHUL---------//
   
	/*$('#resultsAccordion, #listAccordion, #accordion').on('show.bs.collapse', function(e){
	   handleCollapse(e);
	}); 
	$('#resultsAccordion, #listAccordion, #accordion').on('hide.bs.collapse', function(e){
	    handleCollapse(e);
	});
	function handleCollapse(e){
		//console.log(e.currentTarget.id);
		var accordId = e.currentTarget.id;
		  var classname =  $("#"+accordId).children().find('i.fa').attr('class');
		if(classname.match('fa-chevron-down') !== null){
		   $("#"+accordId).children().find('i.fa').removeClass('fa-chevron-down');
		   $("#"+accordId).children().find('i.fa').addClass('fa-chevron-up');
		} else {
		   $("#"+accordId).children().find('i.fa').removeClass('fa-chevron-up');
		   $("#"+accordId).children().find('i.fa').addClass('fa-chevron-down');
		}
	} */

});

//*****************************************************************//
//********************Bootstrap Accordion**************************//
//******************$ Accordion Function****************************//

/*function toggleChevron(e) {
    $(e.target)
        .prev('.panel-heading')
        .find("i")
        .toggleClass('fa fa-chevron-up fa fa-chevron-down');
        
    var curId = $(e.target).attr('id');
    console.log(curId);
    $('div[id^="collapse"]').not($('div#'+curId).prev('div.panel-heading').children('h4.panel-title').children('i').addClass('fa fa-chevron-down'));   
    
}
$('body').on('hidden.bs.collapse','[id^="accordion"]', toggleChevron);
$('body').on('shown.bs.collapse','[id^="accordion"]', toggleChevron);

$('.expandall').on("click", function(){    
    $('div[id^="collapse"]').addClass('in');
    $('i').removeClass('fa fa-chevron-down').addClass('fa fa-chevron-up');
});

$('.collapseall').on("click", function(){    
    $('div[id^="collapse"]').removeClass('in');
    $('i').removeClass('fa fa-chevron-up').addClass('fa fa-chevron-down');
});
$('a[id^="AncHcollapse"]').on("click", function(){   
    var anchorId = $(this).attr("id");    
    var collapseId = anchorId.replace("AncH","");    
    $('div[id^="collapse"]').removeClass('in');
    $('i').removeClass('fa fa-chevron-up'); 
    $('#'+collapseId).prev('div.panel-heading').children('h4.panel-title').children('i').addClass('fa fa-chevron-up');    
    $('div[id^="'+collapseId+'"]').addClass('in');
    
    if(collapseId!=='collapseOne'){
        $('div#collapseOne').prev('div.panel-heading').children('h4.panel-title').children('i').addClass('fa fa-chevron-down')               
    }      
});
$('a[id^="Dbcollapse"]').on("click", function(){   
    var anchorId = $(this).attr("id");    
    var collapseId = anchorId.replace("Db","");    
    $('div[id^="collapse"]').removeClass('in');
    $('i').removeClass('fa fa-chevron-up'); 
    $('#'+collapseId).prev('div.panel-heading').children('h4.panel-title').children('i').addClass('fa fa-chevron-up');    
    $('div[id^="'+collapseId+'"]').addClass('in');
    
    if(collapseId!=='collapseOne'){
        $('div#collapseOne').prev('div.panel-heading').children('h4.panel-title').children('i').addClass('fa fa-chevron-down')               
    }
});*/

//************************************************************//
//********************List Horizontal Scroller**************************//
//**********************Function****************************//
//$ List Slider

// commented by Rahul
// causing error in IE
/*$.fn.extend({

    listslider: function(config){

        var global = this;

        if(config==undefined){
            config = {};
        }

        if(config.left_label === undefined){
            config.left_label = 'left';
        }

        if(config.right_label === undefined){
            config.right_label = 'right';
        }

        if(config.scroll_offset === undefined){
            config.scroll_offset = 100;
        }

        for(var i = 0 ; i < this.length ; i++){
            initListsliderFor($(this[i]));
        }

        global.touchHandler = function(){

            var self = this;
            self.previous_scroll = undefined;
            self.last_difference = 0;

            self.is_dragging = false;

            return {
                'isUserDragging': function(){
                    return self.is_dragging;
                },
                'onUserDragged': function(event){
                    var touch = event.originalEvent.touches[0];
                    if(self.previous_scroll !== undefined){
                        self.last_difference += touch.pageX - self.previous_scroll.pageX;
                    }
                    self.previous_scroll = touch;
                },
                'getHorizontalDifference': function(){
                    var hlp = self.last_difference;
                    self.last_difference = 0;
                    return hlp;
                },
                'onStartedDragging': function(){
                    self.is_dragging = true;
                    self.last_difference = 0;
                    self.previous_scroll = undefined;
                },
                'onStoppedDragging': function(){
                    self.is_dragging = false;
                    self.last_difference = 0;
                    self.previous_scroll = undefined;
                }
            }
        }();

        function initListsliderFor(element){

            var self = this;

            self.getSummedWidthOfListItems = function(){
                var sum = 0;
                var list_items = self.ul.find('li');
                for (var i = 0 ; i < list_items.length ; i++){
                    sum += $(list_items[i]).outerWidth();
                }
                return sum + 10;
            };

            self.setupParentDiv = function(){
                self.parent = self.ul.parent();
                self.parent.css('position', 'relative');
            };

            self.showPaginationIfWrapperIsHidden = function(){
                var wrapper_width = self.getSummedWidthOfListItems();
                if($(self.parent).width() < wrapper_width){
                    $(self.parent).find('.listslider-arrow').addClass('active');
                }  else{
                    $(self.parent).find('.listslider-arrow').removeClass('active');
                }
            };

            self.addWrapper = function(){
                self.ul.wrap('<div class="listslider-container"><div class="listslider-wrapper"></div></div>');
                self.wrapper = $(self.ul.closest('.listslider-wrapper'));
                var wrapper_width = self.getSummedWidthOfListItems();
                self.wrapper.css('width', 100 + '%');
            };

            self.addContainer = function(){
                self.container = $(self.ul.closest('.listslider-container'));
            };

            self.addArrows = function(){
                self.parent.append('<div class="listslider-left listslider-arrow">' + config.left_label + '</div>');
                self.parent.append('<div class="listslider-right listslider-arrow">' + config.right_label + '</div>');

                self.right_arrow = $('.listslider-right.listslider-arrow');
                self.left_arrow = $('.listslider-left.listslider-arrow');
            };

            self.scroll = function(amount){
                self.container.animate({
                   scrollLeft:  self.container.scrollLeft() + amount
                });
            };



            $(window).on('resize', function(){
                self.showPaginationIfWrapperIsHidden();
            });

            self.attachEventsToElements  = function(){
                self.container.on('touchstart',function(e){

                    global.touchHandler.onStartedDragging();
                });

                self.container.on('touchend',function(e){

                    global.touchHandler.onStoppedDragging();
                });

                self.container.on('touchmove',function(e){
                    if(global.touchHandler.isUserDragging()){
                        var diff = global.touchHandler.getHorizontalDifference();
                        if(diff == 0){
                            global.touchHandler.onUserDragged(e);
                            return;
                        }
                        self.container.scrollLeft(self.container.scrollLeft() - diff);
                        global.touchHandler.onUserDragged(e);
                    }
                });


                $(self.parent).on('click', '.listslider-arrow', function(){
                    if($(this).hasClass('listslider-left')){
                        self.scroll(-1 * config.scroll_offset);
                    }else{
                        self.scroll(config.scroll_offset);
                    }
                });
            };




            self.ul = $(element);
            self.ul.addClass('listslider');

            self.setupParentDiv();
            self.addWrapper();
            self.addContainer();
            self.addArrows();
            self.attachEventsToElements();
            self.showPaginationIfWrapperIsHidden();

        }
    }
});*/
