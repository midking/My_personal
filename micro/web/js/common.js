$(document).ready(function(){

	$(window).smoothWheel();

	if($('html').hasClass('desktop')){
		var explode = function(){
			console.log("asdf");
			$("body").animate({scrollTop:373}, 1200);
		}
		setTimeout(explode, 2000);

		$(window).scroll(function(){
			var scrollTop = $(document).scrollTop();
			if(scrollTop >= 200){
				$('.topBox').addClass('scrollTop');
			}else{
				$('.topBox').removeClass('scrollTop');
			}
			console.log(scrollTop);
		});

		(function($){
			var documentEl = $(document)
				parallaxBg = $('.parallaxBg');
			documentEl.on('scroll', function(){
				var currScrollPos = documentEl.scrollTop();
				parallaxBg.css('background-position', 'center ' + -currScrollPos/8 +'px');
			});
		})(jQuery);
	}else{
		$(window).scroll(function(){
			console.log($(document).scrollTop());
		});

		$(window).scroll(function(){
			var scrollTop = $(document).scrollTop();
			if(scrollTop >= 50){
				$('.topBox').addClass('scrollTop');
			}else{
				$('.topBox').removeClass('scrollTop');
			}
			console.log(scrollTop);
		});

		$(".allMenuButton button").on('click', function(){
			$(".topBox").toggleClass('on');
		});

		(function($){
			var documentEl = $(document)
				parallaxBg = $('.parallaxBg');
			documentEl.on('scroll', function(){
				var currScrollPos = documentEl.scrollTop();
				parallaxBg.css('background-position', 'center ' + -currScrollPos/8 +'px');
			});
		})(jQuery);
	}


	/* 메인 백그라운드 마우스 오버시 move */
	/*var lFollowX = 0,
		lFollowY = 0,
		x = 0,
		y = 0,
		friction = 1 / 30;

	function moveBackground() {
		x += (lFollowX - x) * friction;
		y += (lFollowY - y) * friction;

		translate = 'translate(' + x + 'px, ' + y + 'px) scale(1.05)';
		
		$('.mainBg').css({
			'-webit-transform': translate,
			'-moz-transform': translate,
			'transform': translate
		});

		window.requestAnimationFrame(moveBackground);
	}

	$(window).on('mousemove click', function(e) {
		var lMouseX = Math.max(-100, Math.min(100, $(window).width() / 2 - e.clientX));
		var lMouseY = Math.max(-100, Math.min(100, $(window).height() / 2 - e.clientY));
		lFollowX = (6 * lMouseX) / 100; // 100 : 12 = lMouxeX : lFollow
		lFollowY = (2 * lMouseY) / 100;
	});
	moveBackground();*/
	/* 메인 백그라운드 마우스 오버시 move */
});