<?php
/* =================================================
# Filename : index.php
# Description : Root index php
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com All rights reserved.

=================================================
*/

defined('_JEXEC') or die('Restricted access');
$url = clone(JURI::getInstance());
include('scripts/php/user.php');
include('scripts/php/template_config.php');
$tpFramework->ieRedirect();
?>
<?php echo '<?xml version="1.0" encoding="utf-8"?' .'>'; ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php echo $this->language; ?>" lang="<?php echo $this->language; ?>" >
<head>
<jdoc:include type="head" />
<?php $tpFramework->headers($this, $cssgets, $jsgets); ?>
</head>

<body class="tpbodies">
		
<!-- @@@@@@@@@@@@@@ SKELETON SECTION STARTS HERE @@@@@@@@@@@@@@ -->
<?php $tpFramework->skeletons(); ?>
<!-- @@@@@@@@@@@@@@ SKELETON SECTION ENDS HERE @@@@@@@@@@@@@@ -->
<?php echo $tpFramework->switchURL(); ?>
</body>
</html>