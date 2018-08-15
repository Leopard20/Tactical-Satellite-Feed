// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

#define true  1
#define false 0


class TSF_RscButton_Text
{
	access = 0;
	idc = -1;
	type = CT_BUTTON;
	style = ST_CENTER;
	text = "";
	font = "TahomaB";
	sizeEx = 0.04;
	colorText[] = {1,1,1,1};
	colorDisabled[] = {0.3,0.3,0.3,0};
	colorBackground[] = {0.7,0.7,0.7,0.5};
	colorBackgroundDisabled[] = {0.7,0.7,0.7,0.5};
	colorBackgroundActive[] = {0.1,0.8,0.1,0.5};
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	colorFocused[] = {0.7,0.7,0.7,0.5};
	colorShadow[] = {0,0,0,0};
	shadow = 0;
	colorBorder[] = {0,0,0,1};
	borderSize = 0;
	soundEnter[] = {"",0.1,1};
	soundPush[] = {"",0.1,1};
	soundClick[] = {"",0.1,1};
	soundEscape[] = {"",0.1,1};
	x = 0; y = 0; w = 0.3; h = 0.1;
};

class TSF_RscButton {
	idc = -1;
	type = CT_ACTIVETEXT;
	style = ST_PICTURE;
	x = 0.75; y = 0.5;
	w = 0.2; h = 0.025;
	font = "TahomaB";
	sizeEx = 0.024;
	color[] = { 1, 1, 1, 1 };
	colorActive[] = { 0.5, 1, 0.5, 1 };
	colorDisabled[] = { 1, 1, 1, 1 };
	soundEnter[] = { "", 0, 1 };   // no sound
	soundPush[] = { "", 0, 1 };
	soundClick[] = { "", 0, 1 };
	soundEscape[] = { "", 0, 1 };
	action = "";
	text = "";
	default = false;
};

class TSF_RscText {
	idc = -1;
	type = CT_STATIC;
	style = ST_CENTER;
	text = "";
	font = "TahomaB";
	sizeEx = 0.025;
	colorText[] = { 1, 1, 1, 1 };
	colorBackground[] = {0,0.8,0,0.2};
};

class TSF_SatelliteHUD {
	idd = 53620;
	movingEnable = false;
	enableSimulation = true;
	controlsBackground[] = {};
	objects[] = {};
	
	class controls {
		///_-_-_-_-_ Buttons _-_-_-_-_\\\
		
		class RscButton_1600: TSF_RscButton
		{
			idc = 1600;
			text = "TacticalSatelliteFeed\Pictures\Button_lock.paa"; 
			action = "[] call TSF_fnc_UI_lockCam";
			x = 0.92 * safezoneW + safezoneX;
			y = 0.682 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1601: TSF_RscButton
		{
			idc = 1601;
			text = "TacticalSatelliteFeed\Pictures\Button_NVG.paa";
			action = "[] spawn TSF_fnc_nightVision";
			x = 0.92 * safezoneW + safezoneX;
			y = 0.794 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1602: TSF_RscButton
		{
			idc = 1602;
			text = "TacticalSatelliteFeed\Pictures\prev_units.paa"; 
			action = "-1 call TSF_fnc_UI_nextUnits";
			x = 0.040625 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0196875 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1603: TSF_RscButton_Text
		{
			idc = 1603;
			action = "1 call TSF_fnc_UI_watchUnit";
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1604: TSF_RscButton_Text
		{
			idc = 1604;
			action = "2 call TSF_fnc_UI_watchUnit";
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1605: TSF_RscButton_Text
		{
			idc = 1605;
			action = "3 call TSF_fnc_UI_watchUnit";
			x = 0.185 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1606: TSF_RscButton_Text
		{
			idc = 1606;
			action = "4 call TSF_fnc_UI_watchUnit";
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1607: TSF_RscButton_Text
		{
			idc = 1607;
			action = "5 call TSF_fnc_UI_watchUnit";
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1608: TSF_RscButton_Text
		{
			idc = 1608;
			action = "6 call TSF_fnc_UI_watchUnit";
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1609: TSF_RscButton_Text
		{
			idc = 1609;
			action = "7 call TSF_fnc_UI_watchUnit";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1610: TSF_RscButton_Text
		{
			idc = 1610;
			action = "8 call TSF_fnc_UI_watchUnit";
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1611: TSF_RscButton_Text
		{
			idc = 1611;
			action = "9 call TSF_fnc_UI_watchUnit";
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1612: TSF_RscButton_Text
		{
			idc = 1612;
			action = "10 call TSF_fnc_UI_watchUnit";
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1613: TSF_RscButton
		{
			idc = 1613;
			text = "TacticalSatelliteFeed\Pictures\next_units.paa"; 
			action = "1 call TSF_fnc_UI_nextUnits";
			color[] = { 1, 1, 1, 0.9 };
			colorActive[] = { 0.5, 1, 0.5, 0.9 };
			colorDisabled[] = { 1, 1, 1, 0.9 };
			x = 0.6575 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0196875 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1614: TSF_RscButton
		{
			idc = 1614;
			text = "TacticalSatelliteFeed\Pictures\zoom_out.paa"; 
			//color[] = { 0.8, 0.8, 0.8, 0.9 };
			action = "[10] call TSF_fnc_cam_Zoom";
			x = 0.040625 * safezoneW + safezoneX;
			y = 0.668 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.064 * safezoneH;
		};
		class RscButton_1615: TSF_RscButton
		{
			idc = 1615;
			text = "TacticalSatelliteFeed\Pictures\zoom_reset.paa"; 
			//color[] = { 0.8, 0.8, 0.8, 0.9 };
			action = "[0] call TSF_fnc_cam_Zoom";
			x = 0.040625 * safezoneW + safezoneX;
			y = 0.766 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.064 * safezoneH;
		};
		class RscButton_1616: TSF_RscButton
		{
			idc = 1616;
			text = "TacticalSatelliteFeed\Pictures\zoom_in.paa"; 
			//color[] = { 0.8, 0.8, 0.8, 0.9 };
			action = "[-10] call TSF_fnc_cam_Zoom";
			x = 0.040625 * safezoneW + safezoneX;
			y = 0.57 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.064 * safezoneH;
		};
		class RscButton_1617: TSF_RscButton_Text
		{
			idc = 1617;
			text = "MOVE"; 
			action = "[0] spawn TSF_fnc_moveCommit";
			colorText[] = {0,1,0,1};
			x = 0.764 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		class RscButton_1663: TSF_RscButton_Text
		{
			idc = 1663;
			text = "STOP"; 
			colorText[] = {1,0,0,1};
			action = "[1] spawn TSF_fnc_moveCommit";
			x = 0.6965 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		class RscButton_1654: TSF_RscButton
		{
			idc = 1654;
			text = "TacticalSatelliteFeed\Pictures\Button_delete.paa"; 
			colorActive[] = { 1, 0.1, 0, 1 };
			action = "[] call TSF_fnc_deleteAllPath";
			x = 0.86 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		class RscButton_1618: TSF_RscButton
		{
			idc = 1618;
			text = "TacticalSatelliteFeed\Pictures\Button_Planning.paa";
			action = "[] spawn TSF_fnc_planningMode";
			colorActive[] = { 1, 1, 1, 1};
			color[] = { 0.80, 0.80, 0.80, 1};
			x = 0.92 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1619: TSF_RscButton
		{
			idc = 1619;
			text = "TacticalSatelliteFeed\Pictures\Button_noDraw.paa"; 
			action = "1 call TSF_fnc_switchDraw";
			colorActive[] = { 0.9, 1, 0.8, 0};
			color[] = { 0.8, 0.8, 0.8, 0};
			x = 1.0525 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1655: TSF_RscButton
		{
			idc = 1655;
			text = "TacticalSatelliteFeed\Pictures\Button_singleDraw.paa"; 
			action = "2 call TSF_fnc_switchDraw";
			colorActive[] = { 0.9, 1, 0.8, 0};
			color[] = { 0.8, 0.8, 0.8, 0};
			x = 1.0525 * safezoneW + safezoneX;
			y = 0.234 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1656: TSF_RscButton
		{
			idc = 1656;
			text = "TacticalSatelliteFeed\Pictures\Button_hidePath.paa"; 
			action = "3 call TSF_fnc_switchDraw";
			colorActive[] = { 0.9, 1, 0.8, 0};
			color[] = { 0.8, 0.8, 0.8, 0};
			x = 1.0525 * safezoneW + safezoneX;
			y = 0.122 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1661: TSF_RscButton
		{
			idc = 1661;
			text = "TacticalSatelliteFeed\Pictures\Button_record.paa"; 
			action = "[] spawn TSF_fnc_drawPathFPS";
			colorActive[] = { 1, 1, 1, 1};
			color[] = { 0.82, 0.82, 0.82, 1};
			x = 0.92 * safezoneW + safezoneX;
			y = 0.570 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1662: TSF_RscButton
		{
			idc = 1662;
			text = "TacticalSatelliteFeed\Pictures\Button_refresh.paa"; 
			action = "[] spawn TSF_fnc_refresh";
			colorActive[] = { 0.9, 1, 0.9, 1};
			color[] = { 0.82, 0.82, 0.82, 1};
			x = 0.92 * safezoneW + safezoneX;
			y = 0.458 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		///_-_-_-_-_ Texts _-_-_-_-_\\\
		
		class RscText_1620: TSF_RscText
		{
			idc = 1620;
			text = "1"; 
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1621: TSF_RscText
		{
			idc = 1621;
			text = "2"; 
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1622: TSF_RscText
		{
			idc = 1622;
			text = "3"; 
			x = 0.185 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1623: TSF_RscText
		{
			idc = 1623;
			text = "4"; 
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1624: TSF_RscText
		{
			idc = 1624;
			text = "5"; 
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1625: TSF_RscText
		{
			idc = 1625;
			text = "6"; 
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1626: TSF_RscText
		{
			idc = 1626;
			text = "7"; 
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1627: TSF_RscText
		{
			idc = 1627;
			text = "8"; 
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1628: TSF_RscText
		{
			idc = 1628;
			text = "9"; 
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1629: TSF_RscText
		{
			idc = 1629;
			text = "10"; 
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class RscText_1630: TSF_RscText
		{
			idc = 1630;
			text = "1"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1631: TSF_RscText
		{
			idc = 1631;
			text = "2"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1632: TSF_RscText
		{
			idc = 1632;
			text = "3"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.185 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1633: TSF_RscText
		{
			idc = 1633;
			text = "4"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1634: TSF_RscText
		{
			idc = 1634;
			text = "5"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1635: TSF_RscText
		{
			idc = 1635;
			text = "6"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1636: TSF_RscText
		{
			idc = 1636;
			text = "7"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1637: TSF_RscText
		{
			idc = 1637;
			text = "8"; 
			colorBackground[] = {0,0,0,0};
			sizeEx = 0.04;
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1638: TSF_RscText
		{
			idc = 1638;
			text = "9"; 
			sizeEx = 0.04;
			colorBackground[] = {0,0,0,0};
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		class RscText_1639: TSF_RscText
		{
			idc = 1639;
			text = "10"; 
			sizeEx = 0.04;
			colorBackground[] = {0,0,0,0};
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.065 * safezoneH;
		};
		
		///_-_-_-_-_ Main Radial _-_-_-_-_\\\
		
		class RscButton_1640: TSF_RscButton
		{
			idc = 1640;
			text = "TacticalSatelliteFeed\Pictures\mount.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_RadialDraw == 1) then {[0] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1641: TSF_RscButton
		{
			idc = 1641;
			text = "TacticalSatelliteFeed\Pictures\goCode_Add.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "[1] spawn TSF_fnc_drawRadial";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1642: TSF_RscButton
		{
			idc = 1642;
			text = "TacticalSatelliteFeed\Pictures\fireMode.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "[2] spawn TSF_fnc_drawRadial";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1643: TSF_RscButton
		{
			idc = 1643;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\attack.paa"; 
			action = "if (TSF_RadialDraw == 1) then {[1] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		//Extra
		
		class RscButton_1657: TSF_RscButton
		{
			idc = 1657;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\extra.paa"; 
			action = "[3] spawn TSF_fnc_drawRadial";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1658: TSF_RscButton
		{
			idc = 1658;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\grenade.paa"; 
			action = "if (TSF_RadialDraw == 1) then {[7] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1659: TSF_RscButton
		{
			idc = 1659;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\EHM.paa"; 
			action = "if (TSF_RadialDraw == 1) then {[8] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1660: TSF_RscButton
		{
			idc = 1660;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\extra.paa"; 
			action = "[4] spawn TSF_fnc_drawRadial";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		///_-_-_-_-_ Go Radial _-_-_-_-_\\\
		
		class RscButton_1644: TSF_RscButton
		{
			idc = 1644;
			text = "TacticalSatelliteFeed\Pictures\goCode_A.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_RadialDraw == 1) then {[2] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1645: TSF_RscButton
		{
			idc = 1645;
			text = "TacticalSatelliteFeed\Pictures\goCode_B.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_RadialDraw == 1) then {[3] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1646: TSF_RscButton
		{
			idc = 1646;
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\goCode_C.paa"; 
			action = "if (TSF_RadialDraw == 1) then {[4] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		///_-_-_-_-_ Fire Radial _-_-_-_-_\\\
		
		class RscButton_1647: TSF_RscButton
		{
			idc = 1647;
			text = "TacticalSatelliteFeed\Pictures\openFire.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_RadialDraw == 1) then {[5] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1648: TSF_RscButton
		{
			idc = 1648;
			text = "TacticalSatelliteFeed\Pictures\holdFire.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 0.5, 1, 0.5, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_RadialDraw == 1) then {[6] spawn TSF_fnc_addAction; TSF_RadialDraw = 0;}";
			x = safezoneX;
			y = safezoneY;
			w = 0.046 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		///_-_-_-_-_ Selection _-_-_-_-_\\\
		
		class RscSelection
		{
			idc = 1649;
			type = CT_STATIC;
			style = ST_PICTURE;
			colorText[] = { 1, 1, 1, 0 };
			colorBackground[] = { 1, 1, 1, 0 };
			text = "TacticalSatelliteFeed\Pictures\selection.paa"; 
			font = "TahomaB";
			sizeEx = 0.04;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
		};
		
		///_-_-_-_-_ GoCodes _-_-_-_-_\\\
		
		class RscButton_1650: TSF_RscButton
		{
			idc = 1650;
			text = "TacticalSatelliteFeed\Pictures\Button_A.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_showGoCodeMenu) then {player setVariable ['TSF_goCodeTriggeredA', true]}";
			x = safezoneX - 0.0525 * safezoneW;
			y = safezoneY + 0.14*safezoneH;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1651: TSF_RscButton
		{
			idc = 1651;
			text = "TacticalSatelliteFeed\Pictures\Button_B.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_showGoCodeMenu) then {player setVariable ['TSF_goCodeTriggeredB', true]}";
			x = safezoneX - 0.0525 * safezoneW;
			y = safezoneY + 0.25*safezoneH;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class RscButton_1652: TSF_RscButton
		{
			idc = 1652;
			text = "TacticalSatelliteFeed\Pictures\Button_C.paa"; 
			color[] = { 1, 1, 1, 0 };
			colorActive[] = { 1, 1, 1, 0 };
			colorDisabled[] = { 1, 1, 1, 0 };
			action = "if (TSF_showGoCodeMenu) then {player setVariable ['TSF_goCodeTriggeredC', true]}";
			x = safezoneX - 0.0525 * safezoneW;
			y = safezoneY + 0.36*safezoneH;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};

		
		class RscEmptyBackground
		{
			idc = 1653;
			type = CT_STATIC;
			style = ST_PICTURE;
			colorText[] = { 1, 1, 1, 0 };
			colorBackground[] = { 0, 0, 0, 0 };
			text = ""; 
			font = "TahomaB";
			sizeEx = 0.04;
			x = safezoneX-0.07 * safezoneW;
			y = safezoneY + 0.1*safezoneH;
			w = 0.07 * safezoneW;
			h = 0.28 * safezoneH;
		};
	};
};