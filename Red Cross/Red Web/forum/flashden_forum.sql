-- phpMyAdmin SQL Dump
-- version 2.11.4
-- http://www.phpmyadmin.net
--
-- Gostitelj: localhost
-- Èas nastanka: 24 Mar 2008 ob 09:34 PM
-- Razlièica strežnika: 5.0.51
-- Razlièica PHP: 5.2.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Podatkovna baza: `flashden_forum`
--

-- --------------------------------------------------------

--
-- Struktura tabele `forum`
--

CREATE TABLE IF NOT EXISTS `forum` (
  `id` int(11) NOT NULL,
  `threads` varchar(255) NOT NULL default '0',
  `w` varchar(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Odloži podatke za tabelo `forum`
--

INSERT INTO `forum` (`id`, `threads`, `w`) VALUES
(1, '0', '0'),
(2, '1', '0'),
(3, '1', '0'),
(4, '1', '0'),
(5, '1', '0'),
(6, '1', '0');

-- --------------------------------------------------------

--
-- Struktura tabele `forum_posts`
--

CREATE TABLE IF NOT EXISTS `forum_posts` (
  `thread_id` int(11) NOT NULL default '1',
  `author` varchar(255) NOT NULL,
  `post_time` varchar(255) NOT NULL,
  `vsebina` varchar(1024) character set latin1 collate latin1_general_cs NOT NULL,
  `id` int(11) NOT NULL auto_increment,
  `forumId` int(11) NOT NULL default '1',
  `site` varchar(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=313 ;

--
-- Odloži podatke za tabelo `forum_posts`
--

INSERT INTO `forum_posts` (`thread_id`, `author`, `post_time`, `vsebina`, `id`, `forumId`, `site`) VALUES
(1, 'test', '24 March 2008', 'flashbox is....', 285, 1, '0'),
(1, 'uros', '24 March 2008', 'www', 286, 2, '0'),
(1, 'uros', '24 March 2008', 'help', 287, 3, '0'),
(1, 'uros', '24 March 2008', 'Flash', 288, 4, '0'),
(1, 'uros', '24 March 2008', '', 289, 5, '0'),
(1, 'uros', '24 March 2008', '', 290, 6, '0');

-- --------------------------------------------------------

--
-- Struktura tabele `forum_threads`
--

CREATE TABLE IF NOT EXISTS `forum_threads` (
  `forum_id` int(11) NOT NULL,
  `thread_id` varchar(255) NOT NULL default '1',
  `posts_number` int(11) NOT NULL,
  `last_post` varchar(255) NOT NULL,
  `post_title` varchar(255) NOT NULL,
  `reply_number` int(11) NOT NULL,
  `last_user` varchar(255) NOT NULL,
  `last_post_time` varchar(255) NOT NULL,
  `vsebina` varchar(1500) character set ascii NOT NULL,
  `author` varchar(255) NOT NULL,
  `post_time` varchar(255) NOT NULL,
  `site` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

--
-- Odloži podatke za tabelo `forum_threads`
--

INSERT INTO `forum_threads` (`forum_id`, `thread_id`, `posts_number`, `last_post`, `post_title`, `reply_number`, `last_user`, `last_post_time`, `vsebina`, `author`, `post_time`, `site`, `id`) VALUES
(1, '1', 0, '0', 'Welcome to the FlashForum!', 0, '0', '0', 'Welcome to the FlashForum!', 'uros', '24 March 2008', 0, 1),
(2, '1', 0, '0', 'ww', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 26),
(3, '1', 0, '0', 'Forum help', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 27),
(4, '1', 0, '0', 'Flash debate', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 28),
(5, '1', 0, '0', 'What you need', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 29),
(6, '1', 3, '0', 'Anything', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 30),
(1, '3', 0, '0', '3', 0, '0', '0', 'Zbri??i ta stolpec', 'uros', '24 March 2008', 0, 31);

-- --------------------------------------------------------

--
-- Struktura tabele `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `user_level` varchar(255) NOT NULL default 'user',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=8 ;

--
-- Odloži podatke za tabelo `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `user_level`) VALUES
(7, 'admin', '200ceb26807d6bf99fd6f4f0d1ca54d4', 'admin@admin.com', 'admin');

-- --------------------------------------------------------

--
-- Struktura tabele `users_stats`
--

CREATE TABLE IF NOT EXISTS `users_stats` (
  `username` varchar(255) NOT NULL,
  `posts` varchar(255) NOT NULL default '0',
  `avatar` varchar(255) NOT NULL default 'default.bmp',
  PRIMARY KEY  (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2;

--
-- Odloži podatke za tabelo `users_stats`
--

INSERT INTO `users_stats` (`username`, `posts`, `avatar`) VALUES
('admin', '0', 'default.bmp');
