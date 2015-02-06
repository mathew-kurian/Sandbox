CREATE TABLE `member` (
  `id` int(4) unsigned zerofill NOT NULL auto_increment,
  `username` text collate latin1_general_ci,
  `password` text collate latin1_general_ci,
  `email` text collate latin1_general_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1 ;

