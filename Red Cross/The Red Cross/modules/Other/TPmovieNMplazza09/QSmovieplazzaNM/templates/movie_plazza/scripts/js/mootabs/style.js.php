<?php
if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: application/x-javascript; charset: UTF-8');
header('Cache-Control: must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + (3600*60)) . ' GMT');

if(!empty($_GET))
{
	foreach($_GET as $key => $val)
	{
		unset($_GET[$key]);
		$val = (substr($val, 0, 4) == 'amp;') ? substr($val, 4) : $val;
		$key = (substr($key, 0, 4) == 'amp;') ? substr($key, 4) : $key;
		$_GET[$key] = $val;
	}
}

$width = (!empty($_GET['width'])) ? $_GET['width'] : 900;
$height = (!empty($_GET['height'])) ? $_GET['height'] : 180;
$transition = (!empty($_GET['transition'])) ? $_GET['transition'] : null;
$duration = (!empty($_GET['duration'])) ? $_GET['duration'] : 1000;
$duration = ( (int) $duration ) ? $duration : 1000;
$interval = (!empty($_GET['interval'])) ? $_GET['interval'] : 3000;
$interval = ( (int) $interval ) ? $interval : 3000;
$mode  = (!empty($_GET['mode'])) ? $_GET['mode'] : 'horizontal';
$width = ($mode == 'vertical') ? $height : $width;
$autoplay = (!empty($_GET['autoplay'])) ? $_GET['autoplay'] : 0;
$autoplay = ($autoplay) ? 'true' : 'false';
?>

window.addEvent('domready',function(){
	var hs8 = new noobSlide({
		box: $('mootabs_box'),
		startItem: 1,
		autoPlay: <?php echo $autoplay; ?>,
		interval: <?php echo $interval; ?>,
		items: $ES('div.mootabs_inner', 'mootabs_box'),
		size: <?php echo $width; ?>,
		<?php if(!empty($transition)): ?>
		fxOptions: {
			duration: <?php echo $duration; ?>,
			transition: Fx.Transitions.Bounce.easeOut,
			wait: false
		},
		<?php endif; ?>
		mode: '<?php echo $mode; ?>',
		handles: $ES('span','mootabs_handles'),
		onWalk: function(currentItem,currentHandle){
			$$(this.handles,mootabs_handles).removeClass('active');
			$$(currentHandle,mootabs_handles[this.currentIndex]).addClass('active');
		}
	});
	var mootabs_handles = $ES('span','mootabs_handles');
	hs8.addHandleButtons(mootabs_handles);
	hs8.walk(0)
});

