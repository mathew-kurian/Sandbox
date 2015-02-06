						<form class="form-validate" name="josForm" id="josForm" method="post" action="<?php echo JRoute::_( 'index.php?option=com_user' ); ?>">
							<p>
								<label for="name" id="namemsg"><strong><?php echo JText::_('NAME'); ?></strong></label>
								<input type="text" maxlength="50" class="inputbox-xtd required" value="" size="40" id="name" name="name"/> 
							</p>
							

							<p>
								<label for="username" id="usernamemsg"><strong><?php echo JText::_('USERNAME'); ?></strong></label>

								<input type="text" maxlength="25" class="inputbox-xtd required validate-username" value="" size="40" name="username" id="username"/> 
							</p>
							

							<p>
									<label for="email" id="emailmsg"><strong><?php echo JText::_('EMAIL'); ?></strong></label>

								<input type="text" maxlength="100" class="inputbox-xtd required validate-email" value="" size="40" name="email" id="email"/> 
							</p>
							

							<p>
								<label for="password" id="pwmsg"><strong><?php echo JText::_('PASSWORD'); ?></strong></label>

								<input type="password" value="" size="40" name="password" id="password" class="inputbox-xtd required validate-password"/> 
							</p>
							

							<p>
								<label for="password2" id="pw2msg"><strong><?php echo JText::_('VERIFY PASSWORD'); ?></strong></label>

								<input type="password" value="" size="40" name="password2" id="password2" class="inputbox-xtd required validate-passverify"/> 
							</p>
							
							<button type="submit" class="button validate"><?php echo JText::_('REGISTER'); ?></button>
							<input type="hidden" value="register_save" name="task"/>
							<input type="hidden" value="0" name="id"/>
							<input type="hidden" value="0" name="gid"/>
							<?php echo JHTML::_( 'form.token' ); ?>
						</form>