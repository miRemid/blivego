import QtQuick 2.0
import QtQuick.Controls 1.0

Item {
    property int frame_width: 95
    property int frame_height:95
    property int frame_count:10
    property int frame_duration: 100
    property url image_url: "https://i.loli.net/2019/11/03/r7vSwJsUzfWxYmk.jpg"
    property string btn_title: "Computer Clear"
    property int clickType: 0

    signal signalClickBtn(int click_type);
    clip: true //动画逐帧执行的时候需要设置为true

    width: frame_width
    height: frame_height + text_id.height

    MouseArea{
        id: ma
        anchors.fill: animated
        hoverEnabled: true

		// 定义延时执行动作，因为鼠标在button上快速晃动时，动画瞬间开始、停止，效果不是很好。所以策略改为：
		// 移入时显示填充色，即动画的最后1帧；100ms时间到后，再开始动画
        Timer{
            id: delay_tmer
            interval: 100
            running: false
            repeat: false

            onTriggered:
            {
                animated.currentFrame = 0
                animated.running = true
                animated.resume()
            }
        }

        onEntered:{
        	// 鼠标移入时，显示为动画的第9帧填充图，以实现移入瞬间的hover效果；
        	// 测试中发现，只要指定序列值即可达到切换效果，完全不需要动画开启再暂停；
            animated.currentFrame = 9
            delay_tmer.running = true;
        }

        onExited:{
        	// 鼠标移出时，停定时器，停动画
            delay_tmer.running = false;
            animated.currentFrame = 0
            animated.pause()
        }

        onClicked:{
            signalClickBtn(0)
        }
    }

    AnimatedSprite{
        id: animated
        width: frame_width
        height:frame_height
        source: image_url
        frameWidth: frame_width
        frameHeight: frame_height
        frameDuration: frame_duration
        frameCount: frame_count

        frameX: 0
        frameY: 0
        currentFrame: 0
        running: false;

        onCurrentFrameChanged:{
            if(currentFrame == frameCount - 1){
                console.debug("animation finished...")
                animated.pause();
                animated.running = false
            }
        }
    }


    Text{
        id: text_id
        text:  btn_title
        height: 30
        // 很神奇，AnimationSprite是继承自Item的，具有anchor属性，底部做对齐的方式可用；
        anchors.top: animated.bottom
    }
}