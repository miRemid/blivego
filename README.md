# bililive-go!
bililive-go!是一个第三方弹幕姬程序
因为主要是用于本人自己直播用，因此很多细节没有处理到位
![主界面](https://i.loli.net/2020/02/18/XLFlU4TH76Bhz8g.png)

# 使用

## 登陆
通过二维码登陆B站，登陆完成后检测当前账号直播间（尚不支持其余房间号监听，如果自己没有直播间将会报错但不会显示，懒）。如果要退出账号，删除static/user文件夹中的cookie文件。
![二维码](https://i.loli.net/2020/03/06/Ldsa9tVJybYOmof.png)

## 开始监听
点击Start按钮，将会开始监听。记录弹幕数量，人气值，礼物总数。弹幕将会出现在屏幕右方，尚不支持更改弹幕显示位置和自定义样式
![image.png](https://i.loli.net/2020/03/06/f8g4rPwelxL7kyB.png)

## 发送弹幕
开启应用后自动打开一个悬浮窗，双击即可发送弹幕，仅支持文本，超过20个字符(?我也没统计)会发送失败
![Peek 2020-03-06 11-22.gif](https://i.loli.net/2020/03/06/9UBV8j7G1LrnR5N.gif)