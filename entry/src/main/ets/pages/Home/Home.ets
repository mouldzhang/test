import router from '@ohos.router'

@Entry
@Component
export  struct Home {
  @State message: string = 'Home';
  @State weekendday : string = ''

  //星期获取组件
  aboutToAppear(){
    this.weekendday = this.getWeekday()
  }
  getWeekday() : string{
    const weekdays = ['星期日', '星期一', '星期二', '星期三',
      '星期四', '星期五', '星期六'];
    return weekdays[new Date().getDay()]
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text('记录心情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 1})
            .alignSelf(ItemAlign.Start)

          Text("搜索昨天发生的事情")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 90})
            .alignSelf(ItemAlign.End)
        }.width("100%")
        .margin({ top : 1})
        .justifyContent(FlexAlign.SpaceAround)

        Divider()
          .strokeWidth(1)
          .color("black")
          .margin(10)
          .width("100%")


        Button('打卡')
          .width(200)
          .height(200)
          .fontSize(36)
          .fontColor("green")
          .fontWeight(FontWeight.Bold)
          .borderWidth(2)
          .borderColor("black")
          .backgroundColor(Color.Transparent)
          .borderRadius(100)
          .margin({ top: 2 })
          .alignSelf(ItemAlign.Center)
          .gesture(
            TapGesture({ count: 1 })
              .onAction(() => {
                router.pushUrl({
                  url: 'pages/Home/daka_page'
                })
              })
          )


        Row() {
        TextClock({timeZoneOffset : -8})
          .format('yy-MM-dd')
          .fontSize(20)
          .margin({ left: 10 })

          Text("温度")
            .fontSize(25)
            .margin({ left: 45 })

          Text(this.weekendday)
            .fontSize(25)
            .margin({ left: 60 })


        }.width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ top: 12 })


        Button("发生心情事件记录")
        // TextInput({
        //   placeholder: "发生心情事件记录"
        // })
          .width(360)
          .height(150)
          .fontColor("black")
          .borderWidth(2)
          .borderColor("black")
          .margin({ top: 10})
          .alignSelf(ItemAlign.Center)
          .backgroundColor(Color.Transparent)
          .gesture(
            TapGesture({ count: 2 })
              .onAction(() => {
                router.pushUrl({
                  url: 'pages/Home/EventPage'
                })
              })
          )



        Row() {
          Button("添加今日BGM")
            .width(130)
            .height(50)
            .backgroundColor(Color.Transparent)
            .borderWidth(2)
            .fontColor("black")


          Button("回顾心情")
            .width(130)
            .height(50)
            .backgroundColor(Color.Transparent)
            .borderWidth(2)
            .fontColor("black")

        }
        .width("100%")
        .margin({ left : 20,top: 15 })
        .justifyContent(FlexAlign.SpaceAround)

        Row() {
          // 音乐展示器
          Image($r('app.media.Music_show'))
            .width(80)
            .height(80)
            .opacity(1)


          Image($r('app.media.Music_s'))
            .width(60)
            .height(60)
            .opacity(1)


          Image($r('app.media.Music_play'))
            .width(60)
            .height(60)
            .opacity(1)



          Image($r('app.media.Music_x'))
            .width(60)
            .height(60)
            .opacity(1)

        }
        .width("100%")
        .margin({ left: 25 ,top: 25 })
        .alignSelf(ItemAlign.Center)
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .padding({ top: 20, bottom: 20 })

    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .backgroundColor("#f3f3f3")
  }
}

