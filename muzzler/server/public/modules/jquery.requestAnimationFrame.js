  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>jquery-requestAnimationFrame/src/jquery.requestAnimationFrame.js at master · gnarf37/jquery-requestAnimationFrame · GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="http://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <link rel="xhr-socket" href="/_sockets" />


    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="jUbToEsFIb+eZ88MMtboUfIjT0lep4QJm+b1wfTSW60=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/assets/github-f1b15586bc7135fa37ec5f848fbde916e7041f23.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/assets/github2-749329f6bc4f0f2842535f983d87bfdf7d109c41.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://a248.e.akamai.net/assets.github.com/assets/frameworks-92d138f450f2960501e28397a2f63b0f100590f0.js" type="text/javascript"></script>
      <script src="https://a248.e.akamai.net/assets.github.com/assets/github-bc374985e8441015fc645eca5b08988b6eadc695.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="e19b657653c304732a1ecdfa62d57114">

        <link data-pjax-transient rel='permalink' href='/gnarf37/jquery-requestAnimationFrame/blob/85a4ffffae9225c5e08c768aeadcaaa53eabdcbe/src/jquery.requestAnimationFrame.js'>
    <meta property="og:title" content="jquery-requestAnimationFrame"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/gnarf37/jquery-requestAnimationFrame"/>
    <meta property="og:image" content="https://secure.gravatar.com/avatar/de31e75f0b6f31344cc18e2a15c2f1c9?s=420&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="jquery-requestAnimationFrame - Replaces the standard jQuery timer loop with requestAnimationFrame where supported.  Requires jQuery 1.8"/>
    <meta property="twitter:card" content="summary"/>
    <meta property="twitter:site" content="@GitHub">
    <meta property="twitter:title" content="gnarf37/jquery-requestAnimationFrame"/>

    <meta name="description" content="jquery-requestAnimationFrame - Replaces the standard jQuery timer loop with requestAnimationFrame where supported.  Requires jQuery 1.8" />

  <link href="https://github.com/gnarf37/jquery-requestAnimationFrame/commits/master.atom" rel="alternate" title="Recent Commits to jquery-requestAnimationFrame:master" type="application/atom+xml" />

  </head>


  <body class="logged_out page-blob windows vis-public env-production  ">
    <div id="wrapper">

      

      
      
      

      
      <div class="header header-logged-out">
  <div class="container clearfix">

      <a class="header-logo-wordmark" href="https://github.com/">Github</a>

    <div class="header-actions">
        <a class="button primary" href="https://github.com/signup">Sign up for free</a>
      <a class="button" href="https://github.com/login?return_to=%2Fgnarf37%2Fjquery-requestAnimationFrame%2Fblob%2Fmaster%2Fsrc%2Fjquery.requestAnimationFrame.js">Sign in</a>
    </div>

      <ul class="top-nav">
          <li class="explore"><a href="https://github.com/explore">Explore GitHub</a></li>
        <li class="search"><a href="https://github.com/search">Search</a></li>
        <li class="features"><a href="https://github.com/features">Features</a></li>
          <li class="blog"><a href="https://github.com/blog">Blog</a></li>
      </ul>

  </div>
</div>


      

      


            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="hentry">
        
        <div class="pagehead repohead instapaper_ignore readability-menu ">
          <div class="container">
            <div class="title-actions-bar">
              

<ul class="pagehead-actions">



    <li>
      <a href="/login?return_to=%2Fgnarf37%2Fjquery-requestAnimationFrame"
        class="minibutton js-toggler-target star-button entice tooltipped upwards"
        title="You must be signed in to use this feature" rel="nofollow">
        <span class="mini-icon mini-icon-star"></span>Star
      </a>
      <a class="social-count js-social-count" href="/gnarf37/jquery-requestAnimationFrame/stargazers">
        95
      </a>
    </li>
    <li>
      <a href="/login?return_to=%2Fgnarf37%2Fjquery-requestAnimationFrame"
        class="minibutton js-toggler-target fork-button entice tooltipped upwards"
        title="You must be signed in to fork a repository" rel="nofollow">
        <span class="mini-icon mini-icon-fork"></span>Fork
      </a>
      <a href="/gnarf37/jquery-requestAnimationFrame/network" class="social-count">
        8
      </a>
    </li>
</ul>

              <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
                <span class="repo-label"><span>public</span></span>
                <span class="mega-icon mega-icon-public-repo"></span>
                <span class="author vcard">
                  <a href="/gnarf37" class="url fn" itemprop="url" rel="author">
                  <span itemprop="title">gnarf37</span>
                  </a></span> /
                <strong><a href="/gnarf37/jquery-requestAnimationFrame" class="js-current-repository">jquery-requestAnimationFrame</a></strong>
              </h1>
            </div>

            
  <ul class="tabs">
    <li class="pulse-nav"><a href="/gnarf37/jquery-requestAnimationFrame/pulse" class="js-selected-navigation-item " data-selected-links="pulse /gnarf37/jquery-requestAnimationFrame/pulse" rel="nofollow"><span class="mini-icon mini-icon-pulse"></span></a></li>
    <li><a href="/gnarf37/jquery-requestAnimationFrame" class="js-selected-navigation-item selected" data-selected-links="repo_source repo_downloads repo_commits repo_tags repo_branches /gnarf37/jquery-requestAnimationFrame">Code</a></li>
    <li><a href="/gnarf37/jquery-requestAnimationFrame/network" class="js-selected-navigation-item " data-selected-links="repo_network /gnarf37/jquery-requestAnimationFrame/network">Network</a></li>
    <li><a href="/gnarf37/jquery-requestAnimationFrame/pulls" class="js-selected-navigation-item " data-selected-links="repo_pulls /gnarf37/jquery-requestAnimationFrame/pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/gnarf37/jquery-requestAnimationFrame/issues" class="js-selected-navigation-item " data-selected-links="repo_issues /gnarf37/jquery-requestAnimationFrame/issues">Issues <span class='counter'>0</span></a></li>



    <li><a href="/gnarf37/jquery-requestAnimationFrame/graphs" class="js-selected-navigation-item " data-selected-links="repo_graphs repo_contributors /gnarf37/jquery-requestAnimationFrame/graphs">Graphs</a></li>


  </ul>
  
<div class="tabnav">

  <span class="tabnav-right">
    <ul class="tabnav-tabs">
          <li><a href="/gnarf37/jquery-requestAnimationFrame/tags" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_tags /gnarf37/jquery-requestAnimationFrame/tags">Tags <span class="counter ">3</span></a></li>
    </ul>
    
  </span>

  <div class="tabnav-widget scope">


    <div class="select-menu js-menu-container js-select-menu js-branch-menu">
      <a class="minibutton select-menu-button js-menu-target" data-hotkey="w" data-ref="master">
        <span class="mini-icon mini-icon-branch"></span>
        <i>branch:</i>
        <span class="js-select-button">master</span>
      </a>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">

        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Switch branches/tags</span>
            <span class="mini-icon mini-icon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-filters">
            <div class="select-menu-text-filter">
              <input type="text" id="commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
            </div>
            <div class="select-menu-tabs">
              <ul>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
                </li>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
                </li>
              </ul>
            </div><!-- /.select-menu-tabs -->
          </div><!-- /.select-menu-filters -->

          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="branches">

            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item selected">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/gnarf37/jquery-requestAnimationFrame/blob/master/src/jquery.requestAnimationFrame.js" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <div class="select-menu-no-results">Nothing to show</div>
          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/gnarf37/jquery-requestAnimationFrame/blob/0.1.2/src/jquery.requestAnimationFrame.js" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="0.1.2" rel="nofollow" title="0.1.2">0.1.2</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/gnarf37/jquery-requestAnimationFrame/blob/0.1.1/src/jquery.requestAnimationFrame.js" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="0.1.1" rel="nofollow" title="0.1.1">0.1.1</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/gnarf37/jquery-requestAnimationFrame/blob/0.1.0/src/jquery.requestAnimationFrame.js" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="0.1.0" rel="nofollow" title="0.1.0">0.1.0</a>
                </div> <!-- /.select-menu-item -->
            </div>

            <div class="select-menu-no-results">Nothing to show</div>

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

  </div> <!-- /.scope -->

  <ul class="tabnav-tabs">
    <li><a href="/gnarf37/jquery-requestAnimationFrame" class="selected js-selected-navigation-item tabnav-tab" data-selected-links="repo_source /gnarf37/jquery-requestAnimationFrame">Files</a></li>
    <li><a href="/gnarf37/jquery-requestAnimationFrame/commits/master" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_commits /gnarf37/jquery-requestAnimationFrame/commits/master">Commits</a></li>
    <li><a href="/gnarf37/jquery-requestAnimationFrame/branches" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_branches /gnarf37/jquery-requestAnimationFrame/branches" rel="nofollow">Branches <span class="counter ">1</span></a></li>
  </ul>

</div>

  
  
  


            
          </div>
        </div><!-- /.repohead -->

        <div id="js-repo-pjax-container" class="container context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:916384814259428f9a8b8d26242eefd3 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:916384814259428f9a8b8d26242eefd3 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/gnarf37/jquery-requestAnimationFrame" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">jquery-requestAnimationFrame</span></a></span></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/gnarf37/jquery-requestAnimationFrame/tree/master/src" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">src</span></a></span><span class="separator"> / </span><strong class="final-path">jquery.requestAnimationFrame.js</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="src/jquery.requestAnimationFrame.js" data-copied-hint="copied!" title="copy to clipboard"><span class="mini-icon mini-icon-clipboard"></span></span>
        </div>

      <a href="/gnarf37/jquery-requestAnimationFrame/find/master" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/72ea0622f7b690ed82f5261b16ff8cef?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/mzgol" rel="author">mzgol</a></span>
    <time class="js-relative-date" datetime="2013-04-15T08:25:44-07:00" title="2013-04-15 08:25:44">April 15, 2013</time>
    <div class="commit-title">
        <a href="/gnarf37/jquery-requestAnimationFrame/commit/6b15a293cec59e8f27acda13966c710afb9d69df" class="message">removed 'o' prefix; it hasn't been implemented and it'll never be</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>3</strong> contributors</a></p>
          <a class="avatar tooltipped downwards" title="gnarf37" href="/gnarf37/jquery-requestAnimationFrame/commits/master/src/jquery.requestAnimationFrame.js?author=gnarf37"><img height="20" src="https://secure.gravatar.com/avatar/de31e75f0b6f31344cc18e2a15c2f1c9?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="mzgol" href="/gnarf37/jquery-requestAnimationFrame/commits/master/src/jquery.requestAnimationFrame.js?author=mzgol"><img height="20" src="https://secure.gravatar.com/avatar/72ea0622f7b690ed82f5261b16ff8cef?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="paulirish" href="/gnarf37/jquery-requestAnimationFrame/commits/master/src/jquery.requestAnimationFrame.js?author=paulirish"><img height="20" src="https://secure.gravatar.com/avatar/ffe68d6f71b225f7661d33f2a8908281?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>


    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/de31e75f0b6f31344cc18e2a15c2f1c9?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/gnarf37">gnarf37</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/72ea0622f7b690ed82f5261b16ff8cef?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/mzgol">mzgol</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/ffe68d6f71b225f7661d33f2a8908281?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/paulirish">paulirish</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/gnarf37/jquery-requestAnimationFrame/blob/85a4ffffae9225c5e08c768aeadcaaa53eabdcbe/src/jquery.requestAnimationFrame.js" data-title="jquery-requestAnimationFrame/src/jquery.requestAnimationFrame.js at master · gnarf37/jquery-requestAnimationFrame · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="mini-icon mini-icon-text-file"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>71 lines (59 sloc)</span>
                <span>1.851 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                      <a class="minibutton js-entice" href=""
                         data-entice="You must be signed in and on a branch to make or propose changes">Edit</a>
                  <a href="/gnarf37/jquery-requestAnimationFrame/raw/master/src/jquery.requestAnimationFrame.js" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/gnarf37/jquery-requestAnimationFrame/blame/master/src/jquery.requestAnimationFrame.js" class="button minibutton ">Blame</a>
                  <a href="/gnarf37/jquery-requestAnimationFrame/commits/master/src/jquery.requestAnimationFrame.js" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="blob-wrapper data type-javascript js-blob-data">
      <table class="file-code file-diff">
        <tr class="file-code-line">
          <td class="blob-line-nums">
            <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>

          </td>
          <td class="blob-line-code">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="cm">/*</span></div><div class='line' id='LC2'><span class="cm"> * jquery.requestAnimationFrame</span></div><div class='line' id='LC3'><span class="cm"> * https://github.com/gnarf37/jquery-requestAnimationFrame</span></div><div class='line' id='LC4'><span class="cm"> * Requires jQuery 1.8+</span></div><div class='line' id='LC5'><span class="cm"> *</span></div><div class='line' id='LC6'><span class="cm"> * Copyright (c) 2012 Corey Frang</span></div><div class='line' id='LC7'><span class="cm"> * Licensed under the MIT license.</span></div><div class='line' id='LC8'><span class="cm"> */</span></div><div class='line' id='LC9'><br/></div><div class='line' id='LC10'><span class="p">(</span><span class="kd">function</span><span class="p">(</span> <span class="nx">$</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC11'><br/></div><div class='line' id='LC12'><span class="c1">// requestAnimationFrame polyfill adapted from Erik Möller</span></div><div class='line' id='LC13'><span class="c1">// fixes from Paul Irish and Tino Zijdel</span></div><div class='line' id='LC14'><span class="c1">// http://paulirish.com/2011/requestanimationframe-for-smart-animating/</span></div><div class='line' id='LC15'><span class="c1">// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating</span></div><div class='line' id='LC16'><br/></div><div class='line' id='LC17'><br/></div><div class='line' id='LC18'><span class="kd">var</span> <span class="nx">animating</span><span class="p">,</span></div><div class='line' id='LC19'>	<span class="nx">lastTime</span> <span class="o">=</span> <span class="mi">0</span><span class="p">,</span></div><div class='line' id='LC20'>	<span class="nx">vendors</span> <span class="o">=</span> <span class="p">[</span><span class="s1">&#39;webkit&#39;</span><span class="p">,</span> <span class="s1">&#39;moz&#39;</span><span class="p">],</span></div><div class='line' id='LC21'>	<span class="nx">requestAnimationFrame</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">requestAnimationFrame</span><span class="p">,</span></div><div class='line' id='LC22'>	<span class="nx">cancelAnimationFrame</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">cancelAnimationFrame</span><span class="p">;</span></div><div class='line' id='LC23'><br/></div><div class='line' id='LC24'><span class="k">for</span><span class="p">(;</span> <span class="nx">lastTime</span> <span class="o">&lt;</span> <span class="nx">vendors</span><span class="p">.</span><span class="nx">length</span> <span class="o">&amp;&amp;</span> <span class="o">!</span><span class="nx">requestAnimationFrame</span><span class="p">;</span> <span class="nx">lastTime</span><span class="o">++</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC25'>	<span class="nx">requestAnimationFrame</span> <span class="o">=</span> <span class="nb">window</span><span class="p">[</span> <span class="nx">vendors</span><span class="p">[</span><span class="nx">lastTime</span><span class="p">]</span> <span class="o">+</span> <span class="s2">&quot;RequestAnimationFrame&quot;</span> <span class="p">];</span></div><div class='line' id='LC26'>	<span class="nx">cancelAnimationFrame</span> <span class="o">=</span> <span class="nx">cancelAnimationFrame</span> <span class="o">||</span></div><div class='line' id='LC27'>		<span class="nb">window</span><span class="p">[</span> <span class="nx">vendors</span><span class="p">[</span><span class="nx">lastTime</span><span class="p">]</span> <span class="o">+</span> <span class="s2">&quot;CancelAnimationFrame&quot;</span> <span class="p">]</span> <span class="o">||</span> </div><div class='line' id='LC28'>		<span class="nb">window</span><span class="p">[</span> <span class="nx">vendors</span><span class="p">[</span><span class="nx">lastTime</span><span class="p">]</span> <span class="o">+</span> <span class="s2">&quot;CancelRequestAnimationFrame&quot;</span> <span class="p">];</span></div><div class='line' id='LC29'><span class="p">}</span></div><div class='line' id='LC30'><br/></div><div class='line' id='LC31'><span class="kd">function</span> <span class="nx">raf</span><span class="p">()</span> <span class="p">{</span></div><div class='line' id='LC32'>	<span class="k">if</span> <span class="p">(</span> <span class="nx">animating</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC33'>		<span class="nx">requestAnimationFrame</span><span class="p">(</span> <span class="nx">raf</span> <span class="p">);</span></div><div class='line' id='LC34'>		<span class="nx">jQuery</span><span class="p">.</span><span class="nx">fx</span><span class="p">.</span><span class="nx">tick</span><span class="p">();</span></div><div class='line' id='LC35'>	<span class="p">}</span></div><div class='line' id='LC36'><span class="p">}</span></div><div class='line' id='LC37'><br/></div><div class='line' id='LC38'><span class="k">if</span> <span class="p">(</span> <span class="nx">requestAnimationFrame</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC39'>	<span class="c1">// use rAF</span></div><div class='line' id='LC40'>	<span class="nb">window</span><span class="p">.</span><span class="nx">requestAnimationFrame</span> <span class="o">=</span> <span class="nx">requestAnimationFrame</span><span class="p">;</span></div><div class='line' id='LC41'>	<span class="nb">window</span><span class="p">.</span><span class="nx">cancelAnimationFrame</span> <span class="o">=</span> <span class="nx">cancelAnimationFrame</span><span class="p">;</span></div><div class='line' id='LC42'>	<span class="nx">jQuery</span><span class="p">.</span><span class="nx">fx</span><span class="p">.</span><span class="nx">timer</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(</span> <span class="nx">timer</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC43'>		<span class="k">if</span> <span class="p">(</span> <span class="nx">timer</span><span class="p">()</span> <span class="o">&amp;&amp;</span> <span class="nx">jQuery</span><span class="p">.</span><span class="nx">timers</span><span class="p">.</span><span class="nx">push</span><span class="p">(</span> <span class="nx">timer</span> <span class="p">)</span> <span class="o">&amp;&amp;</span> <span class="o">!</span><span class="nx">animating</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC44'>			<span class="nx">animating</span> <span class="o">=</span> <span class="kc">true</span><span class="p">;</span></div><div class='line' id='LC45'>			<span class="nx">raf</span><span class="p">();</span></div><div class='line' id='LC46'>		<span class="p">}</span></div><div class='line' id='LC47'>	<span class="p">};</span></div><div class='line' id='LC48'><br/></div><div class='line' id='LC49'>	<span class="nx">jQuery</span><span class="p">.</span><span class="nx">fx</span><span class="p">.</span><span class="nx">stop</span> <span class="o">=</span> <span class="kd">function</span><span class="p">()</span> <span class="p">{</span></div><div class='line' id='LC50'>		<span class="nx">animating</span> <span class="o">=</span> <span class="kc">false</span><span class="p">;</span></div><div class='line' id='LC51'>	<span class="p">};</span></div><div class='line' id='LC52'><span class="p">}</span> <span class="k">else</span> <span class="p">{</span></div><div class='line' id='LC53'>	<span class="c1">// polyfill</span></div><div class='line' id='LC54'>	<span class="nb">window</span><span class="p">.</span><span class="nx">requestAnimationFrame</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(</span> <span class="nx">callback</span><span class="p">,</span> <span class="nx">element</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC55'>		<span class="kd">var</span> <span class="nx">currTime</span> <span class="o">=</span> <span class="k">new</span> <span class="nb">Date</span><span class="p">().</span><span class="nx">getTime</span><span class="p">(),</span></div><div class='line' id='LC56'>			<span class="nx">timeToCall</span> <span class="o">=</span> <span class="nb">Math</span><span class="p">.</span><span class="nx">max</span><span class="p">(</span> <span class="mi">0</span><span class="p">,</span> <span class="mi">16</span> <span class="o">-</span> <span class="p">(</span> <span class="nx">currTime</span> <span class="o">-</span> <span class="nx">lastTime</span> <span class="p">)</span> <span class="p">),</span></div><div class='line' id='LC57'>			<span class="nx">id</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">setTimeout</span><span class="p">(</span> <span class="kd">function</span><span class="p">()</span> <span class="p">{</span></div><div class='line' id='LC58'>				<span class="nx">callback</span><span class="p">(</span> <span class="nx">currTime</span> <span class="o">+</span> <span class="nx">timeToCall</span> <span class="p">);</span></div><div class='line' id='LC59'>			<span class="p">},</span> <span class="nx">timeToCall</span> <span class="p">);</span></div><div class='line' id='LC60'>		<span class="nx">lastTime</span> <span class="o">=</span> <span class="nx">currTime</span> <span class="o">+</span> <span class="nx">timeToCall</span><span class="p">;</span></div><div class='line' id='LC61'>		<span class="k">return</span> <span class="nx">id</span><span class="p">;</span></div><div class='line' id='LC62'>	<span class="p">};</span></div><div class='line' id='LC63'><br/></div><div class='line' id='LC64'>	<span class="nb">window</span><span class="p">.</span><span class="nx">cancelAnimationFrame</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(</span><span class="nx">id</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC65'>		<span class="nx">clearTimeout</span><span class="p">(</span><span class="nx">id</span><span class="p">);</span></div><div class='line' id='LC66'>	<span class="p">};</span></div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC68'><span class="p">}</span></div><div class='line' id='LC69'><br/></div><div class='line' id='LC70'><span class="p">}(</span> <span class="nx">jQuery</span> <span class="p">));</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>

        <a href="#jump-to-line" rel="facebox" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
        <div id="jump-to-line" style="display:none">
          <h2>Jump to Line</h2>
          <form accept-charset="UTF-8" class="js-jump-to-line-form">
            <input class="textfield js-jump-to-line-field" type="text">
            <div class="full-button">
              <button type="submit" class="button">Go</button>
            </div>
          </form>
        </div>

      </div>
    </div>
</div>

<div id="js-frame-loading-template" class="frame frame-loading large-loading-area" style="display:none;">
  <img class="js-frame-loading-spinner" src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-128.gif?1359500886" height="64" width="64">
</div>


        </div>
      </div>
      <div class="context-overlay"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer">
  <div class="container clearfix">

      <dl class="footer_nav">
        <dt>GitHub</dt>
        <dd><a href="https://github.com/about">About us</a></dd>
        <dd><a href="https://github.com/blog">Blog</a></dd>
        <dd><a href="https://github.com/contact">Contact &amp; support</a></dd>
        <dd><a href="http://enterprise.github.com/">GitHub Enterprise</a></dd>
        <dd><a href="http://status.github.com/">Site status</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Applications</dt>
        <dd><a href="http://mac.github.com/">GitHub for Mac</a></dd>
        <dd><a href="http://windows.github.com/">GitHub for Windows</a></dd>
        <dd><a href="http://eclipse.github.com/">GitHub for Eclipse</a></dd>
        <dd><a href="http://mobile.github.com/">GitHub mobile apps</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Services</dt>
        <dd><a href="http://get.gaug.es/">Gauges: Web analytics</a></dd>
        <dd><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></dd>
        <dd><a href="https://gist.github.com">Gist: Code snippets</a></dd>
        <dd><a href="http://jobs.github.com/">Job board</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Documentation</dt>
        <dd><a href="http://help.github.com/">GitHub Help</a></dd>
        <dd><a href="http://developer.github.com/">Developer API</a></dd>
        <dd><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></dd>
        <dd><a href="http://pages.github.com/">GitHub Pages</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>More</dt>
        <dd><a href="http://training.github.com/">Training</a></dd>
        <dd><a href="https://github.com/edu">Students &amp; teachers</a></dd>
        <dd><a href="http://shop.github.com">The Shop</a></dd>
        <dd><a href="/plans">Plans &amp; pricing</a></dd>
        <dd><a href="http://octodex.github.com/">The Octodex</a></dd>
      </dl>

      <hr class="footer-divider">


    <p class="right">&copy; 2013 <span title="0.03664s from fe19.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
    <a class="left" href="https://github.com/">
      <span class="mega-icon mega-icon-invertocat"></span>
    </a>
    <ul id="legal">
        <li><a href="https://github.com/site/terms">Terms of Service</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
    </ul>

  </div><!-- /.container -->

</div><!-- /.#footer -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/gnarf37/jquery-requestAnimationFrame/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-icon mega-icon-normalscreen"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="mini-icon mini-icon-brightness"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="mini-icon mini-icon-exclamation"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="mini-icon mini-icon-remove-close ajax-error-dismiss"></a>
    </div>

    
    
    <span id='server_response_time' data-time='0.03705' data-host='fe19'></span>
    
  </body>
</html>

