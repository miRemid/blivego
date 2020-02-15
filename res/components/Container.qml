import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.13

Rectangle {
    id: "block"    

    width: 800
    height: 500

    property int step: 10;   //鼠标的检测区域尺寸
    property var mouseOld;   //鼠标按下时的坐标
    property var mouseNew;   //鼠标移动时的坐标

    //是否点击
    property bool isclicked: false;
    //鼠标状态
    property int mouseState: 0;

    MouseArea {
        id: mouse_area;
        hoverEnabled: block.focus;
        anchors.fill: block;

        onPressed:{
            block.focus=true;
            block.isclicked=true;
            mouseOld=parent.mapToItem(parent.parent,mouseX,mouseY);

            mouse.accepted=true;
        }
        onReleased:{
            block.isclicked=false;
            mouse.accepted=true;
        }
        onPositionChanged: {
            if(block.isclicked)
            {
                mouseNew=parent.mapToItem(parent.parent,mouseX,mouseY);

                switch(mouseState)
                {
                case 0:
                case 5:
                    block.x=block.x+mouseNew.x-mouseOld.x;
                    block.y=block.y+mouseNew.y-mouseOld.y;
                    break;

                case 1:
                    block.width=block.width-mouseNew.x+mouseOld.x;
                    block.height=block.height-mouseNew.y+mouseOld.y;
                    if(block.width>25)
                    block.x=block.x+mouseNew.x-mouseOld.x;
                    if(block.height>25)
                    block.y=block.y+mouseNew.y-mouseOld.y;
                    break;

                case 2:
                    block.width=block.width-mouseNew.x+mouseOld.x;
                    if(block.width>25)
                    block.x=block.x+mouseNew.x-mouseOld.x;
                    break;

                case 3:
                    block.width=block.width-mouseNew.x+mouseOld.x;
                    block.height=block.height+mouseNew.y-mouseOld.y;
                    if(block.width>25)
                    block.x=block.x+mouseNew.x-mouseOld.x;
                    break;

                case 4:
                    block.height=block.height-mouseNew.y+mouseOld.y;
                    if(block.height>25)
                    block.y=block.y+mouseNew.y-mouseOld.y;
                    break;

                case 6:
                    block.height=block.height+mouseNew.y-mouseOld.y;
                    break;

                case 7:
                    block.height=block.height-mouseNew.y+mouseOld.y;
                    block.width=block.width+mouseNew.x-mouseOld.x;
                    if(block.height>25)
                    block.y=block.y+mouseNew.y-mouseOld.y;
                    break;

                case 8:
                    block.width=block.width+mouseNew.x-mouseOld.x;
                    break;

                case 9:
                    block.width=block.width+mouseNew.x-mouseOld.x;
                    block.height=block.height+mouseNew.y-mouseOld.y;
                    break;
                default:

                }
                //这里的两个if是限制block的最小尺寸，防止缩小到看不见。
                if(block.width<=25)
                    block.width=25;

                if(block.height<=25)
                    block.height=25;

                mouseOld=mouseNew;
            }
            else
            {
                if(mouseX<block.step&&mouseX>=0)
                {
                    if(0<=mouseY&&mouseY<block.step){
                        mouseState=1;
                        mouse_area.cursorShape= Qt.SizeFDiagCursor;
                    }
                    else if((block.height-block.step)<mouseY&&mouseY<=block.height){
                        mouseState=3;
                        mouse_area.cursorShape= Qt.SizeBDiagCursor;
                    }
                    else if(block.step<=mouseY&&mouseY<=block.height-block.step){
                        mouseState=2;
                        mouse_area.cursorShape= Qt.SizeHorCursor;
                    }
                }
                else if(block.width-block.step<mouseX&&mouseX<=block.width)
                {
                    if(0<=mouseY&&mouseY<block.step){
                        mouseState=7;
                        mouse_area.cursorShape= Qt.SizeBDiagCursor;
                    }
                    else if((block.height-block.step)<mouseY&&mouseY<=block.height){
                        mouseState=9;
                        mouse_area.cursorShape= Qt.SizeFDiagCursor;
                    }
                    else if(block.step<=mouseY&&mouseY<=block.height-block.step){
                        mouseState=8;
                        mouse_area.cursorShape= Qt.SizeHorCursor;
                    }
                }
                else if(block.width-block.step>=mouseX&&mouseX>=block.step)
                {
                    if(0<=mouseY&&mouseY<block.step){
                        mouseState=4;
                        mouse_area.cursorShape= Qt.SizeVerCursor;
                    }
                    else if((block.height-block.step)<mouseY&&mouseY<=block.height){
                        mouseState=6;
                        mouse_area.cursorShape= Qt.SizeVerCursor;
                    }
                    else if(block.step<=mouseY&&mouseY<=block.height-block.step){
                        mouseState=5;
                        mouse_area.cursorShape=Qt.ArrowCursor;
                    }
                }
            }
            mouse.accepted=true;
        }
    }

    onFocusChanged: {
        if(!block.focus)
        {
            mouse_area.cursorShape=Qt.ArrowCursor;
            mouseState=0;
        }
    }

}
