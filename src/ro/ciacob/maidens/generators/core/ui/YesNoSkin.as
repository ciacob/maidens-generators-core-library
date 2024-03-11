package ro.ciacob.maidens.generators.core.ui {

import spark.skins.mobile.ToggleSwitchSkin;

public class YesNoSkin extends ToggleSwitchSkin {
    public function YesNoSkin() {
        super();

        // No labels; they look bad anyway. Mere color will do. I added non-breaking spaces to size the control instead.
        selectedLabel = "  ";
        unselectedLabel = "  ";
    }
}
}
