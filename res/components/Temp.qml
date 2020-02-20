import QtQuick 2.0
import QtQuick.Controls 1.0

 Rectangle{
       anchors.centerIn: parent
       height: 200
       width: 500
       radius: 5
       color: "gray"
       Component {
           id:comp_text
           Rectangle{
               height: 50
               width: parent.parent.width/2
               radius: 5
               color: "blue"
           }
       }
       //下面两个方框用于操作 TextInput的一些操作方式
       Rectangle{
           id:rec1
           anchors.left: parent.left
           anchors.leftMargin: 150
           y:10
           height: 40
           width: 60
           radius: 3
           color: mou1.pressed ? "red":"blue"
           MouseArea{
               id:mou1
               anchors.fill: parent
               onClicked: {
                  //mytext.copy()//复制选择的内容
                   //mytext.cut() //剪切选择的内容
                   //mytext.closeSoftwareInputPanel();
                   //mytext.deselect();//删除活动文本选中，意思就是去掉选中框，不选了；
                   //mytext.select(2,5); //选中第2到第5个字符
                   //mytext.selectAll(); //选中全部
                   //mytext.selectWord();// 最接近光标的单词被选中
               }
           }
       }
       Rectangle{
           anchors.right: parent.right
           anchors.rightMargin: 150
           y:10
           height: 40
           width: 60
           radius: 3
           color: mou2.pressed ? "red":"blue"
           MouseArea{
               id:mou2
               anchors.fill: parent
               onClicked: {
                   mytext.paste();//粘贴
               }
           }
       }
       TextInput{
           id:mytext
           height: 50
           width: parent.width
           anchors.centerIn: parent
           color: "red"
           font.pixelSize: 30
           text: "asdfdsfdsfsdf"
           //maximumLength: 5  //最大输入长度，单位是字符，默认32767
           font.bold: true //加粗，默认false
           font.italic: false //是否用斜体,默认false
           font.letterSpacing: 0 //字母之间距离，正表示增加，负表示缩小，0表示默认距离
           font.wordSpacing: 0 //单词之间的距离，说明同上行
           font.strikeout: false //设置字体是否有删除线，默认false
           font.underline: false //设置字体是否有下划线，默认false
           activeFocusOnPress: true //默认true,鼠标点击是否能输入。
           autoScroll: true //文本长度大于宽度时是否滚动，默认true
           readOnly: true  //设置只读
           //inputMask: "you" //替代输入，相当text显示you，个人理解
           //cursorDelegate: comp_text//光标也就是输入区域的高显，该委托起点是输入的终点
           //cursorVisible: false
           //cursorPosition: 200
           //echoMode: TextInput.Password //显示密码符而不是输入的字符
           //echoMode: TextInput.Normal //默认的显示输入的字符
           //echoMode: TextInput.NoEcho //什么都不显示
           //echoMode: TextInput.PasswordEchoOnEdit
           //passwordCharacter: "*k" //设置模式为密码时显示的字符，第一个字母有效
           //设置文本的大小写
           //font.capitalization: Font.MixedCase //不使用大小写改变
           //font.capitalization: Font.AllUppercase //所有的都大写
           //font.capitalization: Font.AllLowercase //所有的都小写
           //font.capitalization: Font.SmallCaps //使用小大写，
           //font.capitalization: Font.Capitalize  //单词的第一个字母大写
           //font.weight: Font.Light
           //font.weight: Font.Normal
           //font.weight: Font.DemiBold
           //font.weight: Font.Bold
           //font.weight: Font.Black
           //文本的对齐方式，顾名思义
           horizontalAlignment: TextInput.AlignHCenter
           //horizontalAlignment: TextInput.AlignLeft
           //horizontalAlignment: TextInput.AlignRight
            selectByMouse: true //是否可以选择文本
            //选择文本的方式，只有selectByMouse为真才有效
           //mouseSelectionMode: TextInput.SelectCharacters //一个字符为单位选择，默认
           //mouseSelectionMode: TextInput.SelectWords      //一个单词为单位选择
            selectedTextColor: "black" //设置选择文本的字体颜色
            selectionColor: "white"    //设置选择框的颜色
            //text:"hello" //输入文本默认显示的，可以修改和增加
            onAccepted: console.log("accepted") //当按下回车键触发该信号
            //需要注意的是当设置了验证器validator或者掩码inputMask时，只有在输入被接受的情况下才能触发
            //validator: IntValidator{bottom: 5;top:120}
            //只接受5-120之内的值，当输入为4按回车时没有触发onAccepted。
//            validator: DoubleValidator{
//                bottom: 10.00
//                top:150.01
//                decimals: 3 //保留小数点位数
//                //notation: DoubleValidator.StandardNotation
//                //notation: DoubleValidator.ScientificNotation
//            }
       }
       Text{//显示编辑文本的只读属性
           id:mytext_read
           color: "green"
           anchors.bottom: parent.bottom
           font.pixelSize: 25
           //text: mytext.acceptableInput + "  " + mytext.canPaste +" " +mytext.inputMethodComposing
           text: mytext.displayText //只读属性，输入的内容
           //选择文本的开始点 + 选择文本 + 选择文本结束
          // text: mytext.selectionStart + " " + mytext.selectedText + " " +mytext.selectionEnd
           //
       }
   }