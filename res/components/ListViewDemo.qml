import QtQuick 2.12
import QtQuick.Controls 2.13

Item {
    Rectangle{
        x:20
        y:20
        height: 50
        width: 50
        radius: 5
        color: mous.pressed ? "red" :"gray"
        Text {
            anchors.centerIn: parent
            font.pixelSize: 30
            text: qsTr("+")
        }
        MouseArea{//一些操作获取方式
            id:mous
            anchors.fill: parent
            onClicked: {
                mylist.incrementCurrentIndex();
                mylist.model.append({"name":"黄昏","score":88})//追加了一项数据
                //mylist.model.insert(2,{"name":"落日","score":88})//插入一项数据，index为2
                //mylist.model.move(0,5,2);//移动，第一个参数表示从index为0开始，移动个数为第三个参数
                                            //第二个参数为移动后的index
                //mylist.model.set(2,{"name":"落日","score":88})//重新设置改变index为2的数据值
                //注意，如果set的index值等于count，则添加一个新的数据，相当append。
                //mylist.model.setProperty(2,"name","夕阳")//设置index数据，一次只能设置一个。index得小count
                //mylist.model.sync()// can only be called from a WorkerScript
            }
        }
    }
    Rectangle{
        x:960
        y:20
        height: 50
        width: 50
        radius: 5
        color: mous1.pressed ? "red" :"gray"
        Text {
            anchors.centerIn: parent
            font.pixelSize: 30
            text: qsTr("-")
        }
        MouseArea{//一些操作获取方式
            id:mous1
            anchors.fill: parent
            onClicked: {//mylist.decrementCurrentIndex();
                //mylist.model.clear();//全部清除数据
                //console.log(mylist.model.get(1).score);//get获取到第几个Index的信息
                //mylist.model.remove(1);//删除掉参数对应的index数据
            }
        }
    }
    Component{
        id:myfooter
        Rectangle{
            height: 50
            width: 400
            color: "red"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                text: mylist.count
            }
        }
    }
    Component{
        id:myheader
        Rectangle{
            height: 50
            width: 400
            color: "red"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 15
                text: "count:" + mylist.count + "  currentSection:" + mylist.currentSection
            }
        }
    }
    Component{
        id:myhighlight
        Rectangle{
            z:2
            height: 50
            width: 400
            color: "green"
        }
    }
    ListView {
        id:mylist
        height: 400
        width: 400
        y:50
        anchors.horizontalCenter: parent.horizontalCenter
        // count: 5 //只读属性
        //currentSection: 只读属性
        //currentIndex: 2//当前项
        spacing: 10 //子项之间的间隙
        footer:myfooter //列表的页脚，类型Component
        //header: myheader //列表的标题或者说是头部
        //highlight: myhighlight  //高亮显示
        //highlightFollowsCurrentItem: true//当前项改变的时候，高亮显示会跟着移动
        //highlightMoveDuration: 500
        //highlightMoveSpeed: 200 //高亮的移动速度
        //highlightRangeMode: ListView.ApplyRange
        //ListView.StrictlyEnforceRange
        //ListView.NoHighlightRange
        //highlightResizeDuration: 100
            //highlightResizeSpeed: 500
        //highlightItem只读属性
        // preferredHighlightBegin: 2
        //preferredHighlightEnd: 5
        keyNavigationWraps: true  //当前项头尾互切（到达最后一项再增加到下一项即可返回第一项）incrementCurrentIndex()
        //orientation: ListView.Horizontal//列表的方向，水平
        orientation:ListView.Vertical //默认垂直方向
        layoutDirection: Qt.LeftToRight //水平布局方向
        //layoutDirection: Qt.RightToLeft
        //section.criteria: ViewSection.FullString //
        //section.criteria: ViewSection.FirstCharacter
        //section.delegate: myheader
        //section.property: "hello"
        //snapMode: ListView.NoSnap //拖动停止设置默认，可见区域任意点可停止
        //snapMode: ListView.SnapToItem //
        //snapMode: ListView.SnapOneItem//移动一个Item，对于一次翻转一个界面很有用
        delegate: mycomponent //委托，进行实例显示
        model:mymodel //myvisual//数据模型
        //数据模型有， ListModel ,XmlListModel,VisualItemModel，还有C++提供的数据模型
        
        
        Component{//Component把元素封装成一个组件，作为列表的委托，实例显示
                    //一个.qml文件也是一个组件，一样可以最委托
            id:mycomponent
            Rectangle{
                height: 60
                width: 400
                //color: mylist.isCurrentItem ? "red" : "gray"//是否为当前项，我的没起作用
                color: mylist.currentIndex ==index ? "red" : "gray"//当前光标是否等于index，个人感觉和isCurrentItem这个属性是一样的作用
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: 25
                    text:name +": " +score //从数据模型里面获取的数据
                }
            }
        }
        ListModel{//简单的ListElement容器
            id:mymodel
            ListElement{name:"张三";score:82} //可以添加很多数据内容，委托给delegate显示
            ListElement{name:"李四";score:75}
            ListElement{name:"王五";score:96}
            ListElement{name:"黄六";score:76}
            ListElement{name:"启华";score:25}
            ListElement{name:"京东";score:68}
            ListElement{name:"淘宝";score:35}
            ListElement{name:"乐视";score:46}
            ListElement{name:"三星";score:78}
            ListElement{name:"华为";score:59}
            ListElement{name:"电信";score:82}
            ListElement{name:"移动";score:52}
            ListElement{name:"小米";score:99}
            ListElement{name:"联通";score:27}
            ListElement{name:"魅族";score:89}
        }
        VisualItemModel{//使用VisualItemModel数据模型不需要委托显示
                        //数据模型中是是含有元素的，根据index来显示不同的item
            id:myvisual
            Rectangle{height: 100;width: 400;radius: 5;color: "red"}
            Rectangle{height: 100;width: 400;radius: 5;color: "blue"}
            Rectangle{height: 100;width: 400;radius: 5;color: "yellow"}
            Rectangle{height: 100;width: 400;radius: 5;color: "#567890"}
            Rectangle{height: 100;width: 400;radius: 5;color: "#887766"}
        }
    }
}