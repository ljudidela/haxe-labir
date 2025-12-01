package ui;

import h2d.Object;
import h2d.Flow;
import h2d.Text;
import hxd.Event;
import hxd.Key;
import h2d.Font;

class Menu extends Object {
    var main:Main;
    var flow:Flow;
    var items:Array<Text> = [];
    var selectedIndex:Int = 0;
    var options = [
        { label: "NEW GAME", action: "new" },
        { label: "CONTINUE", action: "continue" },
        { label: "SETTINGS", action: "settings" },
        { label: "EXIT", action: "exit" }
    ];

    public function new(parent:Object, main:Main) {
        super(parent);
        this.main = main;
        createUI();
        
        // Input handling
        getScene().addEventListener(onEvent);
    }

    function createUI() {
        var title = new Text(hxd.res.DefaultFont.get(), this);
        title.text = "FATAL LABYRINTH";
        title.scale(4);
        title.textColor = 0xFF0000;
        title.x = (getScene().width - title.textWidth * 4) / 2;
        title.y = 100;

        flow = new Flow(this);
        flow.layout = Vertical;
        flow.verticalSpacing = 20;
        flow.x = (getScene().width) / 2;
        flow.y = 300;

        for (i in 0...options.length) {
            var t = new Text(hxd.res.DefaultFont.get(), flow);
            t.text = options[i].label;
            t.scale(2);
            // Center text in flow
            t.x = -t.textWidth;
            items.push(t);
        }
        updateSelection();
    }

    function updateSelection() {
        for (i in 0...items.length) {
            if (i == selectedIndex) {
                items[i].textColor = 0xFFFF00;
                items[i].x = -items[i].textWidth - 20; // Simple visual shift
            } else {
                items[i].textColor = 0xFFFFFF;
                items[i].x = -items[i].textWidth;
            }
        }
    }

    function onEvent(e:Event) {
        if (e.kind == EKeyDown) {
            if (e.keyCode == Key.UP) {
                selectedIndex--;
                if (selectedIndex < 0) selectedIndex = options.length - 1;
                updateSelection();
            } else if (e.keyCode == Key.DOWN) {
                selectedIndex++;
                if (selectedIndex >= options.length) selectedIndex = 0;
                updateSelection();
            } else if (e.keyCode == Key.ENTER) {
                executeAction(options[selectedIndex].action);
            }
        }
    }

    function executeAction(action:String) {
        getScene().removeEventListener(onEvent);
        switch(action) {
            case "new": main.startGame(false);
            case "continue": main.startGame(true);
            case "settings": 
                // Mock settings
                trace("Settings opened");
                getScene().addEventListener(onEvent); // Re-bind
            case "exit": main.exitGame();
        }
    }
}