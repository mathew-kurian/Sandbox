<?php
/* =================================================
# Filename : component.php
=================================================
*/
	
	defined( '_JEXEC' ) or die( 'Restricted access' );
	$template_name		= $this->template;
	$tpurl		= $this->baseurl . "/templates/" . $template_name;
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php echo $this->language; ?>" lang="<?php echo $this->language; ?>" >
<head>
<jdoc:include type="head" />
<?php JHTML::_('behavior.mootools'); ?>

<link rel="stylesheet" href="<?php echo $tpurl; ?>/css/joomla.css" type="text/css" />
<script type="text/javascript" src="<?php echo $tpurl; ?>/scripts/js/template_component.js"></script>
</head>
<body class="contentpane">
	<jdoc:include type="message" />
	<jdoc:include type="component" />
</body>
</html>
