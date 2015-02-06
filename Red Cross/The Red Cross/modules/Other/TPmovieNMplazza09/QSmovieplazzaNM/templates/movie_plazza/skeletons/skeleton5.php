<?php defined('_JEXEC') or die('Restricted access');
/* 
=================================================
# Filename : skeleton5.php
# Description : Template Skeleton Type 5
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.

=================================================
*/
?>
<jdoc:include type="message" />
<div id="tpwrapper-global" align="center">
	<div id="tpwrapper-page">  

		<div id="tpwrapper-page-inner">
        <!-- ======= BLOCK HEAD  ======= -->
        <div id="tpblock-head" align="center">
           	<div class="tpblock-head-inner" align="center">
           	   <div id="tpdiv-logo"><h1><a href="<?php JURI :: base(); ?>"><?php echo $this->fw->params->get('tp_logotext'); ?></a></h1></div>
	               <div id="tpmod-banner">
                    <jdoc:include type="modules" name="user4" style="<?php echo $xhtml; ?>" />
                    </div>
                    <div class="clrfix"></div>
                    <!-- ======= BLOCK TPMENU  ======= -->
                   		<?php
                   		if($this->fw->params->get('tp_menustyle') == "none")
                   			{
               				if($tp->user8) : ?>
               				<div id="tpblock-tpmenu">
               					<div id="tpmod-user8">
               						<?php $xhtml = ($this->loadModuleCufon('tpblock-tpmenu')) ? 'xhtmlcufontpmenu' : 'xhtmltpmenu'; ?>
                                        <jdoc:include type="modules" name="user8" style="<?php echo $xhtml; ?>" />
                                </div>
                                <div class="clrfix"></div>
                            </div>
                            <?php endif;
                      		}
                            else
                            {
                            ?>
                        <div id="tpblock-tpmenu">
                            <div id="tpmod-user8">
                            <?php $this->tpmenu(); ?>
                            </div>
                            <div class="clrfix"></div>
                        </div>
                     <?php
                    }
                    ?>  
                </div>
            </div> <!-- end of div #block-head -->
            <div id="tpmod-breadcrumb">
                <div class="tpmod-breadcrumb-inner">
                    <div class="tpmod-breadcrumb-inner-inner">
                    <jdoc:include type="modules" name="breadcrumb" style="raw" />
                    </div>
                </div>
            </div>
            
            <!-- ======= BLOCK TOPBODY  ======= -->

    			<?php if($tp->user1 || $tp->user2) : ?>
    			<div id="tpblock-topbody">
                    <div class="tpblock-topbody-inner">
        				<?php $xhtml = ($this->loadModuleCufon('tpblock-topbody')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
        				<?php if($tp->user1) : ?>
        				<div id="tpmod-user1"><jdoc:include type="modules" name="user1" style="<?php echo $xhtml; ?>" /></div>
        				<?php endif; ?>
        				<?php if($tp->user2) : ?>
        				<div id="tpmod-user2"><jdoc:include type="modules" name="user2" style="<?php echo $xhtml; ?>" /></div>
        				<?php endif; ?>
        				<div class="clrfix"></div>
                    </div>
    			</div><!-- end of div #tpblock-topbody -->
    			<?php endif; ?>
        
		<div id="tpwrapper-right">
            <div id="tpwrapper-right-inner">
                <!-- ======= BLOCK TOP  ======= -->
                <?php if($tp->user11 || $tp->user12 || $tp->user13 || $tp->user14) : ?>
                	<?php $xhtml = ($this->loadModuleCufon('tpblock-top')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
                	<?php if($this->fw->params->get('tp_blocktoptype') == 1): ?>
                		<div id="tpblock-top" align="center">
                			<div id="tpblock-top-inner" align="center">
                                <div id="tpblock-top-inner-inner">
                				<?php if($tp->user11) : ?>
                					<div id="tpmod-user11">
                					<?php if($this->checkmootabs('user11')) : ?>
                						<?php $this->mootabs('user11'); ?>
                					<?php else: ?>
                						<jdoc:include type="modules" name="user11" style="<?php echo $xhtml; ?>" />
                					<?php endif; ?>
                					</div>
                				<?php endif; ?>
                				<?php if($tp->user12) : ?>
                					<div id="tpmod-user12">
                					<?php if($this->checkmootabs('user12')) : ?>
                						<?php $this->mootabs('user12'); ?>
                					<?php else: ?>
                						<jdoc:include type="modules" name="user12" style="<?php echo $xhtml; ?>" />
                					<?php endif; ?>
                					</div>
                				<?php endif; ?>
                				<?php if($tp->user13) : ?>
                					<div id="tpmod-user13">
                					<?php if($this->checkmootabs('user13')) : ?>
                						<?php $this->mootabs('user13'); ?>
                					<?php else: ?>
                						<jdoc:include type="modules" name="user13" style="<?php echo $xhtml; ?>" />
                					<?php endif; ?>
                					</div>
                				<?php endif; ?>
                				<?php if($tp->user14) : ?>
                					<div id="tpmod-user14">
                					<?php if($this->checkmootabs('user14')) : ?>
                						<?php $this->mootabs('user14'); ?>
                					<?php else: ?>
                						<jdoc:include type="modules" name="user14" style="<?php echo $xhtml; ?>" />
                					<?php endif; ?>
                					</div>
                    			<?php endif; ?>
                				<div class="clrfix"></div>
                                </div>
                			</div>
                		</div> <!-- end of div #block-top -->
                	<?php else: ?>
                		<div id="tpblock-top">
                			<div id="tpblock-top-inner">
                                <div id="tpblock-top-inner-inner">    
                				<?php if($tp->user11 || $tp->user12) : ?>
                				<div id="tpblock-top-innerleft">
                					<?php if($tp->user11) : ?>
                						<div id="tpmod-user11">
                						<?php if($this->checkmootabs('user11')) : ?>
                							<?php $this->mootabs('user11'); ?>
                						<?php else: ?>
                							<jdoc:include type="modules" name="user11" style="<?php echo $xhtml; ?>" />
                						<?php endif; ?>
                					</div>
                					<?php endif; ?>
                					<?php if($tp->user12) : ?>
                						<div id="tpmod-user12">
                						<?php if($this->checkmootabs('user12')) : ?>
                							<?php $this->mootabs('user12'); ?>
                						<?php else: ?>
                							<jdoc:include type="modules" name="user12" style="<?php echo $xhtml; ?>" />
                						<?php endif; ?>
                						</div>
                					<?php endif; ?>
                				</div>
                				<?php endif; ?>
                				<?php if($tp->user13 || $tp->user14) : ?>
                				<div id="tpblock-top-innerright">
                					<?php if($tp->user13) : ?>
                						<div id="tpmod-user13">
                						<?php if($this->checkmootabs('user13')) : ?>
                							<?php $this->mootabs('user13'); ?>
                						<?php else: ?>
                							<jdoc:include type="modules" name="user13" style="<?php echo $xhtml; ?>" />
                						<?php endif; ?>
                						</div>
                					<?php endif; ?>
                					<?php if($tp->user14) : ?>
                					<div id="tpmod-user14">
                						<?php if($this->checkmootabs('user14')) : ?>
                							<?php $this->mootabs('user14'); ?>
                						<?php else: ?>
                							<jdoc:include type="modules" name="user14" style="<?php echo $xhtml; ?>" />
                						<?php endif; ?>
                						</div>
                					<?php endif; ?>
                				</div>
                				<?php endif; ?>
                				<div class="clrfix"></div>
                                </div>
                			</div>
                		</div> <!-- end of div #block-top -->
                	<?php endif; ?>
                <?php endif; ?>  
            
            
            
            
            
    			
    			<div id="tpwrapper-inner-left">
    				<?php if($tp->advert1 || $tp->advert2) : ?>
    				<!-- ======= BLOCK MIDTOPBODY  ======= -->
    				<div id="tpblock-midtopbody">
    					<?php $xhtml = ($this->loadModuleCufon('tpblock-midtopbody')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
    					<?php if($tp->advert1) : ?>
    					<div id="tpmod-advert1"><jdoc:include type="modules" name="advert1" style="<?php echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<?php if($tp->advert2) : ?>
    					<div id="tpmod-advert2"><jdoc:include type="modules" name="advert2" style="<?php echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<div class="clrfix"></div>
    				</div><!-- end of div #tpblock-midtopbody -->
    				<?php endif; ?>
    					<!-- ======= BLOCK MAINBODY  ======= -->
    				<div id="tpblock-mainbody">
    					<jdoc:include type="component" />
    				</div>
    					<?php if($tp->advert3 || $tp->advert4) : ?>
    				<!-- ======= BLOCK MIDBOTBODY  ======= -->
    				<div id="tpblock-midbotbody">
    					<?php $xhtml = ($this->loadModuleCufon('tpblock-midbotbody')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
    					<?php if($tp->advert3) : ?>
    					<div id="tpmod-advert3"><jdoc:include type="modules" name="advert3" style="<? echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<?php if($tp->advert4) : ?>
    					<div id="tpmod-advert4"><jdoc:include type="modules" name="advert4" style="<? echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<div class="clrfix"></div>
    				</div><!-- end of div #tpblock-midbotbody -->
    				<?php endif; ?>
    					<?php if($tp->user5 || $tp->user6) : ?>
    				<!-- ======= BLOCK BOTTOMBODY  ======= -->
    				<div id="tpblock-botbody">
    					<?php $xhtml = ($this->loadModuleCufon('tpblock-botbody')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
    					<?php if($tp->user5) : ?>
    					<div id="tpmod-user5"><jdoc:include type="modules" name="user5" style="<?php echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<?php if($tp->user6) : ?>
    					<div id="tpmod-user6"><jdoc:include type="modules" name="user6" style="<?php echo $xhtml; ?>" /></div>
    					<?php endif; ?>
    					<div class="clrfix"></div>
    				</div><!-- end of div #tpblock-botbody -->
    				<?php endif; ?>
    				</div> 
    				<?php if($tp->right || $tp->afterright || $tp->beforeright) : ?>
    			<div id="tpwrapper-inner-right">
    				<!-- ======= BLOCK RIGHT  ======= -->
    				<?php if($this->checkaccordion('accblockright')) : ?>
    					<div id="tpmod-right">
    						<?php $xhtml = ($this->loadModuleCufon('tpblock-right')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
    						<jdoc:include type="modules" name="beforeright" style="<?php echo $xhtml; ?>" />
    						<?php $this->accordion($tp, array('right')); ?>
    						<jdoc:include type="modules" name="afterright" style="<?php echo $xhtml; ?>" />
    					</div>
    				<?php else: ?>
    					<?php $xhtml = ($this->loadModuleCufon('tpblock-right')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
    					<div id="tpmod-right">
    						<jdoc:include type="modules" name="beforeright" style="<?php echo $xhtml; ?>" />
    						<jdoc:include type="modules" name="right" style="<?php echo $xhtml; ?>" />
    						<jdoc:include type="modules" name="afterright" style="<?php echo $xhtml; ?>" />
    					</div>
    				<?php endif; ?>
    			</div>
    			<?php endif; ?>
    			
    			<div class="clrfix"></div>
            </div>
		</div> <!-- end of div #wrapper-right -->
		
		<?php if($tp->left || $tp->beforeleft || $tp->afterleft) : ?>
		<!-- ======= BLOCK LEFT  ======= -->
		<div id="tpblock-left">
			<?php if($this->checkaccordion('accblockleft')) : ?>
				<div id="tpmod-left">
					<?php $xhtml = ($this->loadModuleCufon('tpblock-left')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
					<jdoc:include type="modules" name="beforeleft" style="<?php echo $xhtml; ?>" />
					<?php $this->accordion($tp, array('left')); ?>
					<jdoc:include type="modules" name="afterleft" style="<?php echo $xhtml; ?>" />
				</div>
			<?php else: ?>
				<?php $xhtml = ($this->loadModuleCufon('tpblock-left')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
				<div id="tpmod-left">
					<jdoc:include type="modules" name="beforeleft" style="<?php echo $xhtml; ?>" />
					<jdoc:include type="modules" name="left" style="<?php echo $xhtml; ?>" />
					<jdoc:include type="modules" name="afterleft" style="<?php echo $xhtml; ?>" />
				</div>
			<?php endif; ?>
		</div> <!-- end of div #block-left -->
		<?php endif; ?>
			<div class="clrfix"></div>
		
		<!-- ======= BLOCK BOTTOM  ======= -->
		<?php if($tp->user21 || $tp->user22 || $tp->user23 || $tp->user24) : ?>
			<?php $xhtml = ($this->loadModuleCufon('tpblock-bot')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
			<?php if($this->fw->params->get('tp_blockbottype') == 1): ?>
				<div id="tpblock-bot">
					<?php if($tp->user21) : ?>
						<div id="tpmod-user21">
						<?php if($this->checkmootabs('user21')) : ?>
							<?php $this->mootabs('user21'); ?>
						<?php else: ?>
							<jdoc:include type="modules" name="user21" style="<?php echo $xhtml; ?>" />
						<?php endif; ?>
						</div>
					<?php endif; ?>
					<?php if($tp->user22) : ?>
						<div id="tpmod-user22">
						<?php if($this->checkmootabs('user22')) : ?>
							<?php $this->mootabs('user22'); ?>
						<?php else: ?>
							<jdoc:include type="modules" name="user22" style="<?php echo $xhtml; ?>" />
						<?php endif; ?>
						</div>
					<?php endif; ?>
					<?php if($tp->user23) : ?>
						<div id="tpmod-user23">
						<?php if($this->checkmootabs('user23')) : ?>
							<?php $this->mootabs('user23'); ?>
						<?php else: ?>
							<jdoc:include type="modules" name="user23" style="<?php echo $xhtml; ?>" />
						<?php endif; ?>
						</div>
					<?php endif; ?>
					<?php if($tp->user24) : ?>
						<div id="tpmod-user24">
						<?php if($this->checkmootabs('user24')) : ?>
							<?php $this->mootabs('user24'); ?>
						<?php else: ?>
							<jdoc:include type="modules" name="user24" style="<?php echo $xhtml; ?>" />
						<?php endif; ?>
						</div>
					<?php endif; ?>
					<div class="clrfix"></div>
				</div> <!-- end of div #block-bot -->
			<?php else: ?>
				<div id="tpblock-bot">
					<?php if($tp->user21 || $tp->user22) : ?>
					<div id="tpblock-bot-innerleft">
						<?php if($tp->user21) : ?>
							<div id="tpmod-user21">
							<?php if($this->checkmootabs('user21')) : ?>
								<?php $this->mootabs('user21'); ?>
							<?php else: ?>
								<jdoc:include type="modules" name="user21" style="<?php echo $xhtml; ?>" />
							<?php endif; ?>
							</div>
						<?php endif; ?>
						<?php if($tp->user22) : ?>
							<div id="tpmod-user22">
							<?php if($this->checkmootabs('user22')) : ?>
								<?php $this->mootabs('user22'); ?>
							<?php else: ?>
								<jdoc:include type="modules" name="user22" style="<?php echo $xhtml; ?>" />
							<?php endif; ?>
							</div>
						<?php endif; ?>
					</div>
					<?php endif; ?>
					<?php if($tp->user23 || $tp->user24) : ?>
					<div id="tpblock-bot-innerright">
						<?php if($tp->user23) : ?>
							<div id="tpmod-user23">
							<?php if($this->checkmootabs('user23')) : ?>
								<?php $this->mootabs('user23'); ?>
							<?php else: ?>
								<jdoc:include type="modules" name="user23" style="<?php echo $xhtml; ?>" />
							<?php endif; ?>
							</div>
						<?php endif; ?>
						<?php if($tp->user24) : ?>
							<div id="tpmod-user24">
							<?php if($this->checkmootabs('user24')) : ?>
								<?php $this->mootabs('user24'); ?>
							<?php else: ?>
								<jdoc:include type="modules" name="user24" style="<?php echo $xhtml; ?>" />
							<?php endif; ?>
							</div>
						<?php endif; ?>
					</div>
					<?php endif; ?>
					<div class="clrfix"></div>
				</div> <!-- end of div #block-bot -->
			<?php endif; ?>
		<?php endif; ?>
		</div><!-- end of div #tpwrapper-page-inner -->
			
	</div><!-- end of div #tpwrapper-page -->
</div><!-- end of div #tpwrapper-global -->
<div id="tpwrapper-footer-wrapper" align="center">
    <div id="tpwrapper-footer" align="center">
    <?php $xhtml = ($this->loadModuleCufon('tpblock-footer')) ? 'xhtmlcufon' : 'xhtmltp'; ?>
				<!-- ======= BLOCK FOOTERLEFT  ======= -->
        <div id="tpblock-footerleft">
            <div>
				<img src="templates/<?php echo $this->fw->template; ?>/images/logofooter2.png" alt="logo footer" border="0" class="pngfix" width="20" height="20" align="left" />
						Designed by TemplatePlazza - Shared at <a href="http://www.nemesismedias.com" target="_blank"><strong>Nemesismedias</strong></a>
            </div>
        </div>
        <?php if($tp->user3) : ?>
				<!-- ======= BLOCK FOOTERRIGHT  ======= -->
        <div id="tpblock-footerright"><jdoc:include type="modules" name="user3" style="<?php echo $xhtml; ?>" /></div>
        <?php endif; ?>
        <div class="clrfix"></div>
    </div>
</div>