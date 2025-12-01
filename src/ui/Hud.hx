package ui;

import h2d.Object;
import h2d.Flow;
import h2d.Text;
import entities.Player;
import game.GameWorld;

class Hud extends Object {
    var player:Player;
    var world:GameWorld;
    var statsText:Text;
    var logText:Text;

    public function new(parent:Object, player:Player) {
        super(parent);
        this.player = player;
        
        // Right panel
        var panel = new h2d.Graphics(this);
        panel.beginFill(0x333333);
        panel.drawRect(0, 0, 300, 720);
        panel.x = 900;
        panel.y = 0;

        statsText = new Text(hxd.res.DefaultFont.get(), this);
        statsText.x = 920;
        statsText.y = 20;
        statsText.scale(1.5);

        logText = new Text(hxd.res.DefaultFont.get(), this);
        logText.x = 50;
        logText.y = 600;
        logText.scale(1.2);
        logText.textColor = 0xAAAAAA;
    }

    public function updateStats(level:Int) {
        statsText.text = 
            "FATAL LABYRINTH
" +
            "----------------
" +
            "Floor: " + level + "

" +
            "HP: " + player.hp + " / " + player.maxHp + "
" +
            "Gold: " + player.gold + "

" +
            "Inventory:
" +
            "- Potion
" +
            "- Sword";
    }

    public function updateLog(messages:Array<String>) {
        logText.text = messages.join("
");
    }
}