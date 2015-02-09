import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JRootPane;

import de.javasoft.plaf.synthetica.SyntheticaLogoRenderer;

@SuppressWarnings("serial")
class LogoRenderer extends JLabel implements SyntheticaLogoRenderer
{
  public JComponent getRendererComponent(JRootPane root, boolean windowIsActive)
  {
    return this;
  }
} 