CREATE TABLE IF NOT EXISTS `site_oxymall_core_modules` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) DEFAULT NULL,
  `module_code` varchar(255) DEFAULT NULL,
  `module_file` varchar(255) DEFAULT NULL,
  `module_settings` longtext,
  `module_unique` int(1) DEFAULT NULL,
  `module_unique_enabled` int(1) DEFAULT NULL,
  `module_links` text,
  `module_help` text,
  `module_system` int(1) NOT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(1, 'About', 'about', 'aboutus.swf', 'a:5:{s:14:"set_imagewidth";s:3:"411";s:15:"set_imageheight";s:3:"367";s:21:"set_slideshowinterval";s:1:"7";s:23:"set_fadeinanimationtime";s:3:"0.5";s:23:"set_fadeinanimationtype";s:6:"linear";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nHeader|index.php?mod=oxymall&sub=oxymall.plugin.about.landing&module_id={MODULE_ID}&action=details\r\nImages|index.php?mod=oxymall&sub=oxymall.plugin.about.images&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}\r\n', '<object width="640" height="505"><param name="movie" value="http://www.youtube.com/v/VngRJXrjXE0&hl=en&fs=1&color1=0x5d1719&color2=0xcd311b"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/VngRJXrjXE0&hl=en&fs=1&color1=0x5d1719&color2=0xcd311b" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="505"></embed></object>', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(2, 'Banner', 'banner', 'banner.swf', 'a:10:{s:14:"set_totalwidth";s:3:"741";s:15:"set_totalheight";s:3:"367";s:9:"set_blurx";s:2:"20";s:9:"set_blury";s:1:"0";s:15:"set_blurquality";s:1:"2";s:22:"set_slideanimationtime";s:3:"0.5";s:22:"set_slideanimationtype";s:11:"easeoutcirc";s:20:"set_descriptionblurx";s:2:"10";s:20:"set_descriptionblury";s:2:"10";s:26:"set_descriptionblurquality";s:1:"2";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nItems|index.php?mod=oxymall&sub=oxymall.plugin.banner.landing&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(3, 'Clients', 'clients', 'clients.swf', 'a:4:{s:14:"set_imagewidth";s:3:"198";s:15:"set_imageheight";s:2:"93";s:19:"set_horizontalspace";s:2:"16";s:17:"set_verticalspace";s:2:"15";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nHeader|index.php?mod=oxymall&sub=oxymall.plugin.clients.landing&module_id={MODULE_ID}&action=details\r\nImages|index.php?mod=oxymall&sub=oxymall.plugin.clients.images&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(4, 'Contact', 'contact', 'contactus.swf', 'a:13:{s:8:\\"set_text\\";s:47:\\"../../../contact-send.php?module_id={MODULE_ID}\\";s:10:\\"set_upload\\";s:49:\\"../../../contact-upload.php?module_id={MODULE_ID}\\";s:19:\\"set_email_1_to_name\\";s:15:\\"Emanuel Giurgea\\";s:20:\\"set_email_1_to_email\\";s:17:\\"emanuel@oxylus.ro\\";s:21:\\"set_email_1_from_name\\";s:6:\\"{NAME}\\";s:22:\\"set_email_1_from_email\\";s:7:\\"{EMAIL}\\";s:19:\\"set_email_1_subject\\";s:37:\\"You received a new message: {SUBJECT}\\";s:19:\\"set_email_1_message\\";s:162:\\"<p>Hello,</p>\r\n<p>You received a new message:</p>\r\n<p>Name: {NAME}</p>\r\n<p>Email:&#160;{EMAIL}</p>\r\n<p>Subject:&#160;{SUBJECT}</p>\r\n<p>Body:</p>\r\n<p>{MESSAGE}</p>\\";s:11:\\"set_email_2\\";s:1:\\"1\\";s:19:\\"set_email_2_to_name\\";s:12:\\"Website Name\\";s:20:\\"set_email_2_to_email\\";s:18:\\"no-reply@oxylus.ro\\";s:19:\\"set_email_2_subject\\";s:27:\\"Thank you for contacting us\\";s:19:\\"set_email_2_message\\";s:115:\\"<p>Hello {NAME},</p>\r\n<p>Thank you for contacting us, You will be contacted by one of our representatives asap.</p>\\";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nTexts|index.php?mod=oxymall&sub=oxymall.plugin.contact.landing&module_id={MODULE_ID}\r\nReceived Messages|index.php?mod=oxymall&sub=oxymall.plugin.contact.items&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(5, 'Gallery', 'gallery', 'gallery.swf', 'a:5:{s:30:"set_distancebetweenmenubuttons";s:2:"14";s:14:"set_thumbwidth";s:2:"90";s:15:"set_thumbheight";s:2:"68";s:24:"set_horizontalthumbspace";s:1:"9";s:22:"set_verticalthumbspace";s:1:"9";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nAlbums|index.php?mod=oxymall&sub=oxymall.plugin.gallery.landing&module_id={MODULE_ID}&action=details\r\nImages|index.php?mod=oxymall&sub=oxymall.plugin.gallery.images&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(6, 'Jobs', 'jobs', 'jobs.swf', 'a:18:{s:16:\\"set_upload_field\\";s:1:\\"1\\";s:14:\\"set_main_title\\";s:19:\\"Job Opening details\\";s:17:\\"set_contact_title\\";s:15:\\"Job Application\\";s:16:\\"set_upload_title\\";s:18:\\"Upload your resume\\";s:18:\\"set_readmore_title\\";s:17:\\"Read more details\\";s:8:\\"set_text\\";s:46:\\"../../../resume-send.php?module_id={MODULE_ID}\\";s:10:\\"set_upload\\";s:48:\\"../../../resume-upload.php?module_id={MODULE_ID}\\";s:19:\\"set_email_1_to_name\\";s:10:\\"Site Admin\\";s:20:\\"set_email_1_to_email\\";s:19:\\"admin@your-site.com\\";s:21:\\"set_email_1_from_name\\";s:6:\\"{NAME}\\";s:22:\\"set_email_1_from_email\\";s:7:\\"{EMAIL}\\";s:19:\\"set_email_1_subject\\";s:36:\\"You received a new resume: {SUBJECT}\\";s:19:\\"set_email_1_message\\";s:212:\\"<p>Hello,</p>\r\n<p>You received a new resume:</p>\r\n<p>Name: {NAME}</p>\r\n<p>Email:&#160;{EMAIL}</p>\r\n<p>Phone:&#160;{PHONE}</p>\r\n<p>Attachment:&#160;{ATTACHMENT_LINK}</p>\r\n<p>Body:</p>\r\n<p>{NOTE}</p>\r\n<p>&#160;</p>\\";s:11:\\"set_email_2\\";s:1:\\"1\\";s:19:\\"set_email_2_to_name\\";s:12:\\"Website Name\\";s:20:\\"set_email_2_to_email\\";s:22:\\"no-reply@your-site.com\\";s:19:\\"set_email_2_subject\\";s:41:\\"Thank you for applying to one of our jobs\\";s:19:\\"set_email_2_message\\";s:115:\\"<p>Hello {NAME},</p>\r\n<p>Thank you for contacting us, You will be contacted by one of our representatives asap.</p>\\";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nJobs|index.php?mod=oxymall&sub=oxymall.plugin.jobs.landing&module_id={MODULE_ID}\r\nResumes|index.php?mod=oxymall&sub=oxymall.plugin.jobs.resumes&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(7, 'News', 'news', 'news.swf', 'a:6:{s:15:\\"set_blurxamount\\";s:3:\\"120\\";s:15:\\"set_bluryamount\\";s:1:\\"0\\";s:17:\\"set_animationtime\\";s:1:\\"1\\";s:17:\\"set_animationtype\\";s:10:\\"easeinquad\\";s:15:\\"set_date_format\\";s:6:\\"F j, Y\\";s:15:\\"set_popup_title\\";s:12:\\"News Details\\";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nNews Items|index.php?mod=oxymall&sub=oxymall.plugin.news.landing&module_id={MODULE_ID}&action=details\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(8, 'Portfolio', 'portfolio', 'portfolio.swf', 'a:25:{s:15:"set_blurxamount";s:2:"40";s:15:"set_bluryamount";s:1:"0";s:17:"set_animationtime";s:3:"0.3";s:17:"set_animationtype";s:14:"easeoutelastic";s:14:"set_thumbwidth";s:3:"271";s:15:"set_thumbheight";s:3:"236";s:25:"set_distancebetweenthumbs";s:2:"18";s:18:"set_thumbsonslider";s:1:"3";s:18:"set_scrollingblurx";s:2:"60";s:23:"set_fadeinanimationtime";s:3:"0.5";s:16:"set_maxtextwidth";s:3:"800";s:32:"set_thumbwidthprojecttypelisting";s:3:"199";s:33:"set_thumbheightprojecttypelisting";s:3:"111";s:19:"set_horizontalspace";s:2:"13";s:17:"set_verticalspace";s:2:"13";s:28:"set_projectslistingmaskwidth";s:3:"900";s:29:"set_projectslistingmaskheight";s:3:"312";s:28:"set_projectslistingtextwidth";s:3:"900";s:12:"set_backxpos";s:3:"770";s:28:"set_thumbwidthprojectdetails";s:3:"409";s:29:"set_thumbheightprojectdetails";s:3:"365";s:20:"set_popupblurxamount";s:2:"60";s:20:"set_popupbluryamount";s:1:"0";s:22:"set_popupanimationtime";s:1:"1";s:22:"set_popupanimationtype";s:12:"easeoutquint";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nHeader|index.php?mod=oxymall&sub=oxymall.plugin.portfolio.landing&module_id={MODULE_ID}&action=details\r\nCategories|index.php?mod=oxymall&sub=oxymall.plugin.portfolio.cats&module_id={MODULE_ID}\r\nProjects|index.php?mod=oxymall&sub=oxymall.plugin.portfolio.projects&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(9, 'Services', 'services', 'services.swf', 'a:6:{s:14:\\"set_imagewidth\\";s:3:\\"411\\";s:15:\\"set_imageheight\\";s:3:\\"367\\";s:14:\\"set_textheight\\";s:3:\\"367\\";s:21:\\"set_slideshowinterval\\";s:1:\\"3\\";s:23:\\"set_fadeinanimationtime\\";s:1:\\"1\\";s:23:\\"set_fadeinanimationtype\\";s:12:\\"easeoutcubic\\";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nCategories|index.php?mod=oxymall&sub=oxymall.plugin.services.landing&module_id={MODULE_ID}&action=details\r\nImages|index.php?mod=oxymall&sub=oxymall.plugin.services.images&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(10, 'Homepage', 'homepage', 'homepage.swf', 'a:5:{s:14:"set_thumbwidth";s:3:"199";s:15:"set_thumbheight";s:3:"111";s:25:"set_distancebetweenthumbs";s:2:"13";s:18:"set_thumbsonslider";s:1:"4";s:18:"set_scrollingblurx";s:2:"60";}', 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\nHeader|index.php?mod=oxymall&sub=oxymall.plugin.homepage.landing&module_id={MODULE_ID}&action=details\r\nImages|index.php?mod=oxymall&sub=oxymall.plugin.homepage.images&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(11, 'Mp3 Player', 'music', 'mp3player.swf', 'a:2:{s:16:"set_onfirststart";s:4:"mute";s:17:"set_playingvolume";s:2:"70";}', 0, 1, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.default&action=details&module_id={MODULE_ID}\r\nMusic|index.php?mod=oxymall&sub=oxymall.plugin.music.landing&module_id={MODULE_ID}\r\nVideo Tutorial|index.php?mod=oxymall&sub=oxymall.plugin.modules.help&module_id={MODULE_ID}', '', 0);
INSERT INTO `site_oxymall_core_modules` (`module_id`, `module_name`, `module_code`, `module_file`, `module_settings`, `module_unique`, `module_unique_enabled`, `module_links`, `module_help`, `module_system`) VALUES(12, 'External Link', 'external-link', 'external-link', NULL, 1, 0, 'Module Settings|index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={MODULE_ID}\r\n', NULL, 1);

CREATE TABLE IF NOT EXISTS `site_oxymall_core_modules_user` (
  `mod_id` int(11) NOT NULL AUTO_INCREMENT,
  `mod_order` int(11) NOT NULL DEFAULT '0',
  `mod_status` int(1) NOT NULL DEFAULT '0',
  `mod_invisible` int(1) NOT NULL,
  `mod_module` int(11) NOT NULL DEFAULT '0',
  `mod_module_code` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mod_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mod_long_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mod_urltitle` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mod_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mod_settings` longtext CHARACTER SET utf8,
  PRIMARY KEY (`mod_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(1, 2, 1, 0, 1, 'about', 'About', 'About Us', 'About Us', 'about', 'a:6:{s:16:\\"set_reverseorder\\";s:1:\\"1\\";s:14:\\"set_imagewidth\\";s:3:\\"411\\";s:15:\\"set_imageheight\\";s:3:\\"367\\";s:21:\\"set_slideshowinterval\\";s:1:\\"7\\";s:23:\\"set_fadeinanimationtime\\";s:3:\\"0.5\\";s:23:\\"set_fadeinanimationtype\\";s:6:\\"linear\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(6, 9, 1, 0, 3, 'clients', 'Clients', 'Clients', 'Clients', 'clients', 'a:5:{s:14:\\"set_imagewidth\\";s:3:\\"198\\";s:15:\\"set_imageheight\\";s:2:\\"93\\";s:19:\\"set_horizontalspace\\";s:2:\\"16\\";s:17:\\"set_verticalspace\\";s:2:\\"15\\";s:16:\\"set_reverseorder\\";s:1:\\"1\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(7, 13, 1, 0, 4, 'contact', 'Contact', 'Contact', 'Contact', 'contact', 'a:13:{s:8:\\"set_text\\";s:37:\\"../../../contact-send.php?module_id=7\\";s:10:\\"set_upload\\";s:39:\\"../../../contact-upload.php?module_id=7\\";s:19:\\"set_email_1_to_name\\";s:15:\\"Emanuel Giurgea\\";s:20:\\"set_email_1_to_email\\";s:17:\\"emanuel@oxylus.ro\\";s:21:\\"set_email_1_from_name\\";s:6:\\"{NAME}\\";s:22:\\"set_email_1_from_email\\";s:7:\\"{EMAIL}\\";s:19:\\"set_email_1_subject\\";s:37:\\"You received a new message: {SUBJECT}\\";s:19:\\"set_email_1_message\\";s:162:\\"<p>Hello,</p>\r\n<p>You received a new message:</p>\r\n<p>Name: {NAME}</p>\r\n<p>Email:&#160;{EMAIL}</p>\r\n<p>Subject:&#160;{SUBJECT}</p>\r\n<p>Body:</p>\r\n<p>{MESSAGE}</p>\\";s:11:\\"set_email_2\\";s:1:\\"1\\";s:19:\\"set_email_2_to_name\\";s:12:\\"Website Name\\";s:20:\\"set_email_2_to_email\\";s:18:\\"no-reply@oxylus.ro\\";s:19:\\"set_email_2_subject\\";s:27:\\"Thank you for contacting us\\";s:19:\\"set_email_2_message\\";s:115:\\"<p>Hello {NAME},</p>\r\n<p>Thank you for contacting us, You will be contacted by one of our representatives asap.</p>\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(8, 10, 1, 0, 5, 'gallery', 'Media Gallery', 'Gallery', 'Gallery', 'gallery', 'a:6:{s:30:\\"set_distancebetweenmenubuttons\\";s:2:\\"14\\";s:14:\\"set_thumbwidth\\";s:2:\\"90\\";s:15:\\"set_thumbheight\\";s:2:\\"68\\";s:24:\\"set_horizontalthumbspace\\";s:1:\\"9\\";s:22:\\"set_verticalthumbspace\\";s:1:\\"9\\";s:16:\\"set_reverseorder\\";s:1:\\"1\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(9, 11, 1, 0, 6, 'jobs', 'Careers', 'Careers', 'Careers', 'careers', 'a:20:{s:16:\\"set_reverseorder\\";s:1:\\"1\\";s:14:\\"set_main_title\\";s:19:\\"Job Opening details\\";s:17:\\"set_contact_title\\";s:15:\\"Job Application\\";s:16:\\"set_upload_title\\";s:18:\\"Upload your resume\\";s:18:\\"set_readmore_title\\";s:17:\\"Read more details\\";s:8:\\"set_text\\";s:36:\\"../../../resume-send.php?module_id=9\\";s:10:\\"set_upload\\";s:38:\\"../../../resume-upload.php?module_id=9\\";s:11:\\"set_email_1\\";s:1:\\"1\\";s:19:\\"set_email_1_to_name\\";s:15:\\"Emanuel Giurgea\\";s:20:\\"set_email_1_to_email\\";s:17:\\"emanuel@oxylus.ro\\";s:21:\\"set_email_1_from_name\\";s:6:\\"{NAME}\\";s:22:\\"set_email_1_from_email\\";s:7:\\"{EMAIL}\\";s:19:\\"set_email_1_subject\\";s:36:\\"You received a new resume: {SUBJECT}\\";s:19:\\"set_email_1_message\\";s:212:\\"<p>Hello,</p>\r\n<p>You received a new resume:</p>\r\n<p>Name: {NAME}</p>\r\n<p>Email:&#160;{EMAIL}</p>\r\n<p>Phone:&#160;{PHONE}</p>\r\n<p>Attachment:&#160;{ATTACHMENT_LINK}</p>\r\n<p>Body:</p>\r\n<p>{NOTE}</p>\r\n<p>&#160;</p>\\";s:11:\\"set_email_2\\";s:1:\\"1\\";s:19:\\"set_email_2_to_name\\";s:12:\\"Website Name\\";s:20:\\"set_email_2_to_email\\";s:18:\\"no-reply@oxylus.ro\\";s:19:\\"set_email_2_subject\\";s:41:\\"Thank you for applying to one of our jobs\\";s:19:\\"set_email_2_message\\";s:115:\\"<p>Hello {NAME},</p>\r\n<p>Thank you for contacting us, You will be contacted by one of our representatives asap.</p>\\";s:16:\\"set_upload_field\\";s:1:\\"0\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(10, 6, 1, 0, 7, 'news', 'News', 'News', 'News', 'news', 'a:6:{s:15:\\"set_blurxamount\\";s:2:\\"60\\";s:15:\\"set_bluryamount\\";s:1:\\"0\\";s:17:\\"set_animationtime\\";s:3:\\"0.5\\";s:17:\\"set_animationtype\\";s:12:\\"easeoutquart\\";s:15:\\"set_date_format\\";s:6:\\"F j, Y\\";s:15:\\"set_popup_title\\";s:12:\\"News Details\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(11, 8, 1, 0, 8, 'portfolio', 'Our Portfolio', 'Portfolio', 'Portfolio', 'portfolio', 'a:27:{s:16:\\"set_reverseorder\\";s:1:\\"1\\";s:17:\\"set_reverseorderp\\";s:1:\\"1\\";s:15:\\"set_blurxamount\\";s:2:\\"40\\";s:15:\\"set_bluryamount\\";s:1:\\"0\\";s:17:\\"set_animationtime\\";s:3:\\"0.3\\";s:17:\\"set_animationtype\\";s:12:\\"easeoutquart\\";s:14:\\"set_thumbwidth\\";s:3:\\"271\\";s:15:\\"set_thumbheight\\";s:3:\\"236\\";s:25:\\"set_distancebetweenthumbs\\";s:2:\\"18\\";s:18:\\"set_thumbsonslider\\";s:1:\\"3\\";s:18:\\"set_scrollingblurx\\";s:2:\\"60\\";s:23:\\"set_fadeinanimationtime\\";s:3:\\"0.5\\";s:16:\\"set_maxtextwidth\\";s:3:\\"800\\";s:32:\\"set_thumbwidthprojecttypelisting\\";s:3:\\"199\\";s:33:\\"set_thumbheightprojecttypelisting\\";s:3:\\"111\\";s:19:\\"set_horizontalspace\\";s:2:\\"13\\";s:17:\\"set_verticalspace\\";s:2:\\"13\\";s:28:\\"set_projectslistingmaskwidth\\";s:3:\\"900\\";s:29:\\"set_projectslistingmaskheight\\";s:3:\\"312\\";s:28:\\"set_projectslistingtextwidth\\";s:3:\\"900\\";s:12:\\"set_backxpos\\";s:3:\\"770\\";s:28:\\"set_thumbwidthprojectdetails\\";s:3:\\"409\\";s:29:\\"set_thumbheightprojectdetails\\";s:3:\\"365\\";s:20:\\"set_popupblurxamount\\";s:2:\\"60\\";s:20:\\"set_popupbluryamount\\";s:1:\\"0\\";s:22:\\"set_popupanimationtime\\";s:1:\\"1\\";s:22:\\"set_popupanimationtype\\";s:11:\\"easeinquint\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(5, 12, 0, 0, 2, 'banner', 'Banner Rotator', 'Banner Rotator', 'Banner', 'banner', 'a:11:{s:14:\\"set_totalwidth\\";s:3:\\"741\\";s:15:\\"set_totalheight\\";s:3:\\"367\\";s:9:\\"set_blurx\\";s:2:\\"20\\";s:9:\\"set_blury\\";s:1:\\"0\\";s:15:\\"set_blurquality\\";s:1:\\"2\\";s:22:\\"set_slideanimationtime\\";s:3:\\"0.5\\";s:22:\\"set_slideanimationtype\\";s:11:\\"easeoutsine\\";s:20:\\"set_descriptionblurx\\";s:2:\\"10\\";s:20:\\"set_descriptionblury\\";s:2:\\"10\\";s:26:\\"set_descriptionblurquality\\";s:1:\\"2\\";s:16:\\"set_reverseorder\\";s:1:\\"1\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(12, 7, 1, 0, 9, 'services', 'Services', 'Services', 'Services', 'services', 'a:7:{s:14:\\"set_imagewidth\\";s:3:\\"411\\";s:15:\\"set_imageheight\\";s:3:\\"367\\";s:14:\\"set_textheight\\";s:3:\\"367\\";s:21:\\"set_slideshowinterval\\";s:1:\\"3\\";s:23:\\"set_fadeinanimationtime\\";s:1:\\"1\\";s:23:\\"set_fadeinanimationtype\\";s:12:\\"easeoutcubic\\";s:16:\\"set_reverseorder\\";s:1:\\"1\\";}');
INSERT INTO `site_oxymall_core_modules_user` (`mod_id`, `mod_order`, `mod_status`, `mod_invisible`, `mod_module`, `mod_module_code`, `mod_name`, `mod_long_name`, `mod_urltitle`, `mod_url`, `mod_settings`) VALUES(13, 1, 1, 0, 10, 'homepage', 'Homepage', 'Welcome to our website', 'Welcome to our website', 'homepage', 'a:6:{s:14:\\"set_thumbwidth\\";s:3:\\"199\\";s:15:\\"set_thumbheight\\";s:3:\\"111\\";s:25:\\"set_distancebetweenthumbs\\";s:2:\\"13\\";s:18:\\"set_thumbsonslider\\";s:1:\\"4\\";s:18:\\"set_scrollingblurx\\";s:2:\\"60\\";s:16:\\"set_reverseorder\\";s:1:\\"1\\";}');

-- --------------------------------------------------------

--
-- Table structure for table `site_oxymall_core_skins`
--

CREATE TABLE IF NOT EXISTS `site_oxymall_core_skins` (
  `skin_id` int(11) NOT NULL AUTO_INCREMENT,
  `skin_name` varchar(255) NOT NULL,
  `skin_code` varchar(255) NOT NULL,
  `skin_file` int(11) NOT NULL,
  `skin_file_file` varchar(255) NOT NULL,
  `skin_system` int(1) NOT NULL DEFAULT '0',
  `skin_default` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`skin_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

INSERT INTO `site_oxymall_core_skins` (`skin_id`, `skin_name`, `skin_code`, `skin_file`, `skin_file_file`, `skin_system`, `skin_default`) VALUES(1, 'White', 'white', 1, '1.zip', 1, 0);
INSERT INTO `site_oxymall_core_skins` (`skin_id`, `skin_name`, `skin_code`, `skin_file`, `skin_file_file`, `skin_system`, `skin_default`) VALUES(2, 'Black', 'black', 1, '2.zip', 1, 1);

CREATE TABLE IF NOT EXISTS `site_oxymall_core_vars` (
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `value` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_skin', '2');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_copyright', 'Copyright 2009 Your Company. All rights reserved');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_temp', 'set_logologo1245933798.png');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_radio_type', '0');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_upload_web', 'http://');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_file', '@logo.png');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo', '1');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_width', '216');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_logo_height', '56');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_meta_title', 'Slick Full Website Template');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_meta_keys', 'keys');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_meta_desc', 'description');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_google_analytics', '0');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_google_analytics_tracker', '');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_misc', '');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_menu_show', '1');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_menu_align', 'left');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_tpl_maxwidth', '980');
INSERT INTO `site_oxymall_core_vars` (`name`, `value`) VALUES('set_tpl_maxheight', '600');

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_about_images` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_image_width` int(11) DEFAULT NULL,
  `item_image_height` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_banner_images` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_image_width` int(11) DEFAULT NULL,
  `item_image_height` int(11) DEFAULT NULL,
  `item_swf` int(1) DEFAULT NULL,
  `item_swf_file` varchar(255) DEFAULT NULL,
  `item_description` text,
  `item_url` varchar(255) DEFAULT NULL,
  `item_target` varchar(20) DEFAULT NULL,
  `item_stay` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_clients_images` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_image_width` int(11) DEFAULT NULL,
  `item_image_height` int(11) DEFAULT NULL,
  `item_description` text,
  `item_url` varchar(255) DEFAULT NULL,
  `item_target` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_contact_messages` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(32) DEFAULT NULL,
  `item_file` int(1) DEFAULT NULL,
  `item_file_file` varchar(255) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_new` int(1) DEFAULT NULL,
  `item_date` int(11) DEFAULT NULL,
  `item_email` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `item_subject` varchar(255) DEFAULT NULL,
  `item_message` text,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_galleries_cats` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `cat_title` varchar(255) DEFAULT NULL,
  `cat_urltitle` varchar(255) DEFAULT NULL,
  `cat_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cat_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_galleries_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `item_cat` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_image_large` int(1) DEFAULT NULL,
  `item_image_large_file` varchar(255) DEFAULT NULL,
  `item_video` int(1) DEFAULT NULL,
  `item_video_file` varchar(255) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_urltitle` varchar(255) DEFAULT NULL,
  `item_description` text,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=330 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_homepage_images` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item_image_width` int(11) DEFAULT NULL,
  `item_image_height` int(11) DEFAULT NULL,
  `item_title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item_target` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_jobs_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_status` int(1) DEFAULT NULL,
  `item_date` int(11) DEFAULT NULL,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_urltitle` varchar(255) DEFAULT NULL,
  `item_location` varchar(255) DEFAULT NULL,
  `item_small_description` text,
  `item_big_description` text,
  `item_main_title` varchar(255) NOT NULL,
  `item_contact_title` varchar(255) NOT NULL,
  `item_upload_title` varchar(255) NOT NULL,
  `item_readmore_title` varchar(255) NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_jobs_resumes` (
  `resume_id` int(11) NOT NULL AUTO_INCREMENT,
  `resume_code` varchar(32) DEFAULT NULL,
  `resume_date` int(11) DEFAULT NULL,
  `resume_job` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `resume_name` varchar(255) DEFAULT NULL,
  `resume_mail` varchar(255) DEFAULT NULL,
  `resume_phone` varchar(255) DEFAULT NULL,
  `resume_note` text,
  `resume_cv` int(11) DEFAULT NULL,
  `resume_cv_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resume_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_music_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `item_file` int(11) DEFAULT NULL,
  `item_file_file` varchar(255) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_news_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_date` int(11) DEFAULT NULL,
  `item_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_urltitle` varchar(255) DEFAULT NULL,
  `item_body` text,
  `item_main_title` varchar(255) NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_portfolio_cats` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `cat_title` varchar(255) DEFAULT NULL,
  `cat_url` varchar(255) DEFAULT NULL,
  `cat_urltitle` varchar(255) DEFAULT NULL,
  `cat_content_title` varchar(255) DEFAULT NULL,
  `cat_image` int(11) DEFAULT NULL,
  `cat_image_file` varchar(255) DEFAULT NULL,
  `cat_description` text,
  PRIMARY KEY (`cat_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_portfolio_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `item_project` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_image_large` int(11) DEFAULT NULL,
  `item_image_large_file` int(11) DEFAULT NULL,
  `item_video` int(11) DEFAULT NULL,
  `item_video_file` varchar(255) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_urltitle` varchar(255) DEFAULT NULL,
  `item_description` text,
  `item_pan` int(1) NOT NULL,
  `item_pan_max_width` int(11) NOT NULL,
  `item_pan_max_height` int(11) NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_portfolio_projects` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_order` int(11) DEFAULT NULL,
  `project_date` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `project_cat` int(11) DEFAULT NULL,
  `project_title` varchar(255) DEFAULT NULL,
  `project_url` varchar(255) DEFAULT NULL,
  `project_url_title` varchar(255) DEFAULT NULL,
  `project_details_title` varchar(255) DEFAULT NULL,
  `project_description` text,
  `project_image` int(1) DEFAULT NULL,
  `project_image_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`project_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_services_cats` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_order` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `cat_title` varchar(255) DEFAULT NULL,
  `cat_url` varchar(255) DEFAULT NULL,
  `cat_urltitle` varchar(255) DEFAULT NULL,
  `cat_content_title` varchar(255) DEFAULT NULL,
  `cat_description` text,
  PRIMARY KEY (`cat_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `site_oxymall_plugin_services_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_order` int(11) DEFAULT NULL,
  `item_cat` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `item_image` int(11) DEFAULT NULL,
  `item_image_file` varchar(255) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_url` varchar(255) DEFAULT NULL,
  `item_urltitle` varchar(255) DEFAULT NULL,
  `item_description` text,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `site_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_key` varchar(32) DEFAULT NULL,
  `user_first_name` varchar(200) DEFAULT NULL,
  `user_last_name` varchar(200) DEFAULT NULL,
  `user_login` varchar(200) NOT NULL,
  `user_password` varchar(200) DEFAULT NULL,
  `user_email` varchar(200) DEFAULT NULL,
  `user_level` int(1) NOT NULL DEFAULT '1',
  `user_protect_delete` int(1) NOT NULL DEFAULT '0',
  `user_protect_edit` int(1) NOT NULL DEFAULT '0',
  `user_log_last_login` int(11) NOT NULL DEFAULT '0',
  `user_log_last_ip` varchar(200) DEFAULT NULL,
  `user_log_create` int(11) NOT NULL DEFAULT '0',
  `user_log_tries` int(2) NOT NULL DEFAULT '0',
  `user_log_image_text` varchar(50) DEFAULT NULL,
  `user_log_status` int(1) NOT NULL DEFAULT '0',
  `user_contact_phone` varchar(20) DEFAULT NULL,
  `user_contact_phone2` varchar(20) DEFAULT NULL,
  `user_contact_phone3` varchar(20) DEFAULT NULL,
  `user_contact_addr` text,
  `user_contact_city` varchar(50) DEFAULT NULL,
  `user_contact_state` varchar(100) DEFAULT NULL,
  `user_contact_zip` varchar(20) DEFAULT NULL,
  `user_contact_country` char(3) DEFAULT NULL,
  `user_perm` text NOT NULL,
  PRIMARY KEY (`user_id`),
  FULLTEXT KEY `user_login` (`user_login`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `site_users`
--

INSERT INTO `site_users` (`user_id`, `user_key`, `user_first_name`, `user_last_name`, `user_login`, `user_password`, `user_email`, `user_level`, `user_protect_delete`, `user_protect_edit`, `user_log_last_login`, `user_log_last_ip`, `user_log_create`, `user_log_tries`, `user_log_image_text`, `user_log_status`, `user_contact_phone`, `user_contact_phone2`, `user_contact_phone3`, `user_contact_addr`, `user_contact_city`, `user_contact_state`, `user_contact_zip`, `user_contact_country`, `user_perm`) VALUES(10, '', 'Administrator', '', 'admin', '098f6bcd4621d373cade4e832627b4f6', 'admin@oxylusflash.com', 0, 0, 0, 1255690370, '127.0.0.1', 1195125259, 0, '', 0, '', '', '', '', '', '', '', '', '');
