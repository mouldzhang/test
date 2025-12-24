@Entry
@Component
struct EventPage {
  build() {
    Column({space:10}) {
      Button("← 返回")
        .onClick(() => {

        })
        .fontColor(Color.Black)
        .backgroundColor(Color.Transparent)
        .alignSelf(ItemAlign.Start)
        


      Text("记录心情事件时刻")
        .fontColor(Color.Black)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')

      Divider()
        .color(Color.Black)
        .height(4)
        .margin({ top: 10, bottom: 10 })
        .width('100%')

      Text("今日心情：**")
        .fontColor(Color.Black)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)

      TextInput()
        .fontColor(Color.Black)
        .height(200)
        .backgroundColor("#dedfe0")
        .textAlign(TextAlign.Start)
        .padding({ left: 10, top: 5 })


      Row(){
        Button("取消")
          .fontColor(Color.Black)
          .backgroundColor("#8b8c8f")
          .borderRadius(8)
          .onClick(() => {

          })
        Button("确定")
          .fontColor(Color.Black)
          .backgroundColor("#81bffe")
          .borderRadius(8)
          .margin({ left: 50 })
          .onClick(() => {

          })
      }
    }
    .height('100%')
    .width('100%')

  }
}